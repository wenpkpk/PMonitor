//
//  PMDefine.h
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-9.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

// biz
#define kLogBizDefault                      @"All"
#define kLogBizNone                         @"None"

typedef enum PMLogType{
    PMLogType_Normal = 0,
    PMLogType_Warn,
    PMLogType_Error,
}PMLogType;

#define kNotifPMLog                         @"kNotifPMLog"
