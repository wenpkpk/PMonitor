//
//  ViewController.m
//  Test
//
//  Created by chenwenhong on 15/5/26.
//  Copyright (c) 2015年 Alipay. All rights reserved.
//

#import "WebViewController.h"
#import <objc/runtime.h>
#import "PMService.h"


@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [[PMService shareInstance] start];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

//    [NSClassFromString(@"PMService") performSelector:@selector(start)];

    if (self.presentedViewController) {
        [self dismissViewControllerAnimated:YES completion:NULL];
        return;
    }
    
    UIViewController *vc = [[UIViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:^{
        
    }];

    UIAlertView *av = [[UIAlertView alloc] initWithTitle:@"d"
                                                 message:@"d"
                                                delegate:nil
                                       cancelButtonTitle:@"cancel"
                                       otherButtonTitles:nil, nil];
    [av show];
}

@end
