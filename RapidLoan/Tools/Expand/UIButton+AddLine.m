//
//  UIButton+AddLine.m
//  EPLProject
//
//  Created by Lim on 15/9/9.
//  Copyright (c) 2015年 Lim. All rights reserved.
//

#import "UIButton+AddLine.h"

@implementation UIButton (AddLine)
-(void)AddButtomLine
{
    CGFloat lineWidth=[CommonFunc computeWidthWithString:self.currentTitle font:self.titleLabel.font height:18];
    
    UIImageView *imageViews=[[UIImageView alloc]initWithFrame:CGRectMake(self.width/2-lineWidth/2, self.height-5, lineWidth,1 )];
    [imageViews setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:imageViews];
}
@end
