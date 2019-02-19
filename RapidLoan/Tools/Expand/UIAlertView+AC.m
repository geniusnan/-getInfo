//
//  UIAlertView+AC.m
//  ACCommonUtil
//
//  Created by ismallstar on 13-12-26.
//  Copyright (c) 2013年 iyun. All rights reserved.
//

#import "UIAlertView+AC.h"

#undef ACUIAlertViewClickedButtonKey
#define ACUIAlertViewClickedButtonKey @"UIAlertView.clickedButton"

#undef ACUIAlertViewCanelKey
#define ACUIAlertViewCanelKey @"UIAlertView.cancel"

#undef ACUIAlertViewWillPresentKey
#define ACUIAlertViewWillPresentKey @"UIAlertView.willPresent"

#undef ACUIAlertViewDidPresentKey
#define ACUIAlertViewDidPresentKey @"UIAlertView.didPresent"

#undef ACUIAlertViewWillDismissKey
#define ACUIAlertViewWillDismissKey @"UIAlertView.willDismiss"

#undef ACUIAlertViewDidDismissKey
#define ACUIAlertViewDidDismissKey @"UIAlertView.didDismiss"

#undef ACUIAlertViewShouldEnableFirstOtherButtonKey
#define ACUIAlertViewShouldEnableFirstOtherButtonKey @"UIAlertView.shouldEnableFirstOtherButton"

@implementation UIAlertView (AC)

- (void)handlerClickedButton:(void(^)(UIAlertView *alertView, NSInteger buttonIndex)) anBlock {
    self.delegate = self;
    objc_setAssociatedObject(self, ACUIAlertViewClickedButtonKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerCancel:(void(^)(UIAlertView *alertView)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, ACUIAlertViewCanelKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerWillPresent:(void(^)(UIAlertView *alertView)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, ACUIAlertViewWillPresentKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerDidPresent:(void(^)(UIAlertView *alertView)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, ACUIAlertViewDidPresentKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerWillDismiss:(void(^)(UIAlertView *alertView, NSInteger buttonIndex)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, ACUIAlertViewWillDismissKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerDidDismiss:(void(^)(UIAlertView *alertView, NSInteger buttonIndex)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, ACUIAlertViewDidDismissKey, anBlock, OBJC_ASSOCIATION_COPY);
}

- (void)handlerShouldEnableFirstOtherButton:(BOOL(^)(UIAlertView *alertView)) anBlock {
    
    self.delegate = self;
    objc_setAssociatedObject(self, ACUIAlertViewShouldEnableFirstOtherButtonKey, anBlock, OBJC_ASSOCIATION_COPY);
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    void (^anBlock)(UIAlertView *alertView, NSInteger buttonIndex) = objc_getAssociatedObject(self, ACUIAlertViewClickedButtonKey);
    if (anBlock) {
        anBlock(alertView,buttonIndex);
    }
}

- (void)alertViewCancel:(UIAlertView *)alertView {
    void (^anBlock)(UIAlertView *alertView) = objc_getAssociatedObject(self, ACUIAlertViewCanelKey);
    if (anBlock) {
        anBlock(alertView);
    }
}

- (void)willPresentAlertView:(UIAlertView *)alertView {
    void (^anBlock)(UIAlertView *alertView) = objc_getAssociatedObject(self, ACUIAlertViewWillPresentKey);
    if (anBlock) {
        anBlock(alertView);
    }
}

- (void)didPresentAlertView:(UIAlertView *)alertView {
    void (^anBlock)(UIAlertView *alertView) = objc_getAssociatedObject(self, ACUIAlertViewDidPresentKey);
    if (anBlock) {
        anBlock(alertView);
    }
}

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex {
    void (^anBlock)(UIAlertView *alertView, NSInteger buttonIndex) = objc_getAssociatedObject(self, ACUIAlertViewWillDismissKey);
    if (anBlock) {
        anBlock(alertView,buttonIndex);
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    void (^anBlock)(UIAlertView *alertView, NSInteger buttonIndex) = objc_getAssociatedObject(self, ACUIAlertViewDidDismissKey);
    if (anBlock) {
        anBlock(alertView,buttonIndex);
    }
}
- (BOOL)alertViewShouldEnableFirstOtherButton:(UIAlertView *)alertView {
    BOOL (^anBlock)(UIAlertView *alertView) = objc_getAssociatedObject(self, ACUIAlertViewShouldEnableFirstOtherButtonKey);
    if (anBlock) {
        return anBlock(alertView);
    }
    return YES;
}

@end
