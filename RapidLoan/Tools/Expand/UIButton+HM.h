//
//  UIButton+HM.h
//  quanmei
//
//  Created by Lim on 15/6/11.
//
//

#import <UIKit/UIKit.h>

typedef void(^ACButtonBlock)(UIButton *button);

@interface UIButton (HM)
- (void)addUpInside:(ACButtonBlock) acBlock;

@end
