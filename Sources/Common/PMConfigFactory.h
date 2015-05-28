//
//  PMConfigFactory.h
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMLogConfig.h"

@interface PMConfigFactory : NSObject

+ (PMLogConfig *)getPMLogConfig;

+ (PMLogConfig *)getPMJSCallLogConfig;

@end
