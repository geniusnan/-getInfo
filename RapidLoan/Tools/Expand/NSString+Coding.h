//
//  NSString+Coding.h
//  QIFEIProduct
//
//  Created by Lim on 15/3/2.
//  Copyright (c) 2015年 Lim. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Coding)
/**
 *编码
 */
-(NSString *)UTF8Coding;
/**
 *解编码
 */
-(NSString *)UTF8EnCoding;
-(NSString*)UTF8_To_GB2312;
+(NSString*)GB2312_To_UTF8:(NSData *)datas;
@end
