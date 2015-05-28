//
//  PMLog.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import "PMLog.h"
#import "PMService.h"
#import "PMService+Private.h"

FOUNDATION_EXPORT void PMWriteLog(const char *file, const char *function, const int functionLineNumber, PMLogType logType, NSString *biz, NSString *format, ...)
{
    if (![PMService isEnable]) {
        return;
    }
    
    va_list args;
    va_start(args, format);
    NSString* log = [[NSString alloc ] initWithFormat:format arguments:args];
    va_end(args);
    
    NSString *fileName = [NSString stringWithUTF8String:file];
    NSString *functionName = [NSString stringWithUTF8String:function ];
    
    [PMService log:log logType:logType fileName:fileName functionName:functionName functionLineNumber:functionLineNumber biz:biz];
}
