//
//  PMDebugService.m
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import "PMService.h"
#import "PMLogDataModel.h"
#import "PMLogViewController.h"
#import "PMWindow.h"
#import "PMRootViewController.h"
#import "PMDataSourceFactory.h"
#import "PMLog.h"
#import <objc/runtime.h>
#import "PMMonitorView.h"

static dispatch_queue_t     serialQueue = nil;
static NSUInteger           logWaitingCount = 0;
static NSString             *logLock = @"logLock";
static NSMutableArray       *logWaitingArray = nil;

@interface PMService ()

@property(nonatomic, strong) PMWindow               *pmWindow;
@property(nonatomic, strong) UIWindow               *appWindow;
@property(nonatomic, assign) BOOL                   isEnable;

@end


static PMService *shareInstance = nil;

@implementation PMService

+ (instancetype)shareInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[PMService alloc] init];
        serialQueue = dispatch_queue_create("com.PoseidonMonitor.queue", DISPATCH_QUEUE_SERIAL);
        [[NSNotificationCenter defaultCenter] addObserver:shareInstance
                                                 selector:@selector(detectNotif:)
                                                     name:kNotifPMDetectWebView
                                                   object:nil];
    });
    
    return shareInstance;
}

+ (void)load
{
    [self shareInstance];
}

+ (BOOL)isEnable
{
    return shareInstance.isEnable;
}

- (void)detectNotif:(NSNotification *)notif
{
    if (notif.object) {
        if (!self.isEnable) {
            [self start];
        }
    } else {
        if (self.isEnable) {
            [self stop];
        }
    }
}

+ (void)PMLog:(NSDictionary *)userInfo
{
    if (userInfo.count == 0) {
        return;
    }
    
    NSString *log = [userInfo objectForKey:@"log"];
    int logType = [[userInfo objectForKey:@"logType"] intValue];
    NSString *fileName = [userInfo objectForKey:@"fileName"];
    NSString *functionName = [userInfo objectForKey:@"functionName"];
    int functionLineNumber = [[userInfo objectForKey:@"functionLineNumber"] intValue];
    NSString *biz = [userInfo objectForKey:@"biz"];
    [self log:log logType:logType fileName:fileName functionName:functionName functionLineNumber:functionLineNumber biz:biz];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (UIWindow *)appWindow
{
    if (!_appWindow) {
        _appWindow = [UIApplication sharedApplication].keyWindow ?: [[[UIApplication sharedApplication] delegate] window];
    }
    
    return _appWindow;
}

- (PMWindow *)pmWindow
{
    if (!_pmWindow) {
        _pmWindow = [[PMWindow alloc] initWithFrame:CGRectMake(2, CGRectGetHeight([UIScreen mainScreen].bounds) - 100, 80, 80)];
        _pmWindow.windowLevel = UIWindowLevelAlert + 1;
    }
    
    return _pmWindow;
}

#pragma mark - public

- (void)start
{
    self.isEnable = YES;
    self.pmWindow.backgroundColor = [UIColor clearColor];
    self.pmWindow.hidden = NO;
}

- (void)stop
{
    self.isEnable = NO;
    self.pmWindow.hidden = YES;
}

+ (void)log:(NSString *)log
            logType:(PMLogType)logType
           fileName:(NSString *)fileName
       functionName:(NSString *)functionName
 functionLineNumber:(NSInteger)functionLineNumber
                biz:(NSString *)biz
{
    PMLogDataModel *dataModel = [[PMLogDataModel alloc] init];
    dataModel.biz = biz ?: kLogBizDefault;
    dataModel.logType = logType;
    dataModel.log = log;
    dataModel.fileName = fileName;
    dataModel.functionName = functionName;
    dataModel.functionLineNumber = functionLineNumber;
    
    @synchronized(logLock) {
        logWaitingCount++;
        if (!logWaitingArray) {
            logWaitingArray = [NSMutableArray array];
        }
    }
    
    dispatch_async(serialQueue, ^{
        NSDate* date = [NSDate date];
        NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat = [NSString stringWithFormat:@"yyyy-MM-dd HH:mm:ss.SSS"];
        NSString* dateString = [dateFormatter stringFromDate:date];
        dataModel.dateStr = dateString;
        [dataModel calculateHeight];
        
        [logWaitingArray addObject:dataModel];
        int flushCount = 10;
        
        if (logWaitingCount < 100) {
            flushCount = 10;
        } else if (logWaitingCount < 300) {
            flushCount = 20;
        } else if (logWaitingCount < 500) {
            flushCount = 30;
        } else if (logWaitingCount < 800) {
            flushCount = 40;
        } else if (logWaitingCount < 1000) {
            flushCount = 50;
        } else {
            flushCount = 100;
        }

        if (logWaitingArray.count >= flushCount || 1 == logWaitingCount) {
            NSArray *logs = [NSArray arrayWithArray:logWaitingArray];
            dispatch_async(dispatch_get_main_queue(), ^{
                [[PMDataSourceFactory getPMLogDataSource] addLogs:logs];
            });
            [logWaitingArray removeAllObjects];
        }
        
        @synchronized(logLock) {
            logWaitingCount--;
        }
    });
}

@end
