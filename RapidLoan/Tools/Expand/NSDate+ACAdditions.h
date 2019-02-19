//
//  NSDate+ACAdditions.h
//  ACCommon
//
//  Created by i云 on 14-4-8.
//  Copyright (c) 2014年 Crazy Stone. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 各种时间字符说明
 d
 将日显示为不带前导零的数字（如 1）。如果这是用户定义的数字格式中的唯一字符，请使用 %d。
 dd
 将日显示为带前导零的数字（如 01）。
 EEE
 将日显示为缩写形式（例如 Sun）。
 EEEE
 将日显示为全名（例如 Sunday）。
 M
 将月份显示为不带前导零的数字（如一月表示为 1）。如果这是用户定义的数字格式中的唯一字符，请使用 %M。
 MM
 将月份显示为带前导零的数字（例如 01/12/01）。
 MMM
 将月份显示为缩写形式（例如 Jan）。
 MMMM
 将月份显示为完整月份名（例如 January）。
 gg
 显示时代/纪元字符串（例如 A.D.）
 h
 使用 12 小时制将小时显示为不带前导零的数字（例如 1:15:15 PM）。如果这是用户定义的数字格式中的唯一字符，请使用 %h。
 hh
 使用 12 小时制将小时显示为带前导零的数字（例如 01:15:15 PM）。
 H
 使用 24 小时制将小时显示为不带前导零的数字（例如 1:15:15）。如果这是用户定义的数字格式中的唯一字符，请使用 %H。
 HH
 使用 24 小时制将小时显示为带前导零的数字（例如 01:15:15）。
 m
 将分钟显示为不带前导零的数字（例如 12:1:15）。如果这是用户定义的数字格式中的唯一字符，请使用 %m。
 mm
 将分钟显示为带前导零的数字（例如 12:01:15）。
 s
 将秒显示为不带前导零的数字（例如 12:15:5）。如果这是用户定义的数字格式中的唯一字符，请使用 %s。
 ss
 将秒显示为带前导零的数字（例如 12:15:05）。
 f
 显示秒的小数部分。例如，ff将精确显示到百分之一秒，而 ffff 将精确显示到万分之一秒。用户定义格式中最多可使用七个 f符号。如果这是用户定义的数字格式中的唯一字符，请使用 %f。
 t
 使用 12 小时制，并对中午之前的任一小时显示大写的 A，对中午到 11:59 P.M之间的任一小时显示大写的 P。如果这是用户定义的数字格式中的唯一字符，请使用 %t。
 tt
 对于使用 12 小时制的区域设置，对中午之前任一小时显示大写的 AM，对中午到 11:59 P.M之间的任一小时显示大写的 PM。
 对于使用 24 小时制的区域设置，不显示任何字符。
 y
 将年份 (0-9)显示为不带前导零的数字。如果这是用户定义的数字格式中的唯一字符，请使用 %y。
 yy
 以带前导零的两位数字格式显示年份（如果适用）。
 yyy
 以四位数字格式显示年份。
 yyyy
 以四位数字格式显示年份。
 z
 显示不带前导零的时区偏移量（如 -8）。如果这是用户定义的数字格式中的唯一字符，请使用 %z。
 zz
 显示带前导零的时区偏移量（例如 -08）
 zzz
 显示完整的时区偏移量（例如 -08:00）
 */

/*
 NSEraCalendarUnit
 NSYearCalendarUnit
 NSMonthCalendarUnit
 NSDayCalendarUnit
 NSHourCalendarUnit
 NSMinuteCalendarUnit
 NSSecondCalendarUnit
 NSWeekCalendarUnit
 NSWeekdayCalendarUnit
 NSWeekdayOrdinalCalendarUnit
 NSQuarterCalendarUnit
 NSWeekOfMonthCalendarUnit
 NSWeekOfYearCalendarUnit
 NSYearForWeekOfYearCalendarUnit
 NSCalendarCalendarUnit
 NSTimeZoneCalendarUnit
 */

@interface NSDate (ACAdditions)

#pragma mark - 时间分段取出

@property (readonly) NSInteger yearNumber;
@property (readonly) NSInteger monthNumber;
@property (readonly) NSInteger dayNumber;
@property (readonly) NSInteger hourNumber;
@property (readonly) NSInteger minuteNumber;
@property (readonly) NSInteger secondNumber;
@property (readonly) NSInteger weekNumber;

@property (readonly) NSString *weekString;

- (NSString *)distanceCurrentTimeIntervalDescription;
- (NSString *)minuteDescription;
- (NSString *)minuteDescriptionType2;
- (NSString *)formattedForStandardTime;
- (NSString *)formattedDateDescription;
+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)timeIntervalInMilliSecond;
+ (NSString *)formattedTimeFromTimeInterval:(NSTimeInterval)time;
#pragma mark---秒转换
+(NSString *)timeFormattedFromSeconds:(int)totalSeconds;
- (NSString *)year NS_DEPRECATED_IOS(2_0, 7_0, "Use yearNumber");
- (NSString *)month NS_DEPRECATED_IOS(2_0, 7_0, "Use monthNumber");
- (NSString *)month_MM NS_DEPRECATED_IOS(2_0, 7_0, "Use monthNumber");
- (NSString *)day NS_DEPRECATED_IOS(2_0, 7_0, "Use dayNumber");
- (NSString *)day_dd NS_DEPRECATED_IOS(2_0, 7_0, "Use dayNumber");
- (NSString *)hour NS_DEPRECATED_IOS(2_0, 7_0, "Use hourNumber");
- (NSString *)hour_hh NS_DEPRECATED_IOS(2_0, 7_0, "Use hourNumber");
- (NSString *)minute NS_DEPRECATED_IOS(2_0, 7_0, "Use minuteNumber");
- (NSString *)minute_mm NS_DEPRECATED_IOS(2_0, 7_0, "Use minuteNumber");
- (NSString *)second NS_DEPRECATED_IOS(2_0, 7_0, "Use secondNumber");
- (NSString *)second_ss NS_DEPRECATED_IOS(2_0, 7_0, "Use secondNumber");
- (NSString *)week NS_DEPRECATED_IOS(2_0, 7_0, "Use weekString");

@end
