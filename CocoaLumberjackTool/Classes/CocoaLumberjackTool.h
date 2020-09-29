//
//  CocoaLumberjackTool.h
//  CocoaLumberjackTool
//
//  Created by Taylor on 2020/9/29.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
NS_ASSUME_NONNULL_BEGIN

@interface CocoaLumberjackTool : NSObject <DDLogger>

+(instancetype)shared;
+(void)destroyInstance;
+(instancetype) alloc __attribute__((unavailable("请使用sharedInstance")));
+(instancetype) new __attribute__((unavailable("请使用sharedInstance")));
-(instancetype) copy __attribute__((unavailable("请使用sharedInstance")));
-(instancetype) mutableCopy __attribute__((unavailable("请使用sharedInstance")));
//API_DEPRECATED(@"使用 showWithStatusBarHidden: 代替")
-(void)showInWindow;


-(void)showWithStatusBarHidden:(BOOL)hidden;
@end
NS_ASSUME_NONNULL_END
