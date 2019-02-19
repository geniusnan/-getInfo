//
//  HomeViewController.h
//  RapidLoan
//
//  Created by admin on 2018/1/30.
//  Copyright © 2018年 admin. All rights reserved.
//
typedef NS_ENUM(NSInteger, CheckType) {
    CheckTypeUnstart = 0,       //未开始
    CheckTypeOngoing,          //正在检测
    CheckTypeDone,          //检测完成
    CheckTypeFailure,          //检测失败
};
#import "BaseViewController.h"

@interface HomeViewController : BaseViewController

@end
