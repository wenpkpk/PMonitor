//
//  PMLogViewController.h
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMBaseViewController.h"

@class PMLogDataSource;
@class PMLogConfig;

@interface PMLogViewController : PMBaseViewController

- (instancetype)initWithDataSource:(PMLogDataSource *)dataSource logConfig:(PMLogConfig *)logConfig;

@end
