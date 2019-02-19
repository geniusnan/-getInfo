//
//  NSMutableArray+LSCore.h
//  CirclePay
//
//  Created by wjc on 17/2/16.
//  Copyright © 2017年 Lim. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface NSMutableArray (LSCore)
#pragma 增加或删除对象
- (void)insertObject:(id)object atIndexIfNotNil:(NSUInteger)index;
- (void)moveObjectAtIndex:(NSUInteger)index toIndex:(NSUInteger)toIndex;

#pragma mark - 排序
- (void)shuffle;
- (void)reverse;
- (void)unique;
- (void)sorting:(NSString *)parameters ascending:(BOOL)ascending;

#pragma - mark 安全操作
-(void)addObj:(id)i;
-(void)addString:(NSString*)i;
-(void)addBool:(BOOL)i;
-(void)addInt:(int)i;
-(void)addInteger:(NSInteger)i;
-(void)addUnsignedInteger:(NSUInteger)i;
-(void)addCGFloat:(CGFloat)f;
-(void)addChar:(char)c;
-(void)addFloat:(float)i;
-(void)addPoint:(CGPoint)o;
-(void)addSize:(CGSize)o;
-(void)addRect:(CGRect)o;

@end

