//
//  DateHelper.h
//  wwface
//
//  Created by James on 14/11/28.
//  Copyright (c) 2014年 fo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kRetMonth @"month"
#define kRetCurrentDate @"currentDate"

@interface DateHelper : NSObject

typedef NS_ENUM(NSInteger, timeStyle) {
    dateOnly,
    timeOnly,
    dateAndTime,
    birthday,
    commentTime,
    commentNotHour, // 类似 commentTime， 无具体小时和分
    wholeFormat,
    horizontalLine,  // xx-xx-xx
    yearMonth,
    monthOnly,
    timeOrDate,
    dateAndTimeOnly,
    dayOnly
};

typedef NS_ENUM(NSInteger, dateOfWeek) {
    Monday,
    LastMonday,
    NextMonday
};

typedef NS_ENUM(NSInteger, monthType) {
    currentMonth,
    LastMonth,
    NextMonth
};

typedef NS_ENUM(NSInteger, todayType) {
    Todayday,//今天
    Lastday,//上一天
    Nextday,//下一天
};

typedef NS_ENUM(NSInteger, WeekPeriodFormatType) {  // 获取周段的时间格式,不是本年的时候是否拼接年份
    WeekPeriod_OnlyMonthAndDay,             // xx月xx日--xx月xx日
    WeekPeriod_ThisYearOnlyHaveMonthAndDay, // thisYear:xx月xx日--xx月xx日 lastYear:xx年xx月xx日--xx年xx月xx日
    WeekPeriod_YearAndMonthAndDay           // xx年xx月xx日
};



#pragma mark- New type

typedef NS_ENUM(NSInteger, WWTimeStringStyle) {
    
    WWTimeStringOnlyMonthAndDayStyle,
    WWTimeStringDateOnlyShortStyle,     // (今年: xx月xx日  今年以前: xx年xx月xx日)
    WWTimeStringDateOnlyLongStyle,      // (xx年xx月xx日)
    
    WWTimeStringMonthOnlyShortStyle,    // (今年: xx月  今年以前: xx年xx月)
    WWTimeStringMonthOnlyLongStyle,     // (xx年xx月)
    
    WWTimeStringTimeShortStyle,         // (xx:xx)
    
    WWTimeStringDateAndTimeOnlyStyle,   // (xx月xx日 xx:xx)
    WWTimeStringDateAndTimeStyle,       // (今年: xx月xx日 xx:xx  今年以前: xx年xx月xx日 xx:xx)
    WWTimeStringDateAndTimeFullStyle,   // (xx年xx月xx日 xx:xx)
    
    WWTimeStringDateOfLineShortStyle,   // (xx-xx-xx)
    WWTimeStringDateOfLineLongStyle,    // (xx-xx-xx xx:xx)
    
    WWTimeStringCommentTimeShortStyle,  // (无具体小时、分)
    WWTimeStringCommentTimeLongStyle,   // (有具体小时、分)
    
    WWTimeStringChatTimeStyle,          // (聊天界面使用(当前天内只显示 时分))
    WWTimeStringChatTimeListStyle,      // (聊天界面使用(当前天内按 stringTimesAgo: 方法显示))
};

typedef NS_ENUM(NSInteger, WWAgeStringStyle) {
    WWAgeStringShortStyle,  // (x岁/x个月/x天)
    WWAgeStringLongStyle,   // (x岁x个月x天 (当天: 生日))
};

#pragma mark- New func
/**
 *  根据时间获取时间字符串
 *
 *  @param time  时间 (long long)
 *  @param style WWTimeStringStyle
 *
 *  @return 时间字符串
 */
+ (NSString *)stringFormatOfTime:(NSTimeInterval)time style:(WWTimeStringStyle)style;
/**
 *  根据时间获取生日相关字符串
 *
 *  @param birthday 生日
 *  @param style    WWAgeStringStyle
 *
 *  @return 生日相关字符串
 */
+ (NSString *)stringFormatOfBirthday:(NSTimeInterval)birthday style:(WWAgeStringStyle)style;
/**
 *  根据生日、发布时间获取时间相关字符串 (成长记列表使用)
 *
 *  @param birthday   生日
 *  @param sourceTime 发布时间
 *  @param style      WWAgeStringStyle
 *
 *  @return 时间相关字符串
 */
+ (NSString *)stringFormatOfBirthday:(NSTimeInterval)birthday sourceTime:(NSTimeInterval)sourceTime style:(WWAgeStringStyle)style;
/**
 *  获取当前时间 NSTimeInterval
 */
+ (NSTimeInterval)timeIntervalNow;
/**
 *  将 NSDate 转为 NSTimeInterval
 */
+ (NSTimeInterval)timeIntervalOfChangedDate:(NSDate *)date;
/**
 *  获取当前时间字符串 (xx月xx日)
 */
+ (NSString *)stringOfCurrentTime;
/**
 *  获取当前时间字符串 (yyyy-MM-dd HH:mm:ss)
 */
+ (NSString *)stringFullStyleOfCurrentTime;

/**
 *  获取当前时间字符串 (yyyy)
 */
+ (NSString *)stringCurrentYear;
/**
 *  获取月份个第几周 (x月 第x周)
 */
+ (NSString *)indexWeekOfMonthWithTime:(NSTimeInterval)time;
/**
 *  字符串比较 (return : 今天、昨天、dateString)
 */
+ (NSString *)stringOfDateToCompareWithDateString:(NSString *)dateString;
/**
 *  根据时间字符串获取 date
 */
+ (NSDate *)dateFromString:(NSString *)string style:(WWTimeStringStyle)style;
+ (NSDate *)getDateOnlyDate:(NSDate *)date;
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)anyDate andAbbreviation:(NSString *)abbreviatione;



#pragma mark- old func

+(BOOL)isSameDay:(NSTimeInterval)time1 With:(NSTimeInterval)time2;




#pragma mark- 获取一周的时间段
/**
 *  用 getWeekPeriodOfDate 方法的 WeekPeriod_HaveYear type 取代
 */ 
+ (NSString *)getWeekOfDate:(NSTimeInterval)time;
/**
 *  获取一周的时间段
 *
 *  @param time time
 *  @param type WeekPeriodFormatType
 *
 *  @return weekTimeStr
 */
+ (NSString *)getWeekPeriodOfDate:(NSTimeInterval)time weekPeriodType:(WeekPeriodFormatType)type;

/**
 *  获取本周、上周、下周的 mondayTime
 */
+(NSTimeInterval)dayForWeek:(dateOfWeek)day;
+(NSTimeInterval)dayForWeek:(dateOfWeek)day date:(NSDate*)date;
/**
 *  获取当前时间七天后时间
 */
+(NSDate *)dayForSevenDate:(NSDate*)date;
/**
 *  获取星期
 */
+(NSDictionary *)getCurrentWeekDay;
+(NSDictionary *)getCurrentWeekDayIncludeWeekend;
+(NSString*)getWeekDayKeyInSegment:(NSInteger)index;

/**
 *  获取月份
 */
+(NSDictionary *)getMonthOfDate:(monthType)type andCurrentDate:(NSDate *)currentDate;
+(NSDate *)beginOfMonth:(NSDate *)date;
+(NSDate *)endOfMonth:(NSDate *)date;

/**
 *  上一个月的 date
 */
+ (NSDate *)lastMonth:(NSDate *)date;
/**
 *  下月的 date
 */
+ (NSDate*)nextMonth:(NSDate *)date;
/**
 *  获取 date 的月、日、年
 */
+ (NSInteger)day:(NSDate *)date;
+ (NSInteger)month:(NSDate *)date;
+ (NSInteger)year:(NSDate *)date;
+ (NSInteger)hour:(NSDate *)date;
+ (NSInteger)minute:(NSDate *)date;
/**
 *  获取 年月
 */
+ (NSString *)getYearAndMonthWithDate:(NSDate *)date;
/**
 *  获取 年月日
 */
+ (NSString *)getYearAndMonthAndDayWithDate:(NSDate *)date;

+ (NSInteger)currentDay:(NSTimeInterval)time;
/**
 *  多长时间前；比如”3天前“
 */
+ (NSString *)stringTimesAgo:(NSDate *)date;
+ (NSString *)stringTimesFromNow:(NSDate *)date;
/**
 *  时间差
 */
+ (NSString *)dateTimeDifferenceWithStartTime:(long long)startTime endTime:(long long)endTime;

/**
 *  返回 星期几 年-月-日
 *
 *  @param time
 *
 *  @return 星期几 年-月-日
 */
+ (NSString*)weekdayAndDateStringFromTimeInterval:(NSTimeInterval)time;
+ (NSString*)weekdayAndDateStringFromTimeInterval:(NSTimeInterval)time andType:(todayType)type;
/**
 *  返回 月份
 *
 *  @param time
 *
 *  @return 月份
 */
+ (NSDictionary*)monthStringFromTimeInterval:(monthType)type andCurrentDate:(NSDate *)currentDate;
/**
 *  获取时间的0点0分0秒
 *
 *  @param date <#date description#>
 *
 *  @return <#return value description#>
 */
+(NSTimeInterval)curentDayZeroDate:(NSDate*)date;

//农历转换函数
+(NSString *)LunarForSolar:(NSDate *)solarDate;
+(NSString *)getAstroWithMonth:(int)m day:(int)d;
+(NSString *)getAmimalWithYear:(int)year;

+(BOOL)isTeachersDay:(NSDate *)date;
@end
