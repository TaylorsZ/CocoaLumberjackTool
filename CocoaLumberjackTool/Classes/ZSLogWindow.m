//
//  ZSLogWindow.m
//  CocoaLumberjackTool
//
//  Created by Taylor on 2020/9/29.
//

#import "ZSLogWindow.h"

@implementation ZSLogWindow

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event{
    if (_contentView) {
        if (CGRectContainsPoint(_contentView.frame, point)) {
            return YES;
        }else{
            return NO;
        }
    }else{
        return NO;
    }
}

@end


@implementation HideStatusBarController

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
