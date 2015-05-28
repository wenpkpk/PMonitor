//
//  PMLogDataSource.h
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMLogDataModel;

@interface PMLogDataSource : NSObject

- (void)addLog:(PMLogDataModel *)log;

- (void)addLogs:(NSArray *)logs;

- (void)clearLog;

- (NSUInteger)numberOfItems:(NSArray *)bizes; // if biz is whitespace return all logs

- (PMLogDataModel *)logAtItemIndex:(NSUInteger)index bizes:(NSArray *)bizes;

@end
