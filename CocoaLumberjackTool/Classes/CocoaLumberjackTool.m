//
//  CocoaLumberjackTool.m
//  CocoaLumberjackTool
//
//  Created by Taylor on 2020/9/29.
//

#import "CocoaLumberjackTool.h"
#import "ZSLogWindow.h"
#import "ZSSafeMutableArray.h"
#import "ZSLogsInterfaceView.h"

@interface CocoaLumberjackTool ()
@property(nonatomic, strong) UIWindow *consoleWindow;
@property(nonatomic, strong) QMUIConsoleViewController *consoleViewController;
@end

@implementation CocoaLumberjackTool

static CocoaLumberjackTool *_instance;
static dispatch_once_t onceToken;
+(instancetype)shared{
    
    dispatch_once(&onceToken, ^{
        if(_instance == nil)
            _instance = [[self alloc] init];
    });
    return _instance;
}
+(void)destroyInstance{
    onceToken = 0;
    _instance = nil;
}


#pragma mark - DDLogger

@synthesize logFormatter;

- (void)logMessage:(DDLogMessage *)logMessage{
    
    
}

#pragma mark - Public Methods

@end
