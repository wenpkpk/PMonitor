//
//  PMMonitorView.m
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import "PMMonitorView.h"

@interface PMMonitorView () <UIGestureRecognizerDelegate>

@property(nonatomic, strong) UIButton   *debugView;
@property(nonatomic, assign) CGFloat    lastRotation;
@property(nonatomic, strong) UIButton   *logBtn;
@property(nonatomic, strong) UIButton   *jsBtn;
@property(nonatomic, strong) UIButton   *otherBtn;
@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;

@end


@implementation PMMonitorView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.debugView = [[UIButton alloc] init];
        self.debugView.frame = CGRectMake(0, 0, 80, 80);
        [self.debugView setTitle:kMonitorViewTitle forState:UIControlStateNormal];
        self.debugView.layer.cornerRadius = 40;
        self.debugView.clipsToBounds = YES;
        self.debugView.backgroundColor = [UIColor purpleColor];
        [self addSubview:self.debugView];
        self.multipleTouchEnabled = NO;
        
        self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
        [self addGestureRecognizer:self.panGesture];
        self.panGesture.enabled = NO;
        
        [self.debugView addTarget:self
                           action:@selector(debugViewClicked:)
                 forControlEvents:UIControlEventTouchUpInside];
        self.tag = kMonitorViewTag;
    }
    
    return self;
}

- (BOOL)isShowMenus
{
    return _showMenus;
}

- (UIButton *)logBtn
{
    if (!_logBtn) {
        _logBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _logBtn.layer.cornerRadius = 20;
        [_logBtn setTitle:@"Log" forState:UIControlStateNormal];
        _logBtn.clipsToBounds = YES;
        _logBtn.hidden = YES;
        [_logBtn addTarget:self
                    action:@selector(logBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_logBtn];
    }
    
    return _logBtn;
}

- (UIButton *)jsBtn
{
    if (!_jsBtn) {
        _jsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _jsBtn.layer.cornerRadius = 20;
        [_jsBtn setTitle:@"JS" forState:UIControlStateNormal];
        _jsBtn.clipsToBounds = YES;
        _jsBtn.hidden = YES;
        [_jsBtn addTarget:self
                    action:@selector(jsBtnClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_jsBtn];
    }
    
    return _jsBtn;
}

- (UIButton *)otherBtn
{
    if (!_otherBtn) {
        _otherBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _otherBtn.layer.cornerRadius = 20;
        _otherBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_otherBtn setTitle:@"Other" forState:UIControlStateNormal];
        _otherBtn.clipsToBounds = YES;
        _otherBtn.hidden = YES;
        [_otherBtn addTarget:self
                      action:@selector(otherBtnClicked:)
            forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_otherBtn];
    }
    
    return _otherBtn;
}

- (void)setShowMenus:(BOOL)showMenus
{
    if (_showMenus != showMenus) {
        _showMenus = showMenus;
        self.panGesture.enabled = _showMenus;

        if (self.showMenus) {
            self.logBtn.hidden = !self.showMenus;
            self.jsBtn.hidden = !self.showMenus;
            self.otherBtn.hidden = !self.showMenus;
            self.logBtn.center = self.debugView.center;
            self.jsBtn.center = self.debugView.center;
            self.otherBtn.center = self.debugView.center;
            [self bringSubviewToFront:self.debugView];
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 CGRect frame = self.debugView.frame;
                                 self.logBtn.frame = CGRectMake(CGRectGetMaxX(frame), CGRectGetMinY(frame) - 30, 40, 40);
                                 self.logBtn.backgroundColor = [UIColor grayColor];
                                 self.jsBtn.frame = CGRectMake(CGRectGetMaxX(frame) + 14, CGRectGetMaxY(self.logBtn.frame) + 10, 40, 40);
                                 self.jsBtn.backgroundColor = [UIColor blackColor];
                                 self.otherBtn.frame = CGRectMake(CGRectGetMaxX(frame), CGRectGetMaxY(self.jsBtn.frame) + 10, 40, 40);
                                 self.otherBtn.backgroundColor = [UIColor blueColor];
                             } completion:^(BOOL finished) {
                                 
                             }];
        } else {
            [self bringSubviewToFront:self.debugView];
            [UIView animateWithDuration:0.3f
                             animations:^{
                                 self.logBtn.center = self.debugView.center;
                                 self.jsBtn.center = self.debugView.center;
                                 self.otherBtn.center = self.debugView.center;
                             } completion:^(BOOL finished) {
                                 self.logBtn.hidden = !self.showMenus;
                                 self.jsBtn.hidden = !self.showMenus;
                                 self.otherBtn.hidden = !self.showMenus;
                             }];
        }
    }
}

- (void)updateSubViews
{
    CGRect frame = self.debugView.frame;
    self.logBtn.frame = CGRectMake(CGRectGetMaxX(frame), CGRectGetMinY(frame) - 30, 40, 40);
    self.logBtn.backgroundColor = [UIColor grayColor];
    self.jsBtn.frame = CGRectMake(CGRectGetMaxX(frame) + 14, CGRectGetMaxY(self.logBtn.frame) + 10, 40, 40);
    self.jsBtn.backgroundColor = [UIColor blackColor];
    self.otherBtn.frame = CGRectMake(CGRectGetMaxX(frame), CGRectGetMaxY(self.jsBtn.frame) + 10, 40, 40);
    self.otherBtn.backgroundColor = [UIColor blueColor];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = CGRectContainsPoint(self.debugView.frame, point)
            || CGRectContainsPoint(self.logBtn.frame, point)
            || CGRectContainsPoint(self.jsBtn.frame, point)
            || CGRectContainsPoint(self.otherBtn.frame, point);
    return inside;
}

- (void)pan:(UIPanGestureRecognizer *)sender
{
    [self bringSubviewToFront:self.debugView];
    
    CGPoint location = [sender locationInView:self.superview];
    //边界限制
    if (location.x < CGRectGetWidth(sender.view.frame) / 2.0f) {
        location.x = CGRectGetWidth(sender.view.frame) / 2.0f;
    }
    
    if (location.x > CGRectGetWidth(self.superview.frame) - CGRectGetWidth(sender.view.frame) / 2.0f) {
        location.x = CGRectGetWidth(self.superview.frame) - CGRectGetWidth(sender.view.frame) / 2.0f;
    }
    
    if (location.y < CGRectGetHeight(sender.view.frame) / 2.0f) {
        location.y = CGRectGetHeight(sender.view.frame) / 2.0f;
    }
    
    if (location.y > CGRectGetHeight(self.superview.frame) - CGRectGetHeight(sender.view.frame) / 2.0f) {
        location.y = CGRectGetHeight(self.superview.frame) - CGRectGetHeight(sender.view.frame) / 2.0f;
    }
    
    sender.view.center = CGPointMake(location.x, location.y);
    [self updateSubViews];
}

- (void)rotationImage:(UIRotationGestureRecognizer*)gesture
{
    [self bringSubviewToFront:gesture.view];

    CGPoint location = [gesture locationInView:self];
    gesture.view.center = CGPointMake(location.x, location.y);
    
    if ([gesture state] == UIGestureRecognizerStateEnded) {
        self.lastRotation = 0;
        return;
    }
    
    CGAffineTransform currentTransform = self.debugView.transform;
    CGFloat rotation = 0.0 - (self.lastRotation - gesture.rotation);
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform, rotation);
    self.debugView.transform = newTransform;
    self.lastRotation = gesture.rotation;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)debugViewClicked:(id)sender
{
    self.showMenus = !self.showMenus;
    if ([self.delegate respondsToSelector:@selector(monitorView:didClickedDebug:)]) {
        [self.delegate monitorView:self didClickedDebug:self.isShowMenus];
    }
}

- (void)logBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(monitorView:didClickedLog:)]) {
        [self.delegate monitorView:self didClickedLog:YES];
        self.showMenus = NO;
    }
}

- (void)jsBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(monitorView:didClickedJS:)]) {
        [self.delegate monitorView:self didClickedJS:YES];
        self.showMenus = NO;
    }
}

- (void)otherBtnClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(monitorView:didClickedOther:)]) {
        [self.delegate monitorView:self didClickedOther:YES];
        self.showMenus = NO;
    }
}

@end
