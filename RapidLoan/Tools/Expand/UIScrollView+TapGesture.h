//
//  UIScrollView+TapGesture.h
//  QuickMeet
//
//  Created by Lim on 15/5/25.
//  Copyright (c) 2015年 Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIScrollView (TapGesture)
- (void)addTapGesture:(void(^)(UIScrollView *imageView)) tapBlock forKey:(const void *) key;
- (void)addTapGesture:(void(^)(UIScrollView *imageView)) tapBlock;
- (void)addLongPressGesture:(void(^)(UIScrollView *imageView)) longPressBlock;

- (void)removeGestureForKey:(const void *) key;
@end
