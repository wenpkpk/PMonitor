//
//  PMLogTableViewCell.m
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import "PMLogTableViewCell.h"
#import "PMLogDataModel.h"
#import "PMConfigFactory.h"

@interface PMLogTableViewCell ()

@property(nonatomic, strong) UILabel    *logLabel;

@end


@implementation PMLogTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.numberOfLines = 0;
        self.textLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.logLabel = [[UILabel alloc] init];
        self.logLabel.numberOfLines = 0;
        self.logLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:self.logLabel];
    }
    
    return self;
}

+ (CGFloat)height4DataModel:(PMLogDataModel *)dataModel config:(PMLogConfig *)config
{
    return [[dataModel.heightDict objectForKey:@(config.fontLevel)] integerValue];
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    
    self.textLabel.text = @"";
    self.logLabel.text = @"";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize size = [self.textLabel.text sizeWithFont:self.textLabel.font
                                  constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, MAXFLOAT)
                                      lineBreakMode:NSLineBreakByCharWrapping];
    
    self.textLabel.frame = CGRectMake(2, 0, CGRectGetWidth(self.contentView.frame) - 4, floorf(size.height + 2));
    self.logLabel.frame = CGRectMake(2, CGRectGetMaxY(self.textLabel.frame), CGRectGetWidth(self.contentView.frame) - 4, CGRectGetHeight(self.contentView.frame) - CGRectGetMaxY(self.textLabel.frame));
}

- (void)bindData:(PMLogDataModel *)dataModel config:(PMLogConfig *)config
{
    //date + bundleName + fileName + functionName + functionLineNumber + log
    if (!dataModel) {
        return;
    }
    
    static NSString *bundleName = nil;
    
    if (!bundleName) {
        bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey];
    }
    
    NSString *log = [NSString stringWithFormat:@"%@ %@ %@ %@-%ld：", dataModel.dateStr, bundleName, [dataModel.fileName lastPathComponent], dataModel.functionName, (long)dataModel.functionLineNumber];
    
    CGFloat logFontSize = 0;
    CGFloat logTitleFontSize = config.logTitleFontSize;
    UIColor *logTitleTextColor = config.logTitleTextColor;
    UIColor *logTextColor = nil;
    
    if (PMLogType_Warn == dataModel.logType) {
        logFontSize = config.logWarnFontSize;
        logTextColor = config.logWarnTextColor;
    } else if (PMLogType_Error == dataModel.logType) {
        logFontSize = config.logErrorFontSize;
        logTextColor = config.logErrorTextColor;
    } else {
        logFontSize = config.logFontSize;
        logTextColor = config.logTextColor;
    }
    
    self.textLabel.font = [UIFont systemFontOfSize:logTitleFontSize];
    self.textLabel.textColor = logTitleTextColor;
    self.textLabel.text = log;
    self.logLabel.font = [UIFont boldSystemFontOfSize:logFontSize];
    self.logLabel.textColor = logTextColor;
    self.logLabel.text = dataModel.log;
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

@end
