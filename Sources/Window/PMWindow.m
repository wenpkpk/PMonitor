//
//  PMWindow.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-3.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import "PMWindow.h"
#import "PMService+Private.h"

@interface PMWindow ()

@property(nonatomic, strong) UIWindow *oldKeyWindow;

@end


@implementation PMWindow

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)makeKeyAndVisible
{
    UIWindow *oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (![oldKeyWindow isEqual:self]) {
        self.oldKeyWindow = oldKeyWindow;
    }
    
    [super makeKeyAndVisible];
}

- (void)setHidden:(BOOL)hidden
{
    UIWindow *oldKeyWindow = [[UIApplication sharedApplication] keyWindow];
    
    if (![oldKeyWindow isEqual:self]) {
        self.oldKeyWindow = oldKeyWindow;
    }
    
    [super setHidden:hidden];
}

- (void)resignKeyWindow
{
    [self.oldKeyWindow makeKeyAndVisible];
    [super resignKeyWindow];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    if ([view isEqual:self] || [view.nextResponder isKindOfClass:NSClassFromString(@"PMRootViewController")]) {
        return [self.oldKeyWindow hitTest:point withEvent:event];
    }
    
    return view;
}

@end
