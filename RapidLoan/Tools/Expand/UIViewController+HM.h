//
//  UIViewController+HM.h
//  sanxunManagement
//
//  Created by 曉星 on 14-3-27.
//  Copyright (c) 2014年 Sansu. All rights reserved.
//
typedef void(^ACBlock)(UIBarButtonItem *btns);

#import <UIKit/UIKit.h>

@interface UIViewController (HM)
- (void)displayBackButton;
- (void)displayRootButton;
- (void)addBackButton:(ACBlock)callbackBlock;
- (void)addLeftNavButton:(ACBlock)callbackBlock title:(NSString *)title;
- (void)addRightNavButton:(ACBlock)callbackBlock title:(NSString *)title;
- (void)addRightNavButton:(ACBlock)callbackBlock ImageUrl:(NSString *)ImageUrl;
+ (BOOL)isBackRefresh;
+ (void)setBackRefresh:(BOOL) backRefresh;
@end

@interface NavViewController : UINavigationController

@end
