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

@property (nonatomic,strong) ZSLogsInterfaceView *logNode;
@property (nonatomic,strong) ZSSafeMutableArray <DDLogMessage *>*messages;
@property (strong, nonatomic) ZSLogWindow *window;

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

- (instancetype)init
{
    self = [super init];
    if (self) {
        _messages = [[ZSSafeMutableArray alloc]init];
        /*create window*/
        ZSLogWindow *window = [[ZSLogWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        [window makeKeyAndVisible];
        [window setHidden:YES];
        [window setBackgroundColor:[UIColor clearColor]];
        [window setWindowLevel:UIWindowLevelAlert + 100];
        [window setUserInteractionEnabled:YES];
        
        self.window = window;
    }
    return self;
}
#pragma mark - DDLogger

@synthesize logFormatter;

- (void)logMessage:(DDLogMessage *)logMessage{
    [self.messages addObject:logMessage];
    [_logNode receiveMessage:logMessage];
    
}

#pragma mark - Public Methods
-(void)showWithStatusBarHidden:(BOOL)hidden{
    if (hidden) {
        [_window setRootViewController:[HideStatusBarController new]];
    }else{
        [_window setRootViewController:[UIViewController new]];
    }
    if (_logNode) {
        [_logNode.view removeConstraints:_logNode.view.constraints];
        [_logNode removeFromSupernode];
        _logNode = nil;
        
    }
    [_window setHidden:NO];
    __weak __typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showInView:weakSelf.window];
        weakSelf.window.contentView = weakSelf.logNode.view;
    });
}
- (void)showInView:(UIView*)view{
    
    _logNode = [ZSLogsInterfaceView new];
    __weak __typeof(&*self) weakSelf = self;
    _logNode.close = ^{
        weakSelf.logNode = nil;
        [weakSelf.window setHidden:YES];
    };
    
    [view addSubnode:_logNode];
    _logNode.view.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint * topConstraint = [_logNode.view.topAnchor constraintEqualToAnchor:view.topAnchor constant:80];
    topConstraint.active = YES;
    NSLayoutConstraint *leftConstraint = [_logNode.view.leadingAnchor constraintEqualToAnchor:view.leadingAnchor constant:10];
    leftConstraint.active = YES;
    
    
    CGFloat width = view.frame.size.width * 0.5;
    [_logNode.view.widthAnchor constraintEqualToConstant:width].active = YES;
    [_logNode.view.heightAnchor constraintEqualToConstant:width].active = YES;
    [_logNode refreshData:_messages];
}
-(void)showInWindow{
    
    if (_logNode) {
        [_logNode.view removeConstraints:_logNode.view.constraints];
        [_logNode removeFromSupernode];
        _logNode = nil;
    }
    [_window setRootViewController:[HideStatusBarController new]];
    [self.window setHidden:NO];
    __weak __typeof(&*self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        [weakSelf showInView:weakSelf.window];
        weakSelf.window.contentView = weakSelf.logNode.view;
    });
}
@end
