//
//  UIScrollView+TapGesture.m
//  QuickMeet
//
//  Created by Lim on 15/5/25.
//  Copyright (c) 2015年 Lim. All rights reserved.
//
static char * kACTapGestureBlockKey = "kACTapGestureBlockKey";
static char * kACLongPressGestureBlockKey = "kACLongPressGestureBlockKey";

#import "UIScrollView+TapGesture.h"

@implementation UIScrollView (TapGesture)
- (void)addTapGesture:(void (^)(UIScrollView *))tapBlock {
    [self addTapGesture:tapBlock forKey:_cmd];
}

- (void)addTapGesture:(void (^)(UIScrollView *))tapBlock forKey:(const void *)key {
    objc_setAssociatedObject(self, kACTapGestureBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
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
        
        void (^tapBlock)(UIScrollView *) = objc_getAssociatedObject(self, kACTapGestureBlockKey);
        if (tapBlock) {
            tapBlock(self);
        }
    }
}
- (void)addLongPressGesture:(void(^)(UIScrollView *imageView)) longPressBlock {
    objc_setAssociatedObject(self, kACLongPressGestureBlockKey, longPressBlock, OBJC_ASSOCIATION_COPY);
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:longPressGesture];
}
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *) gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        void (^longPressBlock)(UIScrollView *imageView) = objc_getAssociatedObject(self, kACLongPressGestureBlockKey);
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
