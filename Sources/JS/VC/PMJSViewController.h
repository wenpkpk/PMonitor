//
//  PMJSViewController.h
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-10.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "PMBaseViewController.h"

@class PMJSCallDataSource;
@class PMLogConfig;

@interface PMJSViewController : PMBaseViewController

@property(nonatomic, weak) UIWebView *wb;

- (instancetype)initWithDataSource:(PMJSCallDataSource *)dataSource logConfig:(PMLogConfig *)logConfig;

@end
