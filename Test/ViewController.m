//
//  ViewController.m
//  Test
//
//  Created by chenwenhong on 15/5/26.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "ViewController.h"
#import <PoseidonMonitor/PoseidonMonitor.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    [[PMService shareInstance] start];

    PMLogBiz(@"H5-Normal", @"xxx%@", @"dfddfd");
    PMLogErrorBiz(@"H5-Error", @"xxx%@", @"dfddfd");
    PMLogWarnBiz(@"H5-Warn", @"xxx%@", @"dfddfd");
}

@end
