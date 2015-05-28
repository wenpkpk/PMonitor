//
//  PMLogTableViewCell.h
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMLogDataModel;
@class PMLogConfig;

@interface PMLogTableViewCell : UITableViewCell

+ (CGFloat)height4DataModel:(PMLogDataModel *)dataModel config:(PMLogConfig *)config;

- (void)bindData:(PMLogDataModel *)dataModel config:(PMLogConfig *)config;

@end
