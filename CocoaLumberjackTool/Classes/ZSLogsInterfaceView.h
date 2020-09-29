//
//  ZSLogsInterfaceView.h
//  CocoaLumberjackTool
//
//  Created by Taylor on 2020/9/29.
//

#import <UIKit/UIKit.h>
#import "ZSSafeMutableArray.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
@class DDLogMessage;
typedef void(^CocoaLumberjackViewBlock)(void);
NS_ASSUME_NONNULL_BEGIN

@interface ZSLogsInterfaceView : ASDisplayNode
@property(nonatomic,copy)CocoaLumberjackViewBlock close;
-(void)receiveMessage:(DDLogMessage *)logMessage;
-(void)refreshData:(ZSSafeMutableArray <DDLogMessage *>*)dataArray;
@end

NS_ASSUME_NONNULL_END
