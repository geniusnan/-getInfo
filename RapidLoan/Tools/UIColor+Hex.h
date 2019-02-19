//
//  UIColor+Hex.h
//  HBContent
//
//  Created by Eric on 15/9/4.
//  Copyright (c) 2015年 Eric. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHex:(long)hexColor;
+ (UIColor *)colorWithHex:(long)hexColor alpha:(float)opacity;

+ (UIColor *)colorWithHexString:(NSString *)stringToConvert;

@end
