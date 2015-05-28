//
//  PMLogDataModel.m
//  wenpkpk
//
//  Created by chenwenhong on 15-3-28.
//  Copyright (c) 2015年 majun. All rights reserved.
//

#import "PMLogDataModel.h"
#import "PMConfigFactory.h"

@implementation PMLogDataModel

- (void)calculateHeight
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    for (int fontLevel = 0; fontLevel <= kLogMaxFontLevel; fontLevel++) {
        CGFloat height = 0;
        CGFloat logTitleFontSize = [PMConfigFactory getPMLogConfig].logTitleFontSize;
        CGFloat logFontSize = 0;
        
        if (PMLogType_Warn == self.logType) {
            logFontSize = [PMConfigFactory getPMLogConfig].logWarnFontSize;
        } else if (PMLogType_Error == self.logType) {
            logFontSize = [PMConfigFactory getPMLogConfig].logErrorFontSize;
        } else {
            logFontSize = [PMConfigFactory getPMLogConfig].logFontSize;
        }
        
        static NSString *bundleName = nil;
        
        if (!bundleName) {
            bundleName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(id)kCFBundleNameKey];
        }
        
        NSString *log = [NSString stringWithFormat:@"%@ %@ %@ %@-%ld：", self.dateStr, bundleName, [self.fileName lastPathComponent], self.functionName, (long)self.functionLineNumber];
        
        CGSize size = [log sizeWithFont:[UIFont systemFontOfSize:logTitleFontSize + fontLevel]
                      constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, 100)
                          lineBreakMode:NSLineBreakByCharWrapping];
        height += size.height + 2;
        size = [self.log sizeWithFont:[UIFont boldSystemFontOfSize:logFontSize + fontLevel]
                    constrainedToSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 10, 100)
                        lineBreakMode:NSLineBreakByCharWrapping];
        height += size.height;
        height = (int)height + 2;
        [dict setObject:@(height) forKey:@(fontLevel)];
    }
    
    self.heightDict = dict;
}

@end
