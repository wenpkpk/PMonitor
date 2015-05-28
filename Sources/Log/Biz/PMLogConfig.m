//
//  PMLogConfig.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import "PMLogConfig.h"

@implementation PMLogConfig

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.logTitleFontSize = 6;
        self.logFontSize = 8;
        self.logWarnFontSize = 10;
        self.logErrorFontSize = 12;
        
        self.logTitleTextColor = [UIColor whiteColor];
        self.logTextColor = [UIColor whiteColor];
        self.logWarnTextColor = [UIColor orangeColor];
        self.logErrorTextColor = [UIColor redColor];
        self.bizes = [NSMutableArray arrayWithObjects:kLogBizDefault, kLogBizNone, nil];
        self.filterBizes = [NSMutableArray arrayWithObjects:kLogBizDefault, nil];
    }
    return self;
}

- (void)fontIncrease:(CGFloat)delta
{
    if (self.fontLevel + delta > kLogMaxFontLevel) {
        delta = kLogMaxFontLevel - self.fontLevel;
    }
    
    self.fontLevel += delta;
    self.logTitleFontSize += delta;
    self.logFontSize += delta;
    self.logWarnFontSize += delta;
    self.logErrorFontSize += delta;
}

@end
