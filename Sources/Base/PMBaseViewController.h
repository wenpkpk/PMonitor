//
//  PMBaseViewController.h
//  PoseidonMonitor
//
//  Created by chenwenhong on 15-4-7.
//  Copyright (c) 2015年 wenpkpk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PMBaseViewController : UIViewController

@property(nonatomic, copy) NSString *backText;
@property(nonatomic, weak) UIWindow *pmWindow;

- (void)back;

@end
