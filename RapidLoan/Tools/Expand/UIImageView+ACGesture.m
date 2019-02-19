//
//  UIImageView+ACGesture.m
//  WineTalk
//
//  Created by i云 on 14-4-30.
//  Copyright (c) 2015年Shansù. All rights reserved.
//

#import "UIImageView+ACGesture.h"
static char * kACTapGestureBlockKey = "kACTapGestureBlockKey";
static char * kACLongPressGestureBlockKey = "kACLongPressGestureBlockKey";

@implementation UIImageView (ACGesture)

- (void)addTapGesture:(void (^)(UIImageView *))tapBlock {
    [self addTapGesture:tapBlock forKey:_cmd];
}

- (void)addTapGesture:(void (^)(UIImageView *))tapBlock forKey:(const void *)key {
    objc_setAssociatedObject(self, kACTapGestureBlockKey, tapBlock, OBJC_ASSOCIATION_COPY);
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.cancelsTouchesInView = YES;
    self.userInteractionEnabled = YES;
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tapGesture];
    objc_setAssociatedObject(self, key, tapGesture, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)handleTapGesture:(UITapGestureRecognizer *) gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        
        void (^tapBlock)(UIImageView *) = objc_getAssociatedObject(self, kACTapGestureBlockKey);
        if (tapBlock) {
            tapBlock(self);
        }
    }
}
- (void)addLongPressGesture:(void(^)(UIImageView *imageView)) longPressBlock {
    objc_setAssociatedObject(self, kACLongPressGestureBlockKey, longPressBlock, OBJC_ASSOCIATION_COPY);
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    self.userInteractionEnabled = YES;
    [self addGestureRecognizer:longPressGesture];
}
- (void)handleLongPressGesture:(UILongPressGestureRecognizer *) gesture {
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        void (^longPressBlock)(UIImageView *imageView) = objc_getAssociatedObject(self, kACLongPressGestureBlockKey);
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
