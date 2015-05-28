//
//  PMLogDataSource.m
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import "PMLogDataSource.h"
#import "PMLogDataModel.h"
#import "PMConfigFactory.h"

@interface PMLogDataSource ()

@property(nonatomic, strong) NSMutableArray         *logs; // 所有log
@property(nonatomic, strong) NSMutableDictionary    *logDict; // log 与 biz对应关系 key：biz，value：logs的Index
@property(nonatomic, strong) NSArray                *filterBizes; // 过滤业务类型
@property(nonatomic, strong) NSMutableArray         *filterLogs; // 过滤的log 映射
@property(nonatomic, assign) BOOL                   didUpdateLogs;

@end


@implementation PMLogDataSource

- (NSMutableArray *)logs
{
    if (!_logs) {
        _logs = [NSMutableArray array];
    }
    
    return _logs;
}

- (NSMutableArray *)filterLogs
{
    if (!_filterLogs) {
        _filterLogs = [NSMutableArray array];
    }
    
    return _filterLogs;
}

- (NSMutableDictionary *)logDict
{
    if (!_logDict) {
        _logDict = [NSMutableDictionary dictionary];
    }
    
    return _logDict;
}

- (void)postDidUpdateNotif
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifPMLogDataSourceDidUpdate
                                                        object:nil
                                                      userInfo:nil];
}

- (void)addLog:(PMLogDataModel *)log
{
    [self addLogs:@[log]];
}

- (void)addLogs:(NSArray *)logs
{
    NSMutableArray *bizArray = [PMConfigFactory getPMLogConfig].bizes;
    for (PMLogDataModel *log in logs) {
        if (![bizArray containsObject:log.biz]) {
            [bizArray addObject:log.biz];
        }
        
        NSMutableArray *arr = [self.logDict objectForKey:log.biz] ?: [NSMutableArray array];
        [arr addObject:@(self.logs.count)];
        [self.logDict setObject:arr forKey:log.biz];
        [self.logs addObject:log];
    }
    
    self.didUpdateLogs = YES;
    [self postDidUpdateNotif];
}

- (void)clearLog
{
    [self.logDict removeAllObjects];
    [self.logs removeAllObjects];
    self.didUpdateLogs = YES;
    [self postDidUpdateNotif];
}

- (NSUInteger)filter:(NSArray *)bizes
{
    if (0 == bizes.count || [bizes containsObject:kLogBizDefault]) {
        return self.logs.count;
    }
    
    if (!self.didUpdateLogs && [self.filterBizes isEqualToArray:bizes]) {
        return self.filterLogs.count;
    }
    
    self.filterBizes = bizes;
    [self.filterLogs removeAllObjects];
    for (NSString *biz in bizes) {
        [self.filterLogs addObjectsFromArray:[self.logDict objectForKey:biz]];
    }
    
    NSArray *sortedFilterLogs = [self.filterLogs sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [obj1 integerValue] > [obj2 integerValue];
    }];
    
    [self.filterLogs removeAllObjects];
    [self.filterLogs addObjectsFromArray:sortedFilterLogs];
    
    return self.filterLogs.count;
}

- (NSUInteger)numberOfItems:(NSArray *)bizes
{
    return [self filter:bizes];
}

- (PMLogDataModel *)logAtItemIndex:(NSUInteger)index bizes:(NSArray *)bizes
{
    PMLogDataModel *dataModel = nil;
    
    if (0 == bizes.count || [bizes containsObject:kLogBizDefault]) {
        dataModel = [self.logs objectAtIndex:index];
    } else {
        dataModel = [self.logs objectAtIndex:[[self.filterLogs objectAtIndex:index] integerValue]];
    }
    
    return dataModel;
}

@end
