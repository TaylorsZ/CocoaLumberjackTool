//
//  ZSLogCell.m
//  CocoaLumberjackTool
//
//  Created by Taylor on 2020/9/29.
//

#import "ZSLogCell.h"
#import <AsyncDisplayKit/AsyncDisplayKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
@interface ZSLogCell ()

@property(nonatomic,strong)ASTextNode2 *textNode;

@end

@implementation ZSLogCell
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addSubnode:self.textNode];
    }
    return self;
}
-(void)setMessage:(DDLogMessage *)message infoText:(NSString *)info{
    UIColor * textColor;
    switch (message.flag) {
        case DDLogFlagError:
            textColor = [UIColor redColor];
            break;
        case DDLogFlagWarning:
            textColor = [UIColor orangeColor];
            break;
        case DDLogFlagDebug:
            textColor = [UIColor greenColor];
            break;
        case DDLogFlagVerbose:
            textColor = [UIColor blueColor];
            break;
        default:
            textColor = [UIColor whiteColor];
            break;
    }
    
    self.backgroundColor = [UIColor clearColor];
    _textNode.attributedText = [[NSAttributedString alloc]initWithString:info attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName:textColor}];
}
-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    ASInsetLayoutSpec * insertSpec = [ASInsetLayoutSpec insetLayoutSpecWithInsets:UIEdgeInsetsMake(5, 8, 5, 5) child:_textNode];
    //    ASWrapperLayoutSpec * spec = [[ASWrapperLayoutSpec alloc]initWithLayoutElement:_textNode];
    return insertSpec;
}

-(ASTextNode2 *)textNode{
    if (!_textNode) {
        _textNode = [ASTextNode2 new];
    }
    return _textNode;;
}
@end
