
#import "SystemInfo.h"

@implementation SystemInfo

@synthesize currentVersion;
@synthesize lastVersionCheckTime;
@synthesize latestVersion;

+(bool)isInSystemDB {
    return YES;
}

+(NSString *)getPrimaryKey
{
    return @"rowid";
}

+(NSString *)getTableName
{
    return @"SystemInfo";
}

@end
