//
//  PMConfigFactory.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import "PMConfigFactory.h"

@implementation PMConfigFactory

+ (PMLogConfig *)getPMLogConfig
{
    static PMLogConfig *logConfig = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logConfig = [[PMLogConfig alloc] init];
    });
    
    return logConfig;
}

+ (PMLogConfig *)getPMJSCallLogConfig
{
    static PMLogConfig *logConfig = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logConfig = [[PMLogConfig alloc] init];
    });
    
    return logConfig;
}

@end
