//
//  PMUtils.h
//  PoseidonMonitor
//
//  Created by chenwenhong on 15/5/28.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PMUtils : NSObject

+ (void)swizzled:(Class)cls ori:(SEL)ori new:(SEL)new;

@end
