//
//  PMRootViewController.m
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-3.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import "PMRootViewController.h"
#import "PMMonitorView.h"
#import "PMLogViewController.h"
#import "PMDataSourceFactory.h"
#import "PMConfigFactory.h"
#import "PMJSViewController.h"
#import "PMService+Private.h"

@interface PMRootViewController () <PMMonitorViewDelegate>

@end

@implementation PMRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor clearColor];
    [self.pmWindow bringSubviewToFront:[PMService shareInstance].rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - delegate

- (void)monitorView:(PMMonitorView *)monitorView didClickedLog:(BOOL)_
{
    PMLogViewController *vc = [[PMLogViewController alloc] initWithDataSource:[PMDataSourceFactory getPMLogDataSource] logConfig:[PMConfigFactory getPMLogConfig]];
    vc.pmWindow = self.pmWindow;
    [self.navigationController pushViewController:vc animated:YES];
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
    vc.pmWindow = self.pmWindow;
    vc.wb = wb;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)monitorView:(PMMonitorView *)monitorView didClickedOther:(BOOL)_
{
    
}

@end
