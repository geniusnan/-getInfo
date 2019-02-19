//
//  UIActionSheet+Block.h
//  HealthWalking
//
//  Created by Lim on 15/3/27.
//  Copyright (c) 2015年 Lim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIActionSheet (Block)<UIActionSheetDelegate>
-(void) handlerClickedButton:(void (^)(NSInteger btnIndex))aBlock;

@end
