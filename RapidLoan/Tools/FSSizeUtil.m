//
//  GASizeUtil.m
//  GuanAiJiaJia
//
//  Created by wangkai on 16/6/21.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import "FSSizeUtil.h"

@implementation FSSizeUtil

CGFloat scale()
{
    static CGFloat scale = 0.0;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = ScreenWidth/375.0f;//iphone6的宽度
    });
    return scale;
}

+ (CGFloat)sizeHeight:(CGFloat)f theWidth:(CGFloat)w
{
    static CGFloat scale = 0.0;
    scale = w/375.0f;//iphone6的宽度
    return f*scale;
}

+ (CGFloat)sizeFloat:(CGFloat)f
{
    return f * scale();
}

+ (CGSize)sizeSize:(CGSize)sz
{
    return CGSizeMake(sz.width * scale(), sz.height * scale());
}

+ (CGRect)sizeRect:(CGRect)rt
{
    return CGRectMake(rt.origin.x * scale(), rt.origin.y * scale(), rt.size.width * scale(), rt.size.height * scale());
}

+ (CGSize)sizeWithOriginalImageSize:(CGSize)originalImageSize withMaxWidth:(CGFloat)maxWidth
{
    CGSize returnSize = CGSizeZero;
    if (originalImageSize.width <= maxWidth)
    {
        
        return originalImageSize;
    }else if(originalImageSize.width > maxWidth){
        
        returnSize.width = maxWidth;
        returnSize.height = (maxWidth * originalImageSize.height)/originalImageSize.width;
    }
    
    return returnSize;
}

@end
