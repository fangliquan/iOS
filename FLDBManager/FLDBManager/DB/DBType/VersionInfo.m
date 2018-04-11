
#import "VersionInfo.h"

@implementation VersionInfo
@synthesize version;
@synthesize minSupport;
@synthesize buildTime;
@synthesize relativePath;
@synthesize revision;
@synthesize releaseNote;

+(bool)isInSystemDB {
    return YES;
}

+(NSString *)getPrimaryKey
{
    return @"rowid";
}

+(NSString *)getTableName
{
    return @"VersionInfo";
}

@end
