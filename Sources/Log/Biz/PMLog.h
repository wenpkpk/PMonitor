//
//  PMLog.h
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDefine.h"

#define PMLog(format, ...)              PMWriteLog(__FILE__, __FUNCTION__, __LINE__, PMLogType_Normal, kLogBizDefault, format, ##__VA_ARGS__)
#define PMLogWarn(format, ...)          PMWriteLog(__FILE__, __FUNCTION__, __LINE__, PMLogType_Warn, kLogBizDefault, format, ##__VA_ARGS__)
#define PMLogError(format, ...)         PMWriteLog(__FILE__, __FUNCTION__, __LINE__, PMLogType_Error, kLogBizDefault, format, ##__VA_ARGS__)

#define PMLogBiz(biz, format, ...)      PMWriteLog(__FILE__, __FUNCTION__, __LINE__, PMLogType_Normal, biz, format, ##__VA_ARGS__)
#define PMLogWarnBiz(biz, format, ...)  PMWriteLog(__FILE__, __FUNCTION__, __LINE__, PMLogType_Warn, biz, format, ##__VA_ARGS__)
#define PMLogErrorBiz(biz, format, ...) PMWriteLog(__FILE__, __FUNCTION__, __LINE__, PMLogType_Error, biz, format, ##__VA_ARGS__)


FOUNDATION_EXPORT void PMWriteLog(const char *file, const char *function, const int functionLineNumber, PMLogType logType, NSString *biz, NSString *format, ...);