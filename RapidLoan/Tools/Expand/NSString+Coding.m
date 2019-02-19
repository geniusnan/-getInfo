//
//  NSString+Coding.m
//  QIFEIProduct
//
//  Created by Lim on 15/3/2.
//  Copyright (c) 2015年 Lim. All rights reserved.
//

#import "NSString+Coding.h"

@implementation NSString (Coding)
/**
 *编码
 */
-(NSString *)UTF8Coding
{
//    return [self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return self;
}
/**
 *解编码
 */
-(NSString *)UTF8EnCoding
{
//    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return self;
}
- (NSString*)UTF8_To_GB2312
{
    NSStringEncoding encoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* gb2312data = [self dataUsingEncoding:encoding];
    NSString *returnString=[[NSString alloc] initWithData:gb2312data encoding:encoding];
    return returnString;
    
}
+(NSString*)GB2312_To_UTF8:(NSData *)datas;

{
    
    NSStringEncoding enc =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *retStr = [[NSString alloc] initWithData:datas encoding:enc];
    
    return retStr;
    
}
@end
