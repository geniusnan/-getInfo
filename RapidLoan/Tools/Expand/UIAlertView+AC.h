//
//  UIAlertView+AC.h
//  ACCommonUtil
//
//  Created by ismallstar on 13-12-26.
//  Copyright (c) 2013年 iyun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIAlertView (AC)<UIAlertViewDelegate>

- (void)handlerClickedButton:(void(^)(UIAlertView *alertView, NSInteger buttonIndex)) anBlock;
- (void)handlerCancel:(void(^)(UIAlertView *alertView)) anBlock;
- (void)handlerWillPresent:(void(^)(UIAlertView *alertView)) anBlock;
- (void)handlerDidPresent:(void(^)(UIAlertView *alertView)) anBlock;
- (void)handlerWillDismiss:(void(^)(UIAlertView *alertView, NSInteger buttonIndex)) anBlock;
- (void)handlerDidDismiss:(void(^)(UIAlertView *alertView, NSInteger buttonIndex)) anBlock;
- (void)handlerShouldEnableFirstOtherButton:(BOOL(^)(UIAlertView *alertView)) anBlock;

@end
