//
//  BaseViewController.h
//  FastLoan
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
@property (nonatomic ,strong)UIView *backView;
@property (nonatomic ,strong)UIButton *backButton;
@property (nonatomic ,strong)UIButton *rightButton;
@property (nonatomic ,strong)UILabel *titleLabel;

-(void)setTitle:(NSString *)title;

-(void)setBackButton:(BOOL )hidden;

-(void)setRightButton:(NSString *)title imageView:(NSString *)imageStr;
@end
