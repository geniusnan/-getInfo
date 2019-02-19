//
//  UIViewController+HM.m
//  sanxunManagement
//
//  Created by 曉星 on 14-3-27.
//  Copyright (c) 2014年 Sansu. All rights reserved.
//

#import "UIViewController+HM.h"
static char const * kACControllerSubmitKey = "kACControllerSubmitKey";
static char const * kACControllerBackKey   = "kACControllerBackKey";
static char const * kACControllerRefreshKey= "kACControllerRefreshKey";
static char const * kACControllerLeftKey= "kACControllerLeftKey";
@implementation UIViewController (HM)

static BOOL backRefresh = NO;

- (BOOL)isNavigationVC {
    if (self.navigationItem || self.navigationController) {
        return YES;
    }
    return NO;
}

- (void)displayBackButton {
    if (self.navigationController && self.navigationController.viewControllers[0] != self) {
        
        UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        if (IOS7_AND_LATER) {
            
        }
        returnButton.imageEdgeInsets = UIEdgeInsetsMake(11,0, 11,22);
        [returnButton addTarget:self
                         action:@selector(backTopViewController:)
               forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    } else {
//        HMLog(@"当前对象并不在UINavigationController的控制器数组中");
    }
}
- (void)displayRootButton {
    if (self.navigationController && self.navigationController.viewControllers[0] != self) {
        
        UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        returnButton.imageEdgeInsets = UIEdgeInsetsMake(0,-15, 0,15);

        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    } else {
//        HMLog(@"当前对象并不在UINavigationController的控制器数组中");
    }
}

- (void)LeftHandle:(UIBarButtonItem *) BarItem {
    ACBlock block = objc_getAssociatedObject(self, &kACControllerLeftKey);
    if (block) {
        block(BarItem);
    }
}
- (void)refreshHandle:(UIBarButtonItem *) BarItem {
    ACBlock block = objc_getAssociatedObject(self, &kACControllerRefreshKey);
    if (block) {
        block(BarItem);
    }
}
- (void)submitInfo:(UIBarButtonItem *)BarItem {
    ACBlock block = objc_getAssociatedObject(self, kACControllerSubmitKey);
    if (block) {
        block(BarItem);
    }
}
- (void)backTopViewController:(UIButton *) sender
{
    if (self.navigationController) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)backRootViewController:(UIButton *) sender{
    if (self.navigationController) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

+ (BOOL)isBackRefresh {
    return backRefresh;
}

+ (void)setBackRefresh:(BOOL) anBackRefresh {
    backRefresh = anBackRefresh;
}
- (void)addLeftNavButton:(ACBlock)callbackBlock title:(NSString *)title {
    if ([self isNavigationVC]) {
        objc_setAssociatedObject(self, kACControllerLeftKey, callbackBlock, OBJC_ASSOCIATION_COPY);
        UIBarButtonItem *submitBarItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(LeftHandle:)];
        [submitBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItem = submitBarItem;
    }
}
- (void)addBackButton:(ACBlock)callbackBlock
{
    if (![self isFirstVC])
    {
        
        objc_setAssociatedObject(self, kACControllerBackKey, callbackBlock, OBJC_ASSOCIATION_COPY);
        UIButton *returnButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 45, 22)];
        returnButton.exclusiveTouch = YES;
        returnButton.imageEdgeInsets=UIEdgeInsetsMake(0, -36, 0, 0);
        returnButton.showsTouchWhenHighlighted = YES;
        [returnButton setImage:[UIImage imageNamed:@"Icon_Back"]
                      forState:UIControlStateNormal];
        [returnButton addTarget:self action:@selector(touchButton:) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:returnButton];
    }
}
- (void)touchButton:(UIButton *) sender
{
    if ([self isNavigationVC]) {
        ACBlock block = objc_getAssociatedObject(self, kACControllerBackKey);
        if (block) {
            block((UIBarButtonItem *)sender);
            return;
        }
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (BOOL)isFirstVC {
    if ([self isNavigationVC] && self.navigationController.viewControllers[0] != self) {
        return NO;
    }
    return YES;
}
- (void)addRightNavButton:(ACBlock)callbackBlock title:(NSString *)title {
    if ([self isNavigationVC])
    {
        objc_setAssociatedObject(self, kACControllerSubmitKey, callbackBlock, OBJC_ASSOCIATION_COPY);
        UIBarButtonItem *submitBarItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(submitInfo:)];
        [submitBarItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0],NSForegroundColorAttributeName:[ColorObjc MainYellowDownColor]} forState:UIControlStateNormal];
        self.navigationItem.rightBarButtonItem = submitBarItem;
    }
}
- (void)addRightNavButton:(ACBlock)callbackBlock ImageUrl:(NSString *)ImageUrl{
    if ([self isNavigationVC]) {
        objc_setAssociatedObject(self, &kACControllerRefreshKey, callbackBlock, OBJC_ASSOCIATION_COPY);
        UIButton *refreshButton = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 0.0, 23.0, 23.0)];
        [refreshButton setImage:[UIImage imageNamed:ImageUrl] forState:UIControlStateNormal];
        [refreshButton setImage:[UIImage imageNamed:HMSTR(@"%@_down",ImageUrl)] forState:UIControlStateHighlighted];
        [refreshButton addTarget:self action:@selector(refreshHandle:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *refreshBarItem = [[UIBarButtonItem alloc] initWithCustomView:refreshButton];
        self.navigationItem.rightBarButtonItem = refreshBarItem;
    }
}

@end

