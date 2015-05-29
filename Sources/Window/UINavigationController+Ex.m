//
//  UINavigationController+Ex.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15/5/28.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "UINavigationController+Ex.h"
#import "PMUtils.h"

@implementation UINavigationController (Ex)

+ (void)load
{
    [PMUtils swizzled:self ori:@selector(popViewControllerAnimated:) new:@selector(myPopViewControllerAnimated:)];
    [PMUtils swizzled:self ori:@selector(popToViewController:animated:) new:@selector(myPopToViewController:animated:)];
    [PMUtils swizzled:self ori:@selector(popToRootViewControllerAnimated:) new:@selector(myPopToRootViewControllerAnimated:)];
    [PMUtils swizzled:self ori:@selector(pushViewController:animated:) new:@selector(myPushViewController:animated:)];
    [PMUtils swizzled:self ori:@selector(viewWillAppear:) new:@selector(myViewWillAppear:)];
}

- (void)myViewWillAppear:(BOOL)animated
{
    [self autoDetectWebView:self.viewControllers];
    [self myViewWillAppear:animated];
}

- (void)autoDetectWebView:(NSArray *)viewControllers
{
    if (![NSStringFromClass([self class]) rangeOfString:@"PMNavigationController"].length > 0) {
        UIViewController *webVC = nil;
        BOOL hasWebView = NO;
        for (UIViewController *vc in viewControllers) {
            if ([[NSStringFromClass([vc class]) lowercaseString] rangeOfString:@"webview"].length > 0) {
                webVC = vc;
                hasWebView = YES;
                break;
            }
        }
        
        if (hasWebView) {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifPMDetectWebView object:webVC];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotifPMDetectWebView object:nil];
        }
    }
}

- (void)myPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.viewControllers];
    [arr addObject:viewController];
    [self autoDetectWebView:arr];
    [self myPushViewController:viewController animated:animated];
}

- (UIViewController *)myPopViewControllerAnimated:(BOOL)animated
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.viewControllers];
    [arr removeLastObject];
    [self autoDetectWebView:arr];
    return [self myPopViewControllerAnimated:animated];
}

- (NSArray *)myPopToViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.viewControllers];
    NSInteger index = [arr indexOfObject:viewController];
    
    if (NSNotFound != index) {
        arr = (id)[arr subarrayWithRange:NSMakeRange(0, index)];
    }
    
    [self autoDetectWebView:arr];
    return [self myPopToViewController:viewController animated:animated];
}

- (NSArray *)myPopToRootViewControllerAnimated:(BOOL)animated
{
    [self autoDetectWebView:nil];
    return [self myPopToRootViewControllerAnimated:animated];
}

@end
