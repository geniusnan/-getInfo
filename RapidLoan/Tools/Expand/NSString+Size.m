//
//  NSString+Size.m
//  NiuNiuCircle
//
//  Created by admin on 2017/7/10.
//  Copyright © 2017年 wjcLimText11Lim. All rights reserved.
//

#import "NSString+Size.h"

@implementation NSString (Size)



+ (CGFloat)calculateRowWidth:(NSString *)string font:(NSInteger )fontSize {
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};  //指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(0, 25)/*计算宽度时要确定高度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.width;
}

+ (CGFloat)calculateRowHeight:(NSString *)string fontSize:(NSInteger)fontSize width:(CGFloat )width{
    NSDictionary *dic = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};//指定字号
    CGRect rect = [string boundingRectWithSize:CGSizeMake(width, 0)/*计算高度要先指定宽度*/ options:NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil];
    return rect.size.height;
}

@end
