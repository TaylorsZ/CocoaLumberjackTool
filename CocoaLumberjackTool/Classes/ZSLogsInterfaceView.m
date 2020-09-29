//
//  ZSLogsInterfaceView.m
//  CocoaLumberjackTool
//
//  Created by Taylor on 2020/9/29.
//

#import "ZSLogsInterfaceView.h"
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "ZSLogCell.h"

#define MaxSCale 1.5  //最大缩放比例
#define MinScale 0.5  //最小缩放比例
@interface ZSLogsInterfaceView ()<ASTableDelegate,ASTableDataSource>
/// 关闭按钮
@property (nonatomic,strong) ASButtonNode *closeNode;
/// 清除按钮
@property (nonatomic,strong) ASButtonNode *clearNode;
/// 日志列表
@property (nonatomic,strong) ASTableNode *tableNode;

@property (nonatomic,strong) NSDateFormatter *dateFormatter;
@property (nonatomic,strong) ZSSafeMutableArray <DDLogMessage *>*dataArray;
@property (nonatomic,strong) NSMutableSet *messagesExpanded;
@property (nonatomic,assign) CGFloat totalScale;

@end

@implementation ZSLogsInterfaceView

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.borderColor = UIColor.redColor.CGColor;
        self.borderWidth = 2;
        [self addSubnode:self.closeNode];
        [self addSubnode:self.clearNode];
        [self addSubnode:self.tableNode];
        _dateFormatter = [[NSDateFormatter alloc] init];
        [_dateFormatter setDateFormat:@"HH:mm:ss:SSS"];
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.3];
      
        //添加拖动手势
        UIPanGestureRecognizer * panGR = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
        [self.view addGestureRecognizer:panGR];
        //添加缩放手势
        UIPinchGestureRecognizer * pinchGR = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchGesture:)];
        [self.view addGestureRecognizer:pinchGR];
      
        _totalScale = 1.0;
    }
    return self;
}

-(ASLayoutSpec *)layoutSpecThatFits:(ASSizeRange)constrainedSize{
    _closeNode.style.preferredSize = CGSizeMake(constrainedSize.max.width/2, 40);
    _clearNode.style.preferredSize = CGSizeMake(constrainedSize.max.width/2, 40);
    
    NSArray *srackChildren = @[_clearNode,_closeNode];
    ASStackLayoutSpec *topSpec = [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionHorizontal spacing:0 justifyContent:ASStackLayoutJustifyContentSpaceBetween alignItems:ASStackLayoutAlignItemsCenter children:srackChildren];
//    topSpec.style.preferredSize = CGSizeMake(constrainedSize.max.width, 30);
    _tableNode.style.height = ASDimensionMake(ASDimensionUnitPoints, constrainedSize.max.height - _closeNode.style.height.value);
    ASStackLayoutSpec * endSpec= [ASStackLayoutSpec stackLayoutSpecWithDirection:ASStackLayoutDirectionVertical spacing:0 justifyContent:ASStackLayoutJustifyContentCenter alignItems:ASStackLayoutAlignItemsCenter children:@[topSpec,_tableNode]];
    return endSpec;
}
#pragma mark - method
-(void)closeMethod:(ASButtonNode *)sender{
    [self removeFromSupernode];
    if (_close) {
        _close();
    }
}
-(void)clearMethod:(ASButtonNode *)sender{
    [_dataArray removeAllObjects];
    [_messagesExpanded removeAllObjects];
    [_tableNode reloadData];
}
-(void)refreshData:(ZSSafeMutableArray<DDLogMessage *> *)dataArray{
    self.dataArray = dataArray;
    [self.tableNode reloadData];
    NSInteger rows = [_tableNode numberOfRowsInSection:0];
    [self.tableNode scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:rows inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:YES];
}
-(void)receiveMessage:(DDLogMessage *)logMessage{
    
//    [self.dataArray addObject:logMessage];
    
//    if (!self.superview) return;
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInteger rows = [weakSelf.tableNode numberOfRowsInSection:0];
        NSMutableArray * indexPaths = [NSMutableArray array];
        for (int i = 0; i< weakSelf.dataArray.count - rows; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:rows + i inSection:0];
            [indexPaths addObject:indexPath];
        }
        [weakSelf.tableNode insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [weakSelf.tableNode scrollToRowAtIndexPath:indexPaths.lastObject atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}
-(void)pinchGesture:(UIPinchGestureRecognizer *)pan{
    
    CGFloat scale = pan.scale;
    //放大情况
    if(scale > 1.0){
        if(self.totalScale > MaxSCale) return;
    }
    //缩小情况
    if (scale < 1.0) {
        if (self.totalScale < MinScale) return;
    }
    
    if (pan.state == UIGestureRecognizerStateBegan || pan.state == UIGestureRecognizerStateChanged || pan.state == UIGestureRecognizerStateEnded) {
        pan.view.transform = CGAffineTransformScale(pan.view.transform, pan.scale, pan.scale);
        pan.scale = 1;
        self.totalScale *=scale;
    }
}
-(void)panGesture:(UIPanGestureRecognizer *)pan{
    CGPoint translation = [pan translationInView:self.view];
    CGPoint newCenter = CGPointMake(pan.view.center.x + translation.x, pan.view.center.y + translation.y);
//    NSLog(@"中心点：%@",NSStringFromCGRect(pan.view.frame));
    pan.view.center = newCenter;
    [pan setTranslation:CGPointZero inView:self.view];
    [self setNeedsLayout];
}

#pragma mark - tableViewDelegate
-(NSInteger)tableNode:(ASTableNode *)tableNode numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(ASCellNode *)tableNode:(ASTableNode *)tableNode nodeForRowAtIndexPath:(NSIndexPath *)indexPath{
    ZSLogCell * cellNode = [[ZSLogCell alloc]init];
    [cellNode setMessage:_dataArray[indexPath.row] infoText:[self textOfMessageForIndexPath:indexPath]];
    return cellNode;
}
- (NSString *)textOfMessageForIndexPath:(NSIndexPath *)indexPath{
    DDLogMessage *message = _dataArray[indexPath.row];
    if ([_messagesExpanded containsObject:@(indexPath.row)]) {
        return [NSString stringWithFormat:@"[%@] %@:%lu [%@]", [_dateFormatter stringFromDate:message.timestamp], message.file, (unsigned long)message.line, message.function];
    } else {
        return [NSString stringWithFormat:@"[%@] %@", [_dateFormatter stringFromDate:message.timestamp], message.message];
    }
}
#pragma mark - lazy
-(ASButtonNode *)closeNode{
    if (!_closeNode) {
        _closeNode = [[ASButtonNode alloc]init];
        _closeNode.backgroundColor = [UIColor colorWithRed:0 green:128/255.0 blue:128/255.0 alpha:1];
        [_closeNode setTitle:@"关闭" withFont:[UIFont boldSystemFontOfSize:15] withColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_closeNode addTarget:self action:@selector(closeMethod:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _closeNode;;
}
-(ASButtonNode *)clearNode{
    if (!_clearNode) {
        _clearNode = [[ASButtonNode alloc]init];
        _clearNode.backgroundColor = [UIColor blackColor];
        [_clearNode setTitle:@"清除" withFont:[UIFont boldSystemFontOfSize:15] withColor:UIColor.whiteColor forState:UIControlStateNormal];
        [_clearNode addTarget:self action:@selector(clearMethod:) forControlEvents:ASControlNodeEventTouchUpInside];
    }
    return _clearNode;;
}
-(ASTableNode *)tableNode{
    if (!_tableNode) {
        _tableNode = [ASTableNode new];
        _tableNode.backgroundColor = UIColor.clearColor;
        _tableNode.delegate = self;
        _tableNode.dataSource = self;
        _tableNode.view.tableFooterView = [UIView new];
    }
    return _tableNode;;
}
-(NSMutableSet *)messagesExpanded{
    if (!_messagesExpanded) {
        _messagesExpanded = [NSMutableSet set];
    }
    return _messagesExpanded;
}

@end
