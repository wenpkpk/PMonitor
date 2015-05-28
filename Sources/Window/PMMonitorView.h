//
//  PMMonitorView.h
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PMMonitorViewDelegate;


@interface PMMonitorView : UIView

@property(nonatomic, weak) id<PMMonitorViewDelegate>    delegate;

@property(nonatomic, assign) BOOL                       showMenus;

@end


@protocol PMMonitorViewDelegate <NSObject>

- (void)monitorView:(PMMonitorView *)monitorView didClickedDebug:(BOOL)isShow;

@optional

- (void)monitorView:(PMMonitorView *)monitorView didClickedLog:(BOOL)_;

- (void)monitorView:(PMMonitorView *)monitorView didClickedJS:(BOOL)_;

- (void)monitorView:(PMMonitorView *)monitorView didClickedOther:(BOOL)_;

@end