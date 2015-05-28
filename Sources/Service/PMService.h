//
//  PMDebugService.h
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMLog.h"

@interface PMService : NSObject

+ (instancetype)shareInstance;

- (void)start;

- (void)stop;

@end
