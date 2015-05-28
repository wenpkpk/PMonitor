//
//  PMLogConfig.h
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PMLogConfig : NSObject

@property(nonatomic, assign) CGFloat            logTitleFontSize; // default is 6
@property(nonatomic, assign) CGFloat            logFontSize; // default is 8
@property(nonatomic, assign) CGFloat            logWarnFontSize; // default is 10
@property(nonatomic, assign) CGFloat            logErrorFontSize; // default is 12
@property(nonatomic, strong) UIColor            *logTitleTextColor; // defalt is whiteColor
@property(nonatomic, strong) UIColor            *logTextColor; // default is whiteColor
@property(nonatomic, strong) UIColor            *logWarnTextColor; // default is orangeColor
@property(nonatomic, strong) UIColor            *logErrorTextColor; // default is redColor
@property(nonatomic, strong) NSMutableArray     *bizes;
@property(nonatomic, strong) NSMutableArray     *filterBizes;
@property(nonatomic, assign) int                fontLevel; // 0-10

- (void)fontIncrease:(CGFloat)delta;

@end
