//
//  ColorObjc.m
//  FitnessCircle
//
//  Created by Lim on 15/1/1.
//  Copyright (c) 2015年 Lim. All rights reserved.
//

#import "ColorObjc.h"

@implementation ColorObjc
+(UIColor *)MainBlueColor
{
    return COLORRGB(94, 160, 217);
}

+(UIColor *)MainBlackColor
{
    return COLORRGB(15, 18, 24);
}
+(UIColor *)MainBlackColor2
{
    return COLORRGB(33, 33, 29);
}
+(UIColor *)MainBlueBgColor
{
    return COLORRGB(21,29, 38);
}
+(UIColor *)MainBgColor
{
    return COLORRGB(21, 23, 32);
}
+(UIColor *)MainLightGrayColor
{
    return COLORRGB(150, 150, 150);
}
+(UIColor *)MainYellowColor
{
    return [UIColor colorWithHex:0x937D63];
}
+(UIColor *)MainYellowDownColor
{
    return [UIColor colorWithHex:0xA08A70];
}
+(UIColor *)MainRedColor
{
    return COLORRGB(220,59,109);
}
+(UIColor *)MainGrayColor
{
    return COLORRGB(97, 110, 129);
}
+(UIColor *)MainGreenColor
{
    return COLORRGB(126, 211, 33);
}
+(UIColor *)MainLightRedColor
{
    return COLORRGB(254,105,147);
}
+(UIColor *)getLightRedColor
{
    UIColor *color=[UIColor colorWithRed:253/255.0f green:251/255.0f blue:251/255.0f alpha:1.0f];
    return color;
}
+(UIColor *)YellowRedColor
{
    UIColor *color=COLORRGB(232, 200, 87);
    return color;
}
+(UIColor *)MainLineColor
{
    UIColor *color=COLORRGB(63, 74, 100);
    return color;
}
@end
