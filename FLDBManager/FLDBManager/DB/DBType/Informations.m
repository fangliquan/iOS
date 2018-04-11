
#import "Informations.h"
#import "DBManager.h"
@implementation Informations

@synthesize itemName;
@synthesize itemValue;

+(NSString *)getPrimaryKey
{
    return @"itemName";
}

+(NSString *)getTableName
{
    return @"Informations";
}

+(id)getValueByName:(NSString*)name {
    Informations *info = [[DBManager sharedInstance]loadTableFirstData:[Informations class] Condition:[NSString stringWithFormat:@" where itemName = '%@'", name]];
    if (info) {
        return info.itemValue;
    }
    return nil;
}

@end

