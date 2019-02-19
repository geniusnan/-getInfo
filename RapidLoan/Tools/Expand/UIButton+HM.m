//
//  UIButton+HM.m
//  quanmei
//
//  Created by Lim on 15/6/11.
//
//

#import "UIButton+HM.h"
#import <objc/runtime.h>
@implementation UIButton (HM)
- (void)addUpInside:(ACButtonBlock)acBlock {
    objc_setAssociatedObject(self, _cmd, acBlock, OBJC_ASSOCIATION_COPY);
    [self addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)clickButton:(UIButton *) sender {
    ACButtonBlock acBlock = objc_getAssociatedObject(self, @selector(addUpInside:));
    if (acBlock) {
        acBlock(sender);
    }
}

@end
