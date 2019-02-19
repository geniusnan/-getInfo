//
//  UIView+ACGesture.m
//  WineTalk
//
//  Created by wjc on 16/7/21.
//  Copyright © 2016年 Shansù. All rights reserved.
//

#import "UIView+ACGesture.h"
static char * TapGestureBlockKey = "TapGestureBlockKey";
static char * LongPressGestureBlockKey = "LongPressGestureBlockKey";

@implementation UIView (ACGesture)
- (void)addTapGesture:(void (^)(UIView *))tapBlock {
    [self addTapGesture:tapBlock forKey:_cmd];
}
- (void)addTapGesture:(void (^)(UIView *))tapBlock forKey:(const void *)key {
    objc_setAssociatedObject(self, TapGestureBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView = YES;
    tapGesture.delaysTouchesBegan = YES;
    self.userInteractionEnabled = YES;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
    if (key) {
        [self removeGestureForKey:key];
        objc_setAssociatedObject(self, key, tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *) gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        void (^tapBlock)(UIView *) = objc_getAssociatedObject(self, TapGestureBlockKey);
        if (tapBlock) {
            tapBlock(self);
        }
    }
}
- (void)addLongPressGesture:(void(^)(UIView *imageView)) longPressBlock {
    objc_setAssociatedObject(self, LongPressGestureBlockKey, longPressBlock, OBJC_ASSOCIATION_COPY);
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:longPressGesture];
}
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *) gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        void (^longPressBlock)(UIView *label) = objc_getAssociatedObject(self, LongPressGestureBlockKey);
        if (longPressBlock) {
            longPressBlock(self);
        }
    }
}

- (void)removeGestureForKey:(const void *)key {
    if (key) {
        //断开关联
        UIGestureRecognizer *gesture = objc_getAssociatedObject(self, key);
        if (gesture) {
            
            [self removeGestureRecognizer:gesture];
            gesture = nil;
            objc_setAssociatedObject(self, key, nil, OBJC_ASSOCIATION_ASSIGN);
        }
    }
}

@end
