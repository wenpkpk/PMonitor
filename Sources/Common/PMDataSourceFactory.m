//
//  PMDataSourceManager.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import "PMDataSourceFactory.h"

@implementation PMDataSourceFactory

+ (PMLogDataSource *)getPMLogDataSource
{
    static PMLogDataSource *dataSource = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSource = [[PMLogDataSource alloc] init];
    });
    
    return dataSource;
}

+ (PMJSCallDataSource *)getPMJSCallDataSource
{
    static PMJSCallDataSource *dataSource = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataSource = [[PMJSCallDataSource alloc] init];
    });
    
    return dataSource;
}


@end
