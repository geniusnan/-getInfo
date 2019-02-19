//
//  GASizeUtil.h
//  GuanAiJiaJia
//
//  Created by wangkai on 16/6/21.
//  Copyright © 2016年 iMac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FSSizeUtil : NSObject

+ (CGFloat)sizeHeight:(CGFloat)f theWidth:(CGFloat)w;

+ (CGFloat)sizeFloat:(CGFloat)f;

+ (CGSize)sizeSize:(CGSize)sz;

+ (CGRect)sizeRect:(CGRect)rt;

+ (CGSize)sizeWithOriginalImageSize:(CGSize)originalImageSize withMaxWidth:(CGFloat)maxWidth;

@end
