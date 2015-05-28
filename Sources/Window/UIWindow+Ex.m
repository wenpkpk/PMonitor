//
//  UIWindow+Ex.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-10.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "UIWindow+Ex.h"
#import <objc/runtime.h>
#import "PMMonitorView.h"
#import "PMService+Private.h"

@implementation UIWindow (Ex)

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

+ (void)swizzled
{
    [self swizzled:[self class] ori:@selector(addSubview:) new:@selector(addSubviewEx:)];
    [self swizzled:[self class] ori:@selector(bringSubviewToFront:) new:@selector(bringSubviewToFrontEx:)];
    [self swizzled:[self class] ori:@selector(setWindowLevel:) new:@selector(setWindowLevelEx:)];
}

- (void)setWindowLevelEx:(UIWindowLevel)windowLevel
{
    if (![self isEqual:[PMService shareInstance].pmWindow] && windowLevel > [PMService shareInstance].pmWindow.windowLevel) {
        // ignore
        NSLog(@"PoseidonMonitor...WindowLevel...%@",self);
    } else {
        [self setWindowLevelEx:windowLevel];
    }
}

- (void)addSubviewEx:(UIView *)view
{
    [self addSubviewEx:view];
    
    UIView *v = [self viewWithTag:kMonitorViewTag];
    [self bringSubviewToFront:v];
}

- (void)bringSubviewToFrontEx:(UIView *)view
{
    [self bringSubviewToFrontEx:view];
    
    UIView *v = [self viewWithTag:kMonitorViewTag];
    [self bringSubviewToFrontEx:v];
}

+ (void)initialize
{
    [self swizzled];
}

@end
