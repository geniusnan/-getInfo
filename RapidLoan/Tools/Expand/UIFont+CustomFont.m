//
//  UIFont+CustomFont.m
//  EPLProject
//
//  Created by Lim on 15/9/8.
//  Copyright (c) 2015年 Lim. All rights reserved.
//

#import "UIFont+CustomFont.h"

@implementation UIFont (CustomFont)
+(UIFont *)ThonburiWithFontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Futura-CondensedMedium" size:size];
}
+(UIFont *)BoldThonburiWithFontSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Futura-CondensedMedium" size:size];
}
+(UIFont *)PingFangSCLight:(CGFloat)size
{
    if(IOS9_AND_LATER)
    {
        return [UIFont fontWithName:@"PingFangSC-Light" size:size];
        
    }else
    {
        return [UIFont systemFontOfSize:size];
    }
}
+(UIFont *)PingFangSCMedium:(CGFloat)size
{
    
    if(IOS9_AND_LATER)
    {
        return [UIFont fontWithName:@"PingFangSC-Medium" size:size];
        
    }else
    {
        return [UIFont systemFontOfSize:size];
    }
}
+(UIFont *)PingFangSCRegular:(CGFloat)size
{
    if(IOS9_AND_LATER)
    {
        return [UIFont fontWithName:@"PingFangSC-Regular" size:size];
        
    }else
    {
        return [UIFont systemFontOfSize:size];
    }
}

@end
