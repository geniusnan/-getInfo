//
//  UIActionSheet+Block.m
//  HealthWalking
//
//  Created by Lim on 15/3/27.
//  Copyright (c) 2015年 Lim. All rights reserved.
//
char * UIActionSheet_key_clicked="UIActionSheet_key_clicked";

#import "UIActionSheet+Block.h"

@implementation UIActionSheet (Block)
-(void) handlerClickedButton:(void (^)(NSInteger btnIndex))aBlock{
    self.delegate = self;
    objc_setAssociatedObject(self, UIActionSheet_key_clicked, aBlock, OBJC_ASSOCIATION_COPY);
}

-(void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    void (^block)(NSInteger btnIndex) = objc_getAssociatedObject(self, UIActionSheet_key_clicked);
    
    if (block) block(buttonIndex);
}

@end
