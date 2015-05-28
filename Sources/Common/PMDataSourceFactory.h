//
//  PMDataSourceManager.h
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMLogDataSource.h"
#import "PMJSCallDataSource.h"

@interface PMDataSourceFactory : NSObject

+ (PMLogDataSource *)getPMLogDataSource;

+ (PMJSCallDataSource *)getPMJSCallDataSource;

@end
