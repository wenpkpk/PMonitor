//
//  PMUtils.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15/5/28.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "PMUtils.h"
#import <objc/runtime.h>

@implementation PMUtils

+ (void)swizzled:(Class)cls ori:(SEL)ori new:(SEL)new
{
    SEL originalSelector = ori;
    SEL swizzledSelector = new;
    
    Method originalMethod = class_getInstanceMethod(cls, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(cls, swizzledSelector);
    
    BOOL didAddMethod =
    class_addMethod(cls,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(cls,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

@end
