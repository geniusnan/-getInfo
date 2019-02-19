//
//  NSDateFormatter+ACAdditions.h
//  ACCommon
//
//  Created by i云 on 14/9/25.
//  Copyright (c) 2014年 Crazy Stone. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kDefaultDateFormat;

@interface NSDateFormatter (ACAdditions)

+ (instancetype)dateFormatter;
+ (instancetype)dateFormatterWithFormat:(NSString *) dateFormat;

+ (instancetype)defaultDateFormatter; //yyyy-MM-dd HH:mm:ss

@end
