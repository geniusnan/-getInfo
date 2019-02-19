//
//  UIImageView+ACGesture.h
//  WineTalk
//
//  Created by i云 on 14-4-30.
//  Copyright (c) 2015年Shansù. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UIImageView (ACGesture)
- (void)addTapGesture:(void(^)(UIImageView *imageView)) tapBlock forKey:(const void *) key;
- (void)addTapGesture:(void(^)(UIImageView *imageView)) tapBlock;
- (void)addLongPressGesture:(void(^)(UIImageView *imageView)) longPressBlock;

- (void)removeGestureForKey:(const void *) key;
@end
