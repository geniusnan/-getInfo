//
//  ImageCell.m
//  RapidLoan
//
//  Created by admin on 2018/1/24.
//  Copyright © 2018年 admin. All rights reserved.
//

#import "ImageCell.h"

@implementation ImageCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //设置CollectionViewCell中的图像框
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        self.imageView.contentMode=UIViewContentModeScaleAspectFit;
        [self addSubview:self.imageView];
        
    }
    return self;
}

@end
