//
//  CocoaLumberjackTool.h
//  CocoaLumberjackTool
//
//  Created by Taylor on 2020/9/29.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
NS_ASSUME_NONNULL_BEGIN
/**
 在设备屏幕上显示一个控制台，输出代码里的日志。支持搜索、按 Level/Name 过滤。用法：
 
 1. 调用 [QMUIConsole log:...] 直接打印 level 为 "Normal"、name 为 "Default" 的日志。
 2. 调用 [QMUIConsole logWithLevel:name:logString:] 打印详细日志，则在控制台里可以按照 level 和 name 分类筛选显示。
 3. 当屏幕上出现小圆钮时，点击可以打开控制台，小圆钮会移动到控制台右上角，再次点击小圆钮即可收起控制台。
 4. 如果要隐藏小圆钮，长按即可。
 
 @note 默认只在 DEBUG 下才会显示窗口，其他环境下只会打印日志但不会出现控制台界面。可通过 canShow 属性修改这个策略。
 */
@interface CocoaLumberjackTool : NSObject <DDLogger>

+(instancetype)shared;
+(void)destroyInstance;
+(instancetype) alloc __attribute__((unavailable("请使用sharedInstance")));
+(instancetype) new __attribute__((unavailable("请使用sharedInstance")));
-(instancetype) copy __attribute__((unavailable("请使用sharedInstance")));
-(instancetype) mutableCopy __attribute__((unavailable("请使用sharedInstance")));
//API_DEPRECATED(@"使用 showWithStatusBarHidden: 代替")
/**
 清空当前控制台内容
 */
+ (void)clear;

/**
 显示控制台。由于 QMUIConsole.showConsoleAutomatically 默认为 YES，所以只要输出 log 就会自动显示控制台，一般无需手动调用 show 方法。
 */
+ (void)show;

/**
 隐藏控制台。
 */
+ (void)hide;

/// 决定控制台是否能显示出来，当值为 NO 时，即便 +show 方法被调用也不会显示控制台，默认在 DEBUG 下为 YES，其他环境下为 NO。业务项目可自行修改。
/// 这个值为 NO 也不影响日志的打印，只是不会显示出来而已。
@property(nonatomic, assign) BOOL canShow;

/// 当打印 log 的时候自动让控制台显示出来，默认为 YES，为 NO 时则只记录 log，当手动调用 +show 方法时才会出现控制台。
@property(nonatomic, assign) BOOL showConsoleAutomatically;

/// 控制台的背景色
@property(nullable, nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

/// 控制台文本的默认样式
@property(nullable, nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *textAttributes UI_APPEARANCE_SELECTOR;

/// log 里的时间戳的颜色
@property(nullable, nonatomic, strong) NSDictionary<NSAttributedStringKey, id> *timeAttributes UI_APPEARANCE_SELECTOR;

/// 搜索结果高亮的背景色
@property(nullable, nonatomic, strong) UIColor *searchResultHighlightedBackgroundColor UI_APPEARANCE_SELECTOR;
@end

@interface CocoaLumberjackTool (UIAppearance)

+ (nonnull instancetype)appearance;

@end

NS_ASSUME_NONNULL_END
