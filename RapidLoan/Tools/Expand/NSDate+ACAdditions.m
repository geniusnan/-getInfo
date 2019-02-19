//
//  NSDate+ACAdditions.m
//  ACCommon
//
//  Created by i云 on 14-4-8.
//  Copyright (c) 2014年 Crazy Stone. All rights reserved.
//

#import "NSDate+ACAdditions.h"
#import "NSDateFormatter+ACAdditions.h"

#if __IOS_64__
#define DATE_STR(__number) [NSString stringWithFormat:@"%02ld",__number]
#else
#define DATE_STR(__number) [NSString stringWithFormat:@"%02ld",__number]
#endif

NSInteger const kManySecondsYear   = 60 * 60 * 24 * 365; // 按365天算
NSInteger const kManySecondsMonth  = 60 * 60 * 24 * 30;  // 按30天算
NSInteger const kManySecondsWeek   = 60 * 60 * 24 * 7;
NSInteger const kManySecondsDay    = 60 * 60 * 24;
NSInteger const kManySecondsHour   = 60 * 60;
NSInteger const kManySecondsMinute = 60;

@implementation NSDate (ACAdditions)

- (NSDateComponents *)dateComponents {
    static NSCalendar *cal = nil;
    static unsigned int unitFlag;
    BEGIN_SINGLETON(dateComponents)
    cal = [NSCalendar currentCalendar];
    unitFlag = NSEraCalendarUnit |
    NSYearCalendarUnit |
    NSMonthCalendarUnit |
    NSDayCalendarUnit |
    NSHourCalendarUnit |
    NSMinuteCalendarUnit |
    NSSecondCalendarUnit |
    NSWeekdayCalendarUnit;
    END_SINGLETON
    return [cal components:unitFlag fromDate:self];
}

- (NSInteger)yearNumber {
    return [self dateComponents].year;
}

- (NSInteger)monthNumber {
    return [self dateComponents].month;
}

- (NSInteger)dayNumber {
    return [self dateComponents].day;
}

- (NSInteger)hourNumber {
    return [self dateComponents].hour;
}

- (NSInteger)minuteNumber {
    return [self dateComponents].minute;
}

- (NSInteger)secondNumber {
    return [self dateComponents].second;
}

- (NSInteger)weekNumber {
    return [self dateComponents].weekday;
}

- (NSString *)weekString {
   return [NSString stringWithFormat:@"星期%@",[self weeks][@([[self dateComponents] weekday])]];
}

- (NSString *)year {
    return HMSTR(@"%@",@([[self dateComponents] year]));
}

- (NSString *)month {
    return HMSTR(@"%@",@([[self dateComponents] month]));
}

- (NSString *)month_MM {
    return DATE_STR([[self dateComponents] month]);
}

- (NSString *)day {
    return HMSTR(@"%@",@([[self dateComponents] day]));
}

- (NSString *)day_dd {
    return DATE_STR([[self dateComponents] day]);
}

- (NSString *)hour {
    return HMSTR(@"%@",@([[self dateComponents] hour]));
}

- (NSString *)hour_hh {
    return DATE_STR([[self dateComponents] hour]);
}

- (NSString *)minute {
    return HMSTR(@"%@",@([[self dateComponents] minute]));
}

- (NSString *)minute_mm {
    return DATE_STR([[self dateComponents] minute]);
}

- (NSString *)second {
    return HMSTR(@"%@",@([[self dateComponents] second]));
}

- (NSString *)second_ss {
    return DATE_STR([[self dateComponents] second]);
}

- (NSString *)week {
    return HMSTR(@"周%@",[self weeks][@([[self dateComponents] weekday])]);
}

/*距离当前的时间间隔描述*/
- (NSString *)distanceCurrentTimeIntervalDescription {
    NSTimeInterval timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < kManySecondsMinute) {
        return @"1分钟内";
    }
    else if (timeInterval < kManySecondsHour) {
        return [NSString stringWithFormat:@"%.f分钟前", timeInterval / kManySecondsMinute];
    }
    else if (timeInterval < kManySecondsDay) {
        return [NSString stringWithFormat:@"%.f小时前", timeInterval / kManySecondsHour];
    }
    else if (timeInterval < kManySecondsMonth) {//30天内
        return [NSString stringWithFormat:@"%.f天前", timeInterval / kManySecondsDay];
    }
    else if (timeInterval < kManySecondsYear) {//30天至1年内
        NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"M月d日"];
        return [dateFormatter stringFromDate:self];
    }
    else {
        return [NSString stringWithFormat:@"%.f年前", timeInterval / kManySecondsYear];
    }
}

/*精确到分钟的日期描述*/
- (NSString *)minuteDescription
{
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
    
    NSString *theDay = [dateFormatter stringFromDate:self]; //日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]]; //当前年月日
    if ([theDay isEqualToString:currentDay]) { //当天
        [dateFormatter setDateFormat:@" ah:mm"];
        return [dateFormatter stringFromDate:self];
    }
    else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == kManySecondsDay) {//昨天
        [dateFormatter setDateFormat:@" ah:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    }
    else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < kManySecondsWeek) {//间隔一周内
        [dateFormatter setDateFormat:@"EEEE ah:mm"];
        return [dateFormatter stringFromDate:self];
    }
    else { //以前
        [dateFormatter setDateFormat:@"yyyy年MM月dd日 ah:mm"];
        return [dateFormatter stringFromDate:self];
    }
}
/*精确到分钟的日期描述*/
- (NSString *)minuteDescriptionType2
{
    NSDateFormatter *dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy-MM-dd"];
    
    NSString *theDay = [dateFormatter stringFromDate:self]; //日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]]; //当前年月日
    if ([theDay isEqualToString:currentDay])
    {
        //当天
        [dateFormatter setDateFormat:@"HH:mm"];
        
        return HMSTR(@"%@\n%@",@"今天",[dateFormatter stringFromDate:self]);
    }
    else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == kManySecondsDay) {//昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天\n%@", [dateFormatter stringFromDate:self]];
    }
    else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] < kManySecondsWeek) {//间隔一周内
        [dateFormatter setDateFormat:@"EEEE\nHH:mm"];
        return [dateFormatter stringFromDate:self];
    }
    else { //以前
        [dateFormatter setDateFormat:@"MM月dd日\nHH:mm"];
        return [dateFormatter stringFromDate:self];
    }
}
- (NSInteger)computingHours:(NSDate *) date {
    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setDay:date.dayNumber];
    [components setMonth:date.monthNumber];
    [components setYear:date.yearNumber];
    
    NSDate *currentDate = [[NSCalendar currentCalendar] dateFromComponents:components]; //当前date 0点时间
    
    NSInteger hour = [self timeIntervalSinceDate:currentDate] / kManySecondsHour;
    
    return hour;
}

/*标准时间日期描述*/
- (NSString *)formattedForStandardTime {
    
    NSInteger hour = [self computingHours:[NSDate date]];
    NSDateFormatter *dateFormatter = nil;
    
    //hasAMPM==TURE为12小时制，否则为24小时制
    NSString *formatStringForHours = [NSDateFormatter dateFormatFromTemplate:@"j" options:0 locale:[NSLocale currentLocale]];
    NSRange containsA = [formatStringForHours rangeOfString:@"a"];
    BOOL hasAMPM = containsA.location != NSNotFound;
    
    if (!hasAMPM) { //24小时制
        if (hour <= 24 && hour >= 0) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"HH:mm"];
        }
        else if (hour < 0 && hour >= -24) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"昨天HH:mm"];
        }
        else {
            if (self.yearNumber == [NSDate date].yearNumber) {
                
                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"MM月dd日 HH:mm"];
            }
            else {
                
                dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"yyyy年MM月dd日 HH:mm"];
            }
        }
    }else {
//        上午:6点-12点
//        中午:12点-14点
//        下午:14点-18点
//        晚上:18点-24点
//        凌晨:24点-6点
        NSString *tempAP = @"";
        NSInteger tempHour = [self computingHours:self];
        if (tempHour >= 0 && tempHour <= 6) {
            tempAP = @"凌晨";
        }
        else if (tempHour > 6 && tempHour <=11) {
            tempAP = @"上午";
        }
        else if (tempHour >= 12 && tempHour < 14) {
            tempAP = @"中午";
        }
        else if (tempHour >= 14 && tempHour <= 17) {
            tempAP = @"下午";
        }
        else if (tempHour > 17 && tempHour <= 24) {
            tempAP = @"晚上";
        }
        
        if (hour >= 0 && hour <= 6) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"凌晨hh:mm"];
        }
        else if (hour > 6 && hour <=11 ) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"上午hh:mm"];
        }
        else if (hour >= 12 && hour < 14) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"中午hh:mm"];
        }
        else if (hour >= 14 && hour <= 17) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"下午hh:mm"];
        }
        else if (hour > 17 && hour <= 24) {
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:@"晚上hh:mm"];
        }
        else if (hour < 0 && hour >= -24){
            dateFormatter = [NSDateFormatter dateFormatterWithFormat:[NSString stringWithFormat:@"昨天 %@hh:mm", tempAP]];
        }
        else  {
            if (self.yearNumber == [NSDate date].yearNumber) {
                
                dateFormatter = [NSDateFormatter dateFormatterWithFormat:[NSString stringWithFormat:@"MM月dd日 %@hh:mm", tempAP]];
            }
            else {
                
                dateFormatter = [NSDateFormatter dateFormatterWithFormat:[NSString stringWithFormat:@"yyyy年MM月dd日 %@hh:mm", tempAP]];
            }
        }
    }
    return [dateFormatter stringFromDate:self];
}

/*格式化日期描述*/
- (NSString *)formattedDateDescription {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *theDay = [dateFormatter stringFromDate:self];//日期的年月日
    NSString *currentDay = [dateFormatter stringFromDate:[NSDate date]];//当前年月日
    
    NSInteger timeInterval = -[self timeIntervalSinceNow];
    if (timeInterval < kManySecondsMinute) {
        return @"1分钟内";
    }
    else if (timeInterval < kManySecondsHour) {//1小时内
#if __IOS_64__
        return [NSString stringWithFormat:@"%ld分钟前", timeInterval / kManySecondsMinute];
#else
        return [NSString stringWithFormat:@"%ld分钟前", timeInterval / kManySecondsMinute];
#endif
    }
    else if (timeInterval < kManySecondsHour * 6) {//6小时内
#if __IOS_64__
        return [NSString stringWithFormat:@"%ld小时前", timeInterval / kManySecondsHour];
#else
        return [NSString stringWithFormat:@"%ld小时前", timeInterval / kManySecondsHour];
#endif
    }
    else if ([theDay isEqualToString:currentDay]) {//当天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"今天 %@", [dateFormatter stringFromDate:self]];
    }
    else if ([[dateFormatter dateFromString:currentDay] timeIntervalSinceDate:[dateFormatter dateFromString:theDay]] == kManySecondsDay) {//昨天
        [dateFormatter setDateFormat:@"HH:mm"];
        return [NSString stringWithFormat:@"昨天 %@", [dateFormatter stringFromDate:self]];
    }
    else {//以前
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        return [dateFormatter stringFromDate:self];
    }
}

+ (NSDate *)dateWithTimeIntervalInMilliSecondSince1970:(NSTimeInterval)timeIntervalInMilliSecond {
    
    NSTimeInterval timeInterval = timeIntervalInMilliSecond;
    // judge if the argument is in secconds(for former data structure).
    if(timeIntervalInMilliSecond > 140000000000) {
        timeInterval = timeIntervalInMilliSecond / 1000;
    }
    
    return [NSDate dateWithTimeIntervalSince1970:timeInterval];
}

+ (NSString *)formattedTimeFromTimeInterval:(NSTimeInterval)time {
   return [[NSDate dateWithTimeIntervalInMilliSecondSince1970:time] formattedForStandardTime];
}
#pragma mark---秒转换
+(NSString *)timeFormattedFromSeconds:(int)totalSeconds
{
    int days = totalSeconds / (60 * 60 * 24);
    int seconds = (totalSeconds % 60);
    int minutes = (totalSeconds % (60 * 60)) / (60);
    int hours = totalSeconds % (60 * 60 * 24)/(60 * 60);
    if (days>0)
    {
       return [NSString stringWithFormat:@"%02d天 %02d:%02d:%02d",days,hours, minutes, seconds];
    }else
    {
        return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
    }
    
}
- (NSDictionary *)weeks
{
    return @{@2: @"一",
             @3: @"二",
             @4: @"三",
             @5: @"四",
             @6: @"五",
             @7: @"六",
             @1: @"日"};
}

@end
