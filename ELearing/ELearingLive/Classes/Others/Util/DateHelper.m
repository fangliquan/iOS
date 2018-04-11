//
//  DateHelper.m
//  wwface
//
//  Created by James on 14/11/28.
//  Copyright (c) 2014年 fo. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

#pragma mark- SharedInstance
+ (NSCalendar *)calendar {
    static NSCalendar *calendar;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        calendar.timeZone = [NSTimeZone localTimeZone];
    });
    return calendar;
}

+ (NSDateFormatter *)dateFormatter {
    static NSDateFormatter *formatter;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc]init];
        formatter.timeZone = [NSTimeZone localTimeZone];
    });
    return formatter;
}


#pragma mark- New func
/**
 *  根据时间获取时间字符串
 *
 *  @param time  时间 (long long)
 *  @param style WWTimeStringStyle
 *
 *  @return 时间字符串
 */
+ (NSString *)stringFormatOfTime:(NSTimeInterval)time style:(WWTimeStringStyle)style {
    if (time == 0) return @"";
    
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateComponents * paramComponents = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSDateComponents * todayComponents;
    if (style == WWTimeStringChatTimeStyle || style == WWTimeStringChatTimeListStyle) {
        NSCalendar * calendar = [NSCalendar currentCalendar];
        todayComponents = [calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    } else {
        todayComponents = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    }
    
    switch (style) {
        case WWTimeStringOnlyMonthAndDayStyle:{
             self.dateFormatter.dateFormat = @"M月d日";
        }
            break;
        case WWTimeStringDateOnlyShortStyle: {    // (今年: xx月xx日  今年以前: xx年xx月xx日)
            if (paramComponents.year == todayComponents.year) {
                self.dateFormatter.dateFormat = @"M月d日";
            }else{
                self.dateFormatter.dateFormat = @"yyyy年M月d日";
            }
        }
            break;
        case WWTimeStringDateOnlyLongStyle: { // (xx年xx月xx日)
            self.dateFormatter.dateFormat = @"yyyy年M月d日";
        }
            break;
        case WWTimeStringMonthOnlyShortStyle: { // (今年: xx月  今年以前: xx年xx月)
            if (paramComponents.year == todayComponents.year) {
                self.dateFormatter.dateFormat = @"M月";
            } else {
                self.dateFormatter.dateFormat = @"yyyy年M月";
            }
        }
            break;
        case WWTimeStringMonthOnlyLongStyle: { // (xx年xx月)
            self.dateFormatter.dateFormat = @"yyyy年M月";
        }
            break;
        case WWTimeStringTimeShortStyle: { // (xx:xx)
            self.dateFormatter.dateFormat = @"HH:mm";
        }
            break;
        case WWTimeStringDateAndTimeOnlyStyle: { // (xx月xx日 xx:xx)
            self.dateFormatter.dateFormat = @"M月d日 HH:mm";
        }
            break;
        case WWTimeStringDateAndTimeStyle: { // (今年: xx月xx日 xx:xx  今年以前: xx年xx月xx日 xx:xx)
            if (paramComponents.year == todayComponents.year) {
                self.dateFormatter.dateFormat = @"M月d日 HH:mm";
            } else {
                self.dateFormatter.dateFormat = @"yyyy年M月d日 HH:mm";
            }
        }
            break;
        case WWTimeStringDateAndTimeFullStyle: { // (xx年xx月xx日 xx:xx)
            self.dateFormatter.dateFormat = @"yyyy年M月d日 HH:mm";
        }
            break;
        case WWTimeStringDateOfLineShortStyle: { // (xx-xx-xx)
            self.dateFormatter.dateFormat = @"yyyy-M-d";
        }
            break;
        case WWTimeStringDateOfLineLongStyle: { // (xx-xx-xx xx:xx)
            self.dateFormatter.dateFormat = @"yyyy-M-d HH:mm";
        }
            break;
        case WWTimeStringCommentTimeShortStyle: { // (无具体小时、分)
            if (paramComponents.year == todayComponents.year){
                if (paramComponents.month == todayComponents.month && paramComponents.day == todayComponents.day) {
                    return [DateHelper stringTimesAgo:date];
                } else {
                    self.dateFormatter.dateFormat = @"M月d日";
                }
            } else {
                self.dateFormatter.dateFormat = @"yyyy年M月d日";
            }
        }
            break;
        case WWTimeStringCommentTimeLongStyle: { // (有具体小时、分)
            if (paramComponents.year == todayComponents.year){
                if (paramComponents.month == todayComponents.month && paramComponents.day == todayComponents.day) {
                    return [DateHelper stringTimesAgo:date];
                } else {
                    self.dateFormatter.dateFormat = @"M月d日 HH:mm";
                }
            } else {
                self.dateFormatter.dateFormat = @"yyyy年M月d日 HH:mm";
            }
        }
            break;
        case WWTimeStringChatTimeStyle:         // (聊天界面使用(当前天内只显示 时分))
        case WWTimeStringChatTimeListStyle: {   // (聊天界面使用(当前天内按 stringTimesAgo: 方法显示))
            if(paramComponents.year == todayComponents.year && paramComponents.month == todayComponents.month && paramComponents.day == todayComponents.day) {
                if (style == WWTimeStringChatTimeStyle) {
                    self.dateFormatter.dateFormat = @"HH:mm";
                } else {
                    return [self stringTimesAgo:date];
                }
            } else if(paramComponents.year == todayComponents.year) {
                self.dateFormatter.dateFormat = @"M-d HH:mm";
            } else {
                self.dateFormatter.dateFormat = @"yy-M-d";
            }
        }
            break;
            
        default:
            break;
    }
    NSString * timeStyleString = [self.dateFormatter stringFromDate:date];
    return timeStyleString;
}
/**
 *  根据时间获取生日相关字符串
 *
 *  @param birthday 生日
 *  @param style    WWAgeStringStyle
 *
 *  @return 生日相关字符串
 */
+ (NSString *)stringFormatOfBirthday:(NSTimeInterval)birthday style:(WWAgeStringStyle)style {
    if (birthday == 0) return @"";
    return [DateHelper stringFormatOfBirthday:birthday sourceTime:[self timeIntervalOfChangedDate:[NSDate date]] style:style];
}
/**
 *  根据生日、发布时间获取时间相关字符串 (成长记列表使用)
 *
 *  @param birthday   生日
 *  @param sourceTime 发布时间
 *  @param style      WWAgeStringStyle
 *
 *  @return 时间相关字符串
 */
+ (NSString *)stringFormatOfBirthday:(NSTimeInterval)birthday sourceTime:(NSTimeInterval)sourceTime style:(WWAgeStringStyle)style {
    if (birthday == 0) return @"";
    
    NSCalendar * calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    [calendar setFirstWeekday:2];
    [calendar setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"zh-Hans"]];
    NSTimeZone * localTimeZone = [NSTimeZone localTimeZone];
    [calendar setTimeZone:localTimeZone];
    
    NSDate * fromDate = [NSDate dateWithTimeIntervalSince1970:birthday/1000];
    fromDate = [DateHelper getDateOnlyDate:fromDate];
    
    NSDate * toCurrentDate= [NSDate dateWithTimeIntervalSince1970:sourceTime/1000 ];
    toCurrentDate = [DateHelper getDateOnlyDate:toCurrentDate];
    
    NSDateComponents * comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:fromDate toDate:toCurrentDate options:0];
    NSMutableString * dateString = [[NSMutableString alloc] init];
    long year = comps.year;
    long month = comps.month;
    long day = comps.day;
    
    if (year > 0) {
        [dateString appendFormat:@"%ld岁", year];
        if (style == WWAgeStringShortStyle) return dateString;
    }
    if (month > 0) {
        [dateString appendFormat:@"%ld个月", month];
        if (style == WWAgeStringShortStyle) return dateString;
    }
    if (day > 0) {
        [dateString appendFormat:@"%ld天", day];
        if (style == WWAgeStringShortStyle) return dateString;
    }
    if (day == 0 && month == 0) {
        [dateString appendFormat:@"生日"];
    }
    return dateString;
}
/**
 *  获取当前时间 NSTimeInterval
 */
+ (NSTimeInterval)timeIntervalNow {
    return [DateHelper timeIntervalOfChangedDate:[NSDate date]];
}
/**
 *  将 NSDate 转为 NSTimeInterval
 */
+ (NSTimeInterval)timeIntervalOfChangedDate:(NSDate *)date {
    return date.timeIntervalSince1970 * 1000;
}
/**
 *  获取当前时间字符串 (xx月xx日)
 */
+ (NSString *)stringOfCurrentTime {
    NSDate * date = [NSDate date];
    self.dateFormatter.dateFormat = @"M月d日 HH:mm";
    return [self.dateFormatter stringFromDate:date];
}
+ (NSString *)stringFullStyleOfCurrentTime {
    NSDate *date = [NSDate date];
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    return [self.dateFormatter stringFromDate:date];
}
+ (NSString *)stringCurrentYear {
    NSDate *date = [NSDate date];
    self.dateFormatter.dateFormat = @"yyyy";
    return [self.dateFormatter stringFromDate:date];
}
/**
 *  获取月份个第几周 (x月 第x周)
 */
+ (NSString *)indexWeekOfMonthWithTime:(NSTimeInterval)time {
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateComponents * dComponents = [self.calendar components:NSCalendarUnitMonth|NSWeekOfMonthCalendarUnit fromDate:date];
    return [NSString stringWithFormat:@"%ld月 第%ld周",(long)[dComponents month], (long)[dComponents weekOfMonth]];
}
/**
 *  字符串比较 (return : 今天、昨天、dateString)
 */
+ (NSString *)stringOfDateToCompareWithDateString:(NSString *)dateString {
    NSTimeInterval timeInerval = [DateHelper timeIntervalOfChangedDate:[NSDate date]];
    NSString * today = [DateHelper stringFormatOfTime:timeInerval style:WWTimeStringDateAndTimeStyle];
    NSString * str = [[today componentsSeparatedByString:@" "] firstObject];
    NSDate * yesterday = [[NSDate date] dateByAddingTimeInterval:-24*60*60];
    NSString * yesterdayStr = [DateHelper stringFormatOfTime:[DateHelper timeIntervalOfChangedDate:yesterday] style:WWTimeStringDateAndTimeStyle];
    NSString * yesStr = [[yesterdayStr componentsSeparatedByString:@" "]firstObject];
    
    if ([dateString isEqualToString:str]) {
        return @"今天";
    }else if ([dateString isEqualToString:yesStr]){
        return @"昨天";
    }else{
        return dateString;
    }
}
/**
 *  根据时间字符串获取 date
 */
+ (NSDate *)dateFromString:(NSString *)string style:(WWTimeStringStyle)style {
    if (style == WWTimeStringDateOnlyLongStyle) {
        self.dateFormatter.dateFormat = @"yyyy年MM月dd日";
    } else if (style == WWTimeStringDateAndTimeFullStyle) {
        self.dateFormatter.dateFormat = @"yyyy年MM月dd日 HH:mm";
    }
    NSDate * date = [self.dateFormatter dateFromString:string];
    return date;
}

+ (NSDate *)getDateOnlyDate:(NSDate *)date {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setTimeStyle: NSDateFormatterNoStyle];
    [df setDateStyle: NSDateFormatterMediumStyle];
    NSString *nowDateStr = [df stringFromDate:date];
    return [DateHelper getNowDateFromatAnDate:[df dateFromString:nowDateStr] andAbbreviation:@"UTC"];
}

+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate andAbbreviation:(NSString *)abbreviation {
    //设置源日期时区
    NSTimeZone* sourceTimeZone = [NSTimeZone timeZoneWithAbbreviation:abbreviation];//@"UTC"或GMT
    //设置转换后的目标日期时区
    NSTimeZone* destinationTimeZone = [NSTimeZone localTimeZone];
    //得到源日期与世界标准时间的偏移量
    NSInteger sourceGMTOffset = [sourceTimeZone secondsFromGMTForDate:anyDate];
    //目标日期与本地时区的偏移量
    NSInteger destinationGMTOffset = [destinationTimeZone secondsFromGMTForDate:anyDate];
    //得到时间偏移量的差值
    NSTimeInterval interval = destinationGMTOffset - sourceGMTOffset;
    //转为现在时间
    NSDate* destinationDateNow = [[NSDate alloc] initWithTimeInterval:interval sinceDate:anyDate];
    return destinationDateNow;
}



#pragma mark- old func
+(NSString *)formaterDate:(NSTimeInterval)time andType:(timeStyle)type{
    if (time == 0) {
        return @"";
    }
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSDateComponents *today = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    
    if (type == dateOnly) {
        if (comps.year == today.year) {
            self.dateFormatter.dateFormat = @"M月d日";
        }else{
            self.dateFormatter.dateFormat = @"yyyy年M月d日";
        }
    }else if (type == timeOnly){
        self.dateFormatter.dateFormat = @"HH:mm";
    }else if (type == dateAndTime){
        if (comps.year == today.year) {
            self.dateFormatter.dateFormat = @"M月d日 HH:mm";
        }else{
            self.dateFormatter.dateFormat = @"yyyy年M月d日 HH:mm";
        }
    }else if (type == birthday){
        self.dateFormatter.dateFormat = @"yyyy年M月d日";
    }else if (type == commentTime){
        if (comps.year == today.year){
            if (comps.month == today.month && comps.day == today.day) {
                return [DateHelper stringTimesAgo:date];
            } else {
                self.dateFormatter.dateFormat = @"M月d日 HH:mm";
            }
        }else{
            self.dateFormatter.dateFormat = @"yyyy年M月d日 HH:mm";
        }
    }else if (type == commentNotHour){
        if (comps.year == today.year){
            if (comps.month == today.month && comps.day == today.day) {
                return [DateHelper stringTimesAgo:date];
            } else {
                self.dateFormatter.dateFormat = @"M月d日";
            }
        }else{
            self.dateFormatter.dateFormat = @"yyyy年M月d日";
        }
    }else if (type == wholeFormat) {
        self.dateFormatter.dateFormat = @"yyyy年M月d日  HH:mm";
    }else if (type == horizontalLine) {
        self.dateFormatter.dateFormat = @"yyyy-M-d";
    }else if (type == yearMonth) {
        self.dateFormatter.dateFormat = @"yyyy年M月";
    }else if(type == monthOnly) {
        if (comps.year == today.year) {
            self.dateFormatter.dateFormat = @"M月";
        }else{
            self.dateFormatter.dateFormat = @"yyyy年M月";
        }
    }else if (type == timeOrDate) {
        if (comps.year == today.year) {
            self.dateFormatter.dateFormat = @"M月d日 HH:mm";
        }else{
            self.dateFormatter.dateFormat = @"yyyy年M月d日";
        }
    }else if (type == dateAndTimeOnly) {
        self.dateFormatter.dateFormat = @"M月d日 HH:mm";
    }else if (type == dayOnly) {
        self.dateFormatter.dateFormat = @"d";
    }

    NSString *dateString = [self.dateFormatter stringFromDate:date];
    return dateString;
}

+(NSString *)formaterTime:(NSTimeInterval)time isChat:(BOOL)isChat {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    NSCalendar *cal = [NSCalendar currentCalendar];
    NSDateComponents *today = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    
    if(comps.year == today.year && comps.month == today.month && comps.day == today.day) {
        if (isChat) {
            self.dateFormatter.dateFormat = @"HH:mm";
        }else {
            return [self stringTimesAgo:date];
        }
    } else if(comps.year == today.year) {
        self.dateFormatter.dateFormat = @"M-d HH:mm";
    } else {
        self.dateFormatter.dateFormat = @"yy-M-d";
    }
    NSString *dateString = [self.dateFormatter stringFromDate:date];
    return dateString;
}

+(BOOL)isSameDay:(NSTimeInterval)time1 With:(NSTimeInterval)time2 {
    
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    NSDate *date1 = [NSDate dateWithTimeIntervalSince1970:time1/1000];
    NSString *dateString1 = [self.dateFormatter stringFromDate:date1];
    
    NSDate *date2 = [NSDate dateWithTimeIntervalSince1970:time2/1000];
    NSString *dateString2 = [self.dateFormatter stringFromDate:date2];
    
    return [dateString1 isEqualToString:dateString2];
}


#pragma mark- 获取一周的时间段

+ (NSString *)getWeekOfDate:(NSTimeInterval)time
{
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateComponents *dComponents = [self.calendar components:NSCalendarUnitWeekday|NSCalendarUnitYear fromDate:date];
    long dayNum = [dComponents weekday]>=2 ? [dComponents weekday] -1 : 7;
    NSDate *firstDate = [date dateByAddingTimeInterval: - (dayNum -1) * 60 * 60 * 24];
    NSDate *lastDate = [firstDate dateByAddingTimeInterval: 6 * 60 * 60 * 24];
    [self.dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    NSDateComponents *today = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    if (dComponents.year == today.year) {
        [self.dateFormatter setDateFormat:@"M月d日"];
    }
    return [NSString stringWithFormat:@"%@—%@",[self.dateFormatter stringFromDate:firstDate],[self.dateFormatter stringFromDate:lastDate]];
}

+ (NSString *)getWeekPeriodOfDate:(NSTimeInterval)time weekPeriodType:(WeekPeriodFormatType)type
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSDateComponents * dComponents = [self.calendar components:NSCalendarUnitWeekday|NSCalendarUnitYear fromDate:date];
    long dayNum = [dComponents weekday]>=2 ? [dComponents weekday] -1 : 7;
    NSDate * firstDate = [date dateByAddingTimeInterval: - (dayNum -1) * 60 * 60 * 24];
    NSDate * lastDate = [firstDate dateByAddingTimeInterval: 6 * 60 * 60 * 24];
    
    if (type == WeekPeriod_ThisYearOnlyHaveMonthAndDay) {
        NSDateComponents * today = [self.calendar components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
        [self.dateFormatter setDateFormat:@"yyyy年MM月dd日"];
        if (dComponents.year == today.year) {
            [self.dateFormatter setDateFormat:@"M月d日"];
        }
    } else if (type == WeekPeriod_OnlyMonthAndDay) {
        [self.dateFormatter setDateFormat:@"M月d日"];
    } else if (type == WeekPeriod_YearAndMonthAndDay) {
        [self.dateFormatter setDateFormat:@"yyyy年MM月dd日"];
    }
    
    return [NSString stringWithFormat:@"%@—%@",[self.dateFormatter stringFromDate:firstDate],[self.dateFormatter stringFromDate:lastDate]];
}



+(NSTimeInterval)dayForWeek:(dateOfWeek)day{
    NSDate *date = [NSDate date];
    return [self dayForWeek:day date:date];
}

+(NSTimeInterval)dayForWeek:(dateOfWeek)day date:(NSDate*)date{
    
    self.dateFormatter.dateFormat = @"yyyy-MM-dd";
    NSString *dateStr = [self.dateFormatter stringFromDate:date];
    NSDate *date1 = [self.dateFormatter dateFromString:dateStr];
    NSDateComponents *dComponents = [self.calendar components:NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date1];
    
    long dayNum = [dComponents weekday]>=2 ? [dComponents weekday] -1 : 7;
    NSDate *monday = [date1 dateByAddingTimeInterval: - (dayNum -1) * 60 * 60 * 24];
    NSDate *lastMonday = [monday dateByAddingTimeInterval:-7*60*60*24];
    NSDate *nextMonday = [monday dateByAddingTimeInterval:7*60*60*24];
    NSTimeInterval timeInterval;
    if (day == Monday) {
        timeInterval = [self timeIntervalOfChangedDate:monday];
    }else if (day == LastMonday){
        timeInterval = [self timeIntervalOfChangedDate:lastMonday];
    }else if (day == NextMonday){
        timeInterval = [self timeIntervalOfChangedDate:nextMonday];
    }
    
    return timeInterval;
}

+(NSDate *)dayForSevenDate:(NSDate*)date{
    
    self.dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateStr = [self.dateFormatter stringFromDate:date];
    NSDate *date1 = [self.dateFormatter dateFromString:dateStr];
//    NSDateComponents *dComponents = [self.calendar components:NSCalendarUnitWeekday|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date1];
    
    NSDate *nextSevenDate = [date1 dateByAddingTimeInterval:7*60*60*24];
    
    return nextSevenDate;
}


+(NSDictionary *)getCurrentWeekDay{
    
    NSDictionary *dict = nil;
    NSDateComponents *dComponents = [self.calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    if (dComponents.weekday == 1 || dComponents.weekday == 7) {
        dict = @{@"1":@"星期一"};
    }else{
        switch (dComponents.weekday) {
            case 2:
                dict = @{@"1":@"星期一"};
                break;
            case 3:
                dict = @{@"2":@"星期二"};
                break;
            case 4:
                dict = @{@"3":@"星期三"};
                break;
            case 5:
                dict = @{@"4":@"星期四"};
                break;
            case 6:
                dict = @{@"5":@"星期五"};
                break;
                
            default:
                break;
        }
    }
    return dict;
}

+(NSDictionary *)getCurrentWeekDayIncludeWeekend{
    
    NSDictionary *dict = nil;
    NSDateComponents *dComponents = [self.calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    
    switch (dComponents.weekday) {
        case 2:
            dict = @{@"1":@"星期一"};
            break;
        case 3:
            dict = @{@"2":@"星期二"};
            break;
        case 4:
            dict = @{@"3":@"星期三"};
            break;
        case 5:
            dict = @{@"4":@"星期四"};
            break;
        case 6:
            dict = @{@"5":@"星期五"};
            break;
        case 7:
            dict = @{@"6":@"星期六"};
            break;
        case 1:
            dict = @{@"7":@"星期日"};
            break;
            
        default:
            break;
    }
    
    return dict;
}

+(NSString*)getWeekDayKeyInSegment:(NSInteger)index{
    NSString *key;
    
    switch (index) {
        case 0:
            key = @"星期一";
            break;
        case 1:
            key = @"星期二";
            break;
        case 2:
            key = @"星期三";
            break;
        case 3:
            key = @"星期四";
            break;
        case 4:
            key = @"星期五";
            break;
        case 5:
            key = @"星期六";
            break;
        case 6:
            key = @"星期日";
            break;
        default:
            break;
    }
    
    return key;
}

+(NSDictionary *)getMonthOfDate:(monthType)type andCurrentDate:(NSDate *)currentDate{
    
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    if (type == LastMonth) {
        dayComponent.month = -1;
    }else if (type == NextMonth){
        dayComponent.month = 1;
    }else if (type == currentMonth){
        dayComponent.month = 0;
    }
    
    currentDate = [self.calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
    
    NSString *month = [NSString stringWithFormat:@"%ld年%ld月",(long)comps.year,(long)comps.month];
    
    return @{kRetMonth:month,kRetCurrentDate:currentDate};
}

+(NSDate *)beginOfMonth:(NSDate *)date{
    NSDateComponents *componentsCurrentDate = [self.calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitWeekday|NSCalendarUnitWeekOfMonth fromDate:date];
    
    NSDateComponents *componentsNewDate = [NSDateComponents new];
    componentsNewDate.year = componentsCurrentDate.year;
    componentsNewDate.month = componentsCurrentDate.month;
    componentsNewDate.weekday = self.calendar.firstWeekday;
    
    NSDate *newDate = [self.calendar dateFromComponents:componentsNewDate];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年MM月dd日";
    NSString *dateStr = [formatter stringFromDate:newDate];
    NSDate *beginDate = [formatter dateFromString:dateStr];
    return beginDate;
}

+(NSDate *)endOfMonth:(NSDate *)date{
    
    NSRange range = [self.calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    NSDate *beginDate = [self beginOfMonth:date];
    
    NSDate *endDate = [beginDate dateByAddingTimeInterval:(range.length - 1) * 60*60*24];
    
    return endDate;
    
}

+ (NSUInteger)daysAgoCount {
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [self.dateFormatter dateFromString:[self.dateFormatter stringFromDate:[NSDate date]]];
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

+ (NSString *)stringTimesAgo:(NSDate *)date {
    
    NSString *text = nil;
    
    NSDateComponents *components = [self.calendar components:NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit fromDate:date toDate:[NSDate date] options:0];
    
    NSInteger agoCount = [self daysAgoCount];
    if (agoCount > 0) {
        text = [NSString stringWithFormat:@"%ld天前", (long)agoCount];
    }else{
        agoCount = components.hour;
        if (agoCount > 0) {
            text = [NSString stringWithFormat:@"%ld小时前", (long)agoCount];
        }else{
            agoCount = components.minute;
            if (agoCount > 0) {
                text = [NSString stringWithFormat:@"%ld分钟前", (long)agoCount];
            }else{
                agoCount = components.second;
                if (agoCount > 15) {
                    text = [NSString stringWithFormat:@"%ld秒前", (long)agoCount];
                }else{
                    text = @"刚刚";
                }
            }
        }
    }
    
    return text;
}

+ (NSUInteger)daysAgoCount:(NSDate *)date {
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *midnight = [self.dateFormatter dateFromString:[self.dateFormatter stringFromDate:date]];
    return (int)[midnight timeIntervalSinceNow] / (60*60*24) *-1;
}

+ (NSString *)stringTimesFromNow:(NSDate *)date{
    
    NSString *text = nil;
    
    NSDateComponents *components = [self.calendar components:NSSecondCalendarUnit | NSMinuteCalendarUnit | NSHourCalendarUnit fromDate:date toDate:[NSDate date] options:0];
    
    NSInteger agoCount = [self daysAgoCount:date];
    if (agoCount > 0) {
        if (agoCount == 1) {
            text = [NSString stringWithFormat:@"昨天"];
            return text;
        }else if (agoCount > 1){
            self.dateFormatter.dateFormat = @"yyyy年M月d日";
            NSString *dateString = [self.dateFormatter stringFromDate:date];
            return dateString;
        }
    }else{
        return @"今天";
        agoCount = components.hour;
        if (agoCount > 0) {
            text = [NSString stringWithFormat:@"%ld小时前", (long)agoCount];
        }else{
            agoCount = components.minute;
            if (agoCount > 0) {
                text = [NSString stringWithFormat:@"%ld分钟前", (long)agoCount];
            }else{
                agoCount = components.second;
                if (agoCount > 15) {
                    text = [NSString stringWithFormat:@"%ld秒前", (long)agoCount];
                }else{
                    text = @"刚刚";
                }
            }
        }
    }
    
    return text;
}



+ (NSDate *)lastMonth:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = -1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSDate*)nextMonth:(NSDate *)date
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = +1;
    NSDate *newDate = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:date options:0];
    return newDate;
}

+ (NSInteger)day:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components day];
}

+ (NSInteger)month:(NSDate *)date
{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components month];
}

+ (NSInteger)year:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return [components year];
}

+ (NSInteger)hour:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute) fromDate:date];
    return [components hour];
}

+ (NSInteger)minute:(NSDate *)date{
    NSDateComponents *components = [[NSCalendar currentCalendar] components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|kCFCalendarUnitSecond) fromDate:date];
    return [components minute];
}


+ (NSString *)getYearAndMonthWithDate:(NSDate *)date
{
    return [NSString stringWithFormat:@"%ld年%.2ld月", (long)[DateHelper year:date], (long)[DateHelper month:date]];
}

+ (NSString *)getYearAndMonthAndDayWithDate:(NSDate *)date
{
    return [NSString stringWithFormat:@"%ld年%.2ld月%ld日", (long)[DateHelper year:date], (long)[DateHelper month:date],(long)[DateHelper day:date]];
}

+ (NSInteger)currentDay:(NSTimeInterval)time
{
    NSDate * date = [NSDate dateWithTimeIntervalSince1970:time/1000];
    return [DateHelper day:date];
}

+ (NSString *)dateTimeDifferenceWithStartTime:(long long)startTime endTime:(long long)endTime{
    NSDateFormatter *date = [[NSDateFormatter alloc]init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    NSTimeInterval start = startTime;
    NSTimeInterval end = endTime;
    NSTimeInterval value =(end - start)/1000;
    
    int second = (int)value %60;//秒
    int minute = (int)value /60%60;
    int house = (int)value / (24 * 3600)%3600;
    int day = (int)value / (24 * 3600);
    NSString *str;
    if(day == 0 && house == 0 && minute == 0 && second != 0){
        minute = 1;
    }
    str = [NSString stringWithFormat:@"%d小时%d分钟",(house+day*24),minute];
    
    return str;
}

/**
 *  返回 星期几 年-月-日
 *
 *  @param time
 *
 *  @return 星期几 年-月-日
 */
+ (NSString*)weekdayAndDateStringFromTimeInterval:(NSTimeInterval)time {
    
    NSDate *inputDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    if (time ==0) {
        inputDate = [NSDate date];
    }
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    [calendar setTimeZone: localTimeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    NSString *weekdayStr = [weekdays objectAtIndex:theComponents.weekday];
    
    NSString *dateStr = [DateHelper formaterDate:time andType:horizontalLine];
    NSString *reasultStr = [NSString stringWithFormat:@"%@ %@",weekdayStr,dateStr];
    return reasultStr;
    
}
+ (NSString*)weekdayAndDateStringFromTimeInterval:(NSTimeInterval)time andType:(todayType)type{
    
    NSString *timeStr =@"";
    if (time ==0) {
        timeStr = [DateHelper weekdayAndDateStringFromTimeInterval:time];
    }
    if (type == Todayday) {
        timeStr = [DateHelper weekdayAndDateStringFromTimeInterval:time];
    }else if (type == Lastday){
        time = (time/1000 - 24*3600)*1000;
        timeStr = [DateHelper weekdayAndDateStringFromTimeInterval:time];
    }else if (type == Nextday){
        time = (time/1000 + 24*3600)*1000;
        timeStr = [DateHelper weekdayAndDateStringFromTimeInterval:time];
    }
    return timeStr;
}

/**
 *  返回 月份
 *
 *  @param time
 *
 *  @return 月份
 */
+ (NSDictionary*)monthStringFromTimeInterval:(monthType)type andCurrentDate:(NSDate *)currentDate
{
 
    NSDateComponents *dayComponent = [NSDateComponents new];
    
    if (type == LastMonth) {
        dayComponent.month = -1;
    }else if (type == NextMonth){
        dayComponent.month = 1;
    }else if (type == currentMonth){
        dayComponent.month = 0;
    }
    
    currentDate = [self.calendar dateByAddingComponents:dayComponent toDate:currentDate options:0];
    
    NSDateComponents *comps = [self.calendar components:NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
    
    NSString *month = [NSString stringWithFormat:@"%ld月",(long)comps.month];
    
    return @{kRetMonth:month,kRetCurrentDate:currentDate};
}


+(NSTimeInterval)curentDayZeroDate:(NSDate*)date{
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = date;
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    NSDate *startDate = [calendar dateFromComponents:components];
  
    NSTimeInterval timeInterval = [self timeIntervalOfChangedDate:startDate];
    return timeInterval;
    
}


//农历转换函数
+(NSString *)LunarForSolar:(NSDate *)solarDate{
    //天干名称
    NSArray *cTianGan = [NSArray arrayWithObjects:@"甲",@"乙",@"丙",@"丁",@"戊",@"己",@"庚",@"辛",@"壬",@"癸", nil];
    
    //地支名称
    NSArray *cDiZhi = [NSArray arrayWithObjects:@"子",@"丑",@"寅",@"卯",@"辰",@"巳",@"午",@"未",@"申",@"酉",@"戌",@"亥",nil];
    
    //属相名称
    NSArray *cShuXiang = [NSArray arrayWithObjects:@"鼠",@"牛",@"虎",@"兔",@"龙",@"蛇",@"马",@"羊",@"猴",@"鸡",@"狗",@"猪",nil];
    
    //农历日期名
    NSArray *cDayName = [NSArray arrayWithObjects:@"*",@"初一",@"初二",@"初三",@"初四",@"初五",@"初六",@"初七",@"初八",@"初九",@"初十",
                         @"十一",@"十二",@"十三",@"十四",@"十五",@"十六",@"十七",@"十八",@"十九",@"二十",
                         @"廿一",@"廿二",@"廿三",@"廿四",@"廿五",@"廿六",@"廿七",@"廿八",@"廿九",@"三十",nil];
    
    //农历月份名
    NSArray *cMonName = [NSArray arrayWithObjects:@"*",@"正",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九",@"十",@"十一",@"腊",nil];
    
    //公历每月前面的天数
    const int wMonthAdd[12] = {0,31,59,90,120,151,181,212,243,273,304,334};
    
    //农历数据
    const int wNongliData[100] = {2635,333387,1701,1748,267701,694,2391,133423,1175,396438
        ,3402,3749,331177,1453,694,201326,2350,465197,3221,3402
        ,400202,2901,1386,267611,605,2349,137515,2709,464533,1738
        ,2901,330421,1242,2651,199255,1323,529706,3733,1706,398762
        ,2741,1206,267438,2647,1318,204070,3477,461653,1386,2413
        ,330077,1197,2637,268877,3365,531109,2900,2922,398042,2395
        ,1179,267415,2635,661067,1701,1748,398772,2742,2391,330031
        ,1175,1611,200010,3749,527717,1452,2742,332397,2350,3222
        ,268949,3402,3493,133973,1386,464219,605,2349,334123,2709
        ,2890,267946,2773,592565,1210,2651,395863,1323,2707,265877};
    
    static long wCurYear,wCurMonth,wCurDay;
    static long nTheDate,nIsEnd,m,k,n,i,nBit;
    
    //取当前公历年、月、日
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit fromDate:solarDate];
    wCurYear = [components year];
    wCurMonth = [components month];
    wCurDay = [components day];
    
    //计算到初始时间1921年2月8日的天数：1921-2-8(正月初一)
    nTheDate = (wCurYear - 1921) * 365 + (wCurYear - 1921) / 4 + wCurDay + wMonthAdd[wCurMonth - 1] - 38;
    if((!(wCurYear % 4)) && (wCurMonth > 2))
        nTheDate = nTheDate + 1;
    
    //计算农历天干、地支、月、日
    nIsEnd = 0;
    m = 0;
    while(nIsEnd != 1)
    {
        if(wNongliData[m] < 4095)
            k = 11;
        else
            k = 12;
        n = k;
        while(n>=0)
        {
            //获取wNongliData(m)的第n个二进制位的值
            nBit = wNongliData[m];
            for(i=1;i<n+1;i++)
                nBit = nBit/2;
            
            nBit = nBit % 2;
            
            if (nTheDate <= (29 + nBit))
            {
                nIsEnd = 1;
                break;
            }
            
            nTheDate = nTheDate - 29 - nBit;
            n = n - 1;
        }
        if(nIsEnd)
            break;
        m = m + 1;
    }
    wCurYear = 1921 + m;
    wCurMonth = k - n + 1;
    wCurDay = nTheDate;
    if (k == 12)
    {
        if (wCurMonth == wNongliData[m] / 65536 + 1)
            wCurMonth = 1 - wCurMonth;
        else if (wCurMonth > wNongliData[m] / 65536 + 1)
            wCurMonth = wCurMonth - 1;
    }
    
    //生成农历天干、地支、属相
    NSString *szShuXiang = (NSString *)[cShuXiang objectAtIndex:((wCurYear - 4) % 60) % 12];
    NSString *szNongli = [NSString stringWithFormat:@"%@(%@%@)年",szShuXiang, (NSString *)[cTianGan objectAtIndex:((wCurYear - 4) % 60) % 10],(NSString *)[cDiZhi objectAtIndex:((wCurYear - 4) % 60) % 12]];
    
    //生成农历月、日
    NSString *szNongliDay;
    if (wCurMonth < 1){
        szNongliDay = [NSString stringWithFormat:@"闰%@",(NSString *)[cMonName objectAtIndex:-1 * wCurMonth]];
    }
    else{
        szNongliDay = (NSString *)[cMonName objectAtIndex:wCurMonth];
    }
    
    NSString *lunarDate = [NSString stringWithFormat:@"%@ %@月 %@",szNongli,szNongliDay,(NSString *)[cDayName objectAtIndex:wCurDay]];
    
    return lunarDate;
}

+ (NSString *)getAstroWithMonth:(int)m day:(int)d
{
    NSString *astroString = @"魔羯水瓶双鱼白羊金牛双子巨蟹狮子处女天秤天蝎射手魔羯";
    NSString *astroFormat = @"102123444543";
    NSString *result;
    if (m<1||m>12||d<1||d>31){
        return @"错误日期格式!";
    }
    if(m==2 && d>29){
        return @"错误日期格式!!";
    }else if(m==4 || m==6 || m==9 || m==11) {
        if (d>30) {
            return @"错误日期格式!!!";
        }
    }
    result=[NSString stringWithFormat:@"%@",[astroString substringWithRange:NSMakeRange(m*2-(d < [[astroFormat substringWithRange:NSMakeRange((m-1), 1)] intValue] - (-19))*2,2)]];
    return result;
}

+ (NSString *)getAmimalWithYear:(int)year
{
    int zodiacSignsStart = 1804;
    NSArray * animals = @[@"鼠", @"牛", @"虎", @"兔", @"龙", @"蛇", @"马", @"羊", @"猴", @"鸡", @"狗", @"猪"];
    if(year < zodiacSignsStart){
        return @"未知";
    }
    return animals[(year - zodiacSignsStart) % animals.count];
}



+(BOOL)isTeachersDay:(NSDate *)date{
    NSTimeInterval timeInterval = [DateHelper timeIntervalOfChangedDate:date];
    NSString *time = [DateHelper stringFormatOfTime:timeInterval style:WWTimeStringDateOnlyShortStyle];
    if ([time isEqualToString:@"9月10日"]) {
        return YES;
    }
    return NO;
}


@end
