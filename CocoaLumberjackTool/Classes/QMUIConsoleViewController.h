//
//  QMUIConsoleViewController.h
//  CocoaLumberjackTool
//
//  Created by Taylor on 2021/8/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class QMUIButton;
@class QMUITableView;
@class QMUIConsoleToolbar;

@interface QMUIConsoleViewController : UIViewController
@property(nonatomic, strong, readonly) QMUIButton *popoverButton;
@property(nonatomic, strong, readonly) QMUITableView *tableView;
@property(nonatomic, strong, readonly) QMUIConsoleToolbar *toolbar;
@property(nonatomic, strong, readonly) NSDateFormatter *dateFormatter;

@property(nonatomic, strong) UIColor *backgroundColor;

- (void)logWithLevel:(nullable NSString *)level name:(nullable NSString *)name logString:(id)logString;
- (void)log:(id)logString;
- (void)clear;
@end

NS_ASSUME_NONNULL_END
