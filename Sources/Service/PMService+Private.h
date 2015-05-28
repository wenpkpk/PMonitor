//
//  PMService+Private.h
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-9.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "PMService.h"
#import "PMWindow.h"
#import "PMMonitorView.h"

@interface PMService (Private)

@property(nonatomic, strong) PMWindow               *pmWindow;
@property(nonatomic, strong) PMMonitorView          *rootView;


+ (BOOL)isEnable;

+ (void)log:(NSString *)log
    logType:(PMLogType)logType
   fileName:(NSString *)fileName
functionName:(NSString *)functionName
functionLineNumber:(NSInteger)functionLineNumber
        biz:(NSString *)biz;

@end
