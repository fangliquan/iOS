#import "PublicUtil.h"

@implementation PublicUtil


+ (NSString *) NSStringFromCString:(const char*) str
{
    NSString *ret = @"";
    if (str)
    {
        ret = [NSString stringWithUTF8String:str];
    }
    
    return ret;
}

@end
