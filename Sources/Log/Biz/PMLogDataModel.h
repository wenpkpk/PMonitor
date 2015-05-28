//
//  PMLogDataModel.h
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "PMDefine.h"


@interface PMLogDataModel : NSObject

@property(nonatomic, copy) NSString                 *biz;
@property(nonatomic, assign) PMLogType              logType;
@property(nonatomic, copy) NSString                 *log;
@property(nonatomic, strong) NSString               *dateStr;
@property(nonatomic, copy) NSString                 *fileName;
@property(nonatomic, copy) NSString                 *functionName;
@property(nonatomic, assign) NSInteger              functionLineNumber;
@property(atomic, strong) NSMutableDictionary       *heightDict; // 缓存cell height

- (void)calculateHeight;

@end
