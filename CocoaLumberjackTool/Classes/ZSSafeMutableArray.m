//
//  ZSSafeMutableArray.m
//  CocoaLumberjackTool
//
//  Created by Taylor on 2020/9/29.
//

#import "ZSSafeMutableArray.h"

@interface ZSSafeMutableArray ()
@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) NSMutableArray* array;
@end

@implementation ZSSafeMutableArray

#pragma mark - init 方法
- (instancetype)initCommon{
    
    self = [super init];
    if (self) {
        NSString* uuid = [NSString stringWithFormat:@"com.cocoalumberjacktool.array_%p", self];
        _syncQueue = dispatch_queue_create([uuid UTF8String], DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (instancetype)init{
    
    self = [self initCommon];
    if (self) {
        _array = [NSMutableArray array];
    }
    return self;
}
- (NSUInteger)count{
    
    __block NSUInteger count;
    dispatch_sync(_syncQueue, ^{
        count = _array.count;
    });
    return count;
}

- (id)objectAtIndex:(NSUInteger)index{
    
    __block id obj;
    dispatch_sync(_syncQueue, ^{
        if (index < [_array count]) {
            obj = _array[index];
        }
    });
    return obj;
}

- (NSEnumerator *)objectEnumerator{
    
    __block NSEnumerator *enu;
    dispatch_sync(_syncQueue, ^{
        enu = [_array objectEnumerator];
    });
    return enu;
}

- (void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(_syncQueue, ^{
        if (anObject && index < [weakSelf.array count]) {
            [weakSelf.array insertObject:anObject atIndex:index];
        }
    });
}

-(void)addObject:(id)anObject{
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(_syncQueue, ^{
        if(anObject){
            [weakSelf.array addObject:anObject];
        }
    });
}

-(void)removeObjectAtIndex:(NSUInteger)index{
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(_syncQueue, ^{
        
        if (index < [weakSelf.array count]) {
            [weakSelf.array removeObjectAtIndex:index];
        }
    });
}

-(void)removeLastObject{
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(_syncQueue, ^{
        [weakSelf.array removeLastObject];
    });
}

-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    __weak typeof(self) weakSelf = self;
    dispatch_barrier_async(_syncQueue, ^{
        if (anObject && index < [weakSelf.array count]) {
            [weakSelf.array replaceObjectAtIndex:index withObject:anObject];
        }
    });
}

-(NSUInteger)indexOfObject:(id)anObject{
    __weak typeof(self) weakSelf = self;
    __block NSUInteger index = NSNotFound;
    dispatch_sync(_syncQueue, ^{
        for (int i = 0; i < [weakSelf.array count]; i ++) {
            if ([weakSelf.array objectAtIndex:i] == anObject) {
                index = i;
                break;
            }
        }
    });
    return index;
}

- (void)dealloc{
    
    if (_syncQueue) {
        _syncQueue = NULL;
    }
}
@end
