//
//  NSDateFormatter+ACAdditions.m
//  ACCommon
//
//  Created by i云 on 14/9/25.
//  Copyright (c) 2014年 Crazy Stone. All rights reserved.
//

#import "NSDateFormatter+ACAdditions.h"

NSString *const kDefaultDateFormat = @"yyyy-MM-dd HH:mm:ss";

@implementation NSDateFormatter (ACAdditions)

+ (instancetype)dateFormatter {
    __autoreleasing NSDateFormatter *dateformatter = [[self alloc] init];
    return dateformatter;
}

+ (instancetype)dateFormatterWithFormat:(NSString *)dateFormat {
    if (dateFormat && ![dateFormat isEqualToString:@""]) {
        
        __autoreleasing NSDateFormatter *dateformatter = [[self alloc] init];
        dateformatter.dateFormat = dateFormat;
        return dateformatter;
    }
    else {
        return [self defaultDateFormatter];
    }
}

+ (instancetype)defaultDateFormatter {
    __autoreleasing NSDateFormatter *dateformatter = [[self alloc] init];
    dateformatter.dateFormat = kDefaultDateFormat;
    return dateformatter;
}

@end
