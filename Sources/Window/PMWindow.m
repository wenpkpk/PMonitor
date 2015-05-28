//
//  PMWindow.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-3.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import "PMWindow.h"
#import "PMService+Private.h"
#import "PMRootViewController.h"
#import "PMMonitorView.h"
#import "PMLogViewController.h"
#import "PMDataSourceFactory.h"
#import "PMConfigFactory.h"
#import "PMJSViewController.h"
#import "PMService+Private.h"

@interface PMWindow () <PMMonitorViewDelegate>

@property(nonatomic, strong) UIWindow               *oldKeyWindow;
@property(nonatomic, assign) CGPoint                pointLeftTop;
@property(nonatomic, strong) PMMonitorView          *rootView;
@property(nonatomic, assign) CGRect                 oldFrame;
@property(nonatomic, assign) BOOL                   isNormalSize;

@end


@implementation PMWindow

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:panGesture];
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
        tapGesture.numberOfTapsRequired = 2;
        [self addGestureRecognizer:tapGesture];
        self.oldFrame = self.frame;
        [self addSubview:self.rootView];
        self.isNormalSize = YES;
        [self autoSetAlpha];
    }
    
    return self;
}

- (PMMonitorView *)rootView
{
    if (!_rootView) {
        _rootView = [[PMMonitorView alloc] initWithFrame:self.bounds];
        _rootView.tag = kMonitorViewTag;
        _rootView.delegate = (id)self;
    }
    
    return _rootView;
}

- (void)pan:(UIPanGestureRecognizer *)pan
{
    if (UIGestureRecognizerStateEnded == pan.state) {
        [self performSelector:@selector(setAlphaEx) withObject:nil afterDelay:3.0f];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        self.alpha = 1.0f;
    }
    
    CGPoint translation = [pan translationInView:self];
    translation = CGPointApplyAffineTransform(translation, self.transform);
    CGPoint centerPt = CGPointMake(pan.view.center.x + translation.x,
                                         pan.view.center.y + translation.y);
    centerPt.x = MAX(0 + CGRectGetWidth(self.frame) / 2.0f, centerPt.x);
    centerPt.x = MIN(centerPt.x, CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth(self.frame) / 2.0f);
    centerPt.y = MAX(0 + CGRectGetHeight(self.frame) / 2.0f, centerPt.y);
    centerPt.y = MIN(centerPt.y, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(self.frame) / 2.0f);
    self.center = centerPt;
    [pan setTranslation:CGPointMake(0, 0) inView:self];
    self.oldFrame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.oldFrame), CGRectGetHeight(self.oldFrame));
}

- (void)tap:(UITapGestureRecognizer *)tap
{
    if (UIGestureRecognizerStateEnded == tap.state) {
        [self performSelector:@selector(setAlphaEx) withObject:nil afterDelay:3.0f];
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        self.alpha = 1.0f;
    }

    if (self.isNormalSize) {
        self.isNormalSize = NO;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
    } else {
        self.isNormalSize = YES;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
    }
}

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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.rootView.showMenus = NO;
    [self autoChangeFrame];
}

- (void)setAlphaEx
{
    [UIView animateWithDuration:1.0f
                     animations:^{
                         self.alpha = 0.3f;
                     } completion:^(BOOL finished) {
                         if (self.alpha <= 0.3f) {
                             [UIView animateWithDuration:0.3f
                                              animations:^{
                                                  if (self.isNormalSize) {
                                                      self.isNormalSize = NO;
                                                      self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.5, 0.5);
                                                  } else {
                                                      self.isNormalSize = YES;
                                                      self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
                                                  }
                                              } completion:^(BOOL finished) {
                                                  
                                              }];
                         }
                     }];
}

- (void)autoSetAlpha
{
    if (self.rootView.showMenus) {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        self.alpha = 1.0f;
    } else {
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(setAlphaEx) withObject:nil afterDelay:3.0f];
    }
}

- (void)setRootViewController:(UIViewController *)rootViewController
{
    if (!rootViewController) {
        [self autoChangeFrame];
    }
    
    [super setRootViewController:rootViewController];
}

- (void)autoChangeFrame
{
    if (self.rootView.showMenus) {
        self.frame = [UIScreen mainScreen].bounds;
        self.rootView.frame = self.oldFrame;
    } else {
        CGPoint pt = self.rootView.frame.origin;
        pt = [self convertPoint:pt toView:[UIApplication sharedApplication].keyWindow];
        self.frame = CGRectMake(pt.x, pt.y, CGRectGetWidth(self.oldFrame), CGRectGetHeight(self.oldFrame));
        self.rootView.frame = self.bounds;
        self.oldFrame = self.frame;
    }
    
    [self autoSetAlpha];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    UIView *view = [super hitTest:point withEvent:event];
    
    if (!self.isNormalSize && [view.nextResponder isEqual:self.rootView]) {
        self.isNormalSize = YES;
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        self.alpha = 1.0f;
        [NSObject cancelPreviousPerformRequestsWithTarget:self];
        [self performSelector:@selector(setAlphaEx) withObject:nil afterDelay:3.0f];
        return nil;
    }
    
    return view;
}

#pragma mark - monitor delegate

- (void)monitorView:(PMMonitorView *)monitorView didClickedDebug:(BOOL)isShow
{
    [self autoChangeFrame];
}

- (void)monitorView:(PMMonitorView *)monitorView didClickedLog:(BOOL)_
{
    PMLogViewController *vc = [[PMLogViewController alloc] initWithDataSource:[PMDataSourceFactory getPMLogDataSource] logConfig:[PMConfigFactory getPMLogConfig]];
    vc.pmWindow = self;
    self.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
}

- (void)monitorView:(PMMonitorView *)monitorView didClickedJS:(BOOL)_
{
    // 检查当前vc 有没有webview
    // 获取当前最后一个vc的webview
    UINavigationController *nav = (id)[[UIApplication sharedApplication] keyWindow].rootViewController;
    UIWebView *wb = nil;
    
    if ([nav isKindOfClass:[UINavigationController class]]) {
        UIViewController *vc = nav.viewControllers.lastObject;
        for (UIView *subView in [vc.view subviews]) {
            if ([subView isKindOfClass:[UIWebView class]]) {
                wb = (id)subView;
                break;
            }
        }
    } else if ([nav isKindOfClass:[UITabBarController class]]) {
        UIViewController *vc = [[(UITabBarController*)nav viewControllers] firstObject];
        wb = [vc performSelector:@selector(wb) withObject:nil];
    }
    
    if (!wb) {
        return;
    }
    
    PMJSViewController *vc = [[PMJSViewController alloc] initWithDataSource:[PMDataSourceFactory getPMJSCallDataSource] logConfig:[PMConfigFactory getPMJSCallLogConfig]];
    vc.pmWindow = self;
    vc.wb = wb;
    self.rootViewController = [[UINavigationController alloc] initWithRootViewController:vc];
}

- (void)monitorView:(PMMonitorView *)monitorView didClickedOther:(BOOL)_
{
    
}

@end
