//
//  CertificationController.m
//  RapidLoan
//
//  Created by admin on 2018/2/1.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "CertificationController.h"
#import "FaceStreamDetectorViewController.h"

@interface CertificationController ()

@end

@implementation CertificationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =[UIColor whiteColor];
    self.titleLabel.text =@"活体认证";
    [self setBackButton:NO];
   UILabel * topLabel =[WidgetObjc WidgetLabel:CGRectMake(0, 105, ScreenWidth, 20) font:[UIFont systemFontOfSize:14] Alignment:NSTextAlignmentCenter textColor:[UIColor blackColor ]];
    topLabel.text =@"验证过程中请将头部轮廓置于虚线内按提示操作";
    [self.view addSubview:topLabel];
    
    UIImageView *centerImageView =[WidgetObjc WidgetImageView:CGRectMake(ScreenWidth/2- FSFloat(73), topLabel.bottom +25, FSFloat(146), FSFloat(152)) imageName:@"zhengquepaizhao" superViews:self.view];
    UILabel * centerLabel =[WidgetObjc WidgetLabel:CGRectMake(0, centerImageView.bottom+5, ScreenWidth, 20) font:[UIFont systemFontOfSize:12] Alignment:NSTextAlignmentCenter textColor:[UIColor colorWithHex:0x4A4A4A ]];
    centerLabel.text =@"正确的验证拍照方式";
    [self.view addSubview:centerLabel];
    CGFloat imageSize = (SCREEN_WIDTH -FSFloat(30)*4)/3;
    NSArray *titleArray =@[@"不要戴眼镜",@"不要戴帽子",@"光线不要太暗"];
    for (int i=0; i<3; i++) {
         UIImageView *imageView =[WidgetObjc WidgetImageView:CGRectMake(FSFloat(30)+(imageSize+FSFloat(30))*i, centerLabel.bottom +25,imageSize , imageSize*92/85) imageName:[NSString stringWithFormat:@"cuowupaizhao_%d",i+1] superViews:self.view];
        UILabel * label =[WidgetObjc WidgetLabel:CGRectMake(FSFloat(30)+(imageSize+FSFloat(30))*i, imageView.bottom+5, imageSize, 20) font:[UIFont systemFontOfSize:12] Alignment:NSTextAlignmentCenter textColor:[UIColor colorWithHex:0x4A4A4A ]];
        label.text =titleArray[i];
        [self.view addSubview:label];
    }
    
    UIButton *registerBtn = [WidgetObjc WidgetButton:CGRectMake(20, centerLabel.bottom+90+imageSize, ScreenWidth-40, 40) font:[UIFont systemFontOfSize:15] title:@"开始认证" textColor:[UIColor whiteColor] superViews:self.view];
    registerBtn.layer.masksToBounds =YES;
    registerBtn.layer.cornerRadius =3;
    registerBtn.contentHorizontalAlignment=UIControlContentHorizontalAlignmentCenter;
    [registerBtn setBackgroundImage:[UIImage imageNamed:@"buttonBG"] forState:UIControlStateNormal];
    WS(weakSelf)
    [registerBtn addUpInside:^(UIButton *button) {
        FaceStreamDetectorViewController *faceVC =[[FaceStreamDetectorViewController alloc]init];
        [weakSelf.navigationController pushViewController:faceVC animated:YES];
    }];
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
