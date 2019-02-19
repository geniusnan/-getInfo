//
//  UIView+ACGesture.h
//  WineTalk
//
//  Created by wjc on 16/7/21.
//  Copyright © 2016年 Shansù. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ACGesture)
- (void)addTapGesture:(void(^)(UIView *label)) tapBlock forKey:(const void *) key;
- (void)addTapGesture:(void(^)(UIView *label)) tapBlock;
- (void)addLongPressGesture:(void(^)(UIView *label)) longPressBlock;
- (void)removeGestureForKey:(const void *) key;

@end
