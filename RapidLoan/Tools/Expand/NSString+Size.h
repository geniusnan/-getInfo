//
//  NSString+Size.h
//  NiuNiuCircle
//
//  Created by admin on 2017/7/10.
//  Copyright © 2017年 wjcLimText11Lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Size)

+ (CGFloat)calculateRowWidth:(NSString *)string font:(NSInteger )fontSize;

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat )width;

@end
