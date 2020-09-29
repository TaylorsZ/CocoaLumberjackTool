//
//  ZSLogCell.h
//  CocoaLumberjackTool
//
//  Created by Taylor on 2020/9/29.
//

#import <Foundation/Foundation.h>
#import <AsyncDisplayKit/AsyncDisplayKit.h>
NS_ASSUME_NONNULL_BEGIN

@class DDLogMessage;
@interface ZSLogCell : ASCellNode
-(void)setMessage:(DDLogMessage *)message infoText:(NSString *)info;

@end

NS_ASSUME_NONNULL_END
