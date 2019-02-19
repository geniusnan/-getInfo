//
//  BaseViewController.m
//  FastLoan
//
//  Created by admin on 2018/1/29.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _backView =[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 83)];
    _backView.backgroundColor =[UIColor clearColor];
    [self.view addSubview:_backView];
    
    _titleLabel =[WidgetObjc WidgetLabel:CGRectMake(_backView.width/2-100, _backView.bottom-30, 200, 25) font:[UIFont systemFontOfSize:19] Alignment:NSTextAlignmentCenter textColor:[UIColor blackColor]];
     [_titleLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:19]];
    [_backView addSubview:_titleLabel];
    WS(weakSelf)
    _backButton = [WidgetObjc WidgetButtonWithImage:CGRectMake(0, _backView.bottom-40, 60, 40) imgage:@"fanhui_caidan" Heighted:@"fanhui_caidan" superViews:_backView];
    _backButton.hidden =YES;
    _backButton.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [_backButton addUpInside:^(UIButton *button) {
        [weakSelf.navigationController popViewControllerAnimated:YES];
    }];
    
    _rightButton = [WidgetObjc WidgetButtonWithImage:CGRectMake(_backView.width-95, _backView.bottom-30, 75, 25) imgage:nil Heighted:nil superViews:_backView];
    _rightButton.titleLabel.font =[UIFont systemFontOfSize:12];
    _rightButton.imageEdgeInsets =UIEdgeInsetsMake(5, 0, 5, 0);
    _rightButton.titleEdgeInsets =UIEdgeInsetsMake(5, 5, 5, 0);
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.hidden =YES;
    
}
-(void)setTitle:(NSString *)title{
    [_titleLabel setText:title];
}

-(void)setBackButton:(BOOL )hidden{
    [_backButton setHidden:hidden];
}

-(void)setRightButton:(NSString *)title imageView:(NSString *)imageStr{
    _rightButton.hidden =NO;
    [_rightButton setTitle:title forState:UIControlStateNormal];
    [_rightButton setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
