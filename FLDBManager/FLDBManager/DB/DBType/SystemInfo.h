
#import <Foundation/Foundation.h>
#import "BaseModel.h"

@interface SystemInfo : BaseModel

@property (nonatomic, copy) NSString *currentVersion;
@property (nonatomic) long long lastVersionCheckTime;
@property (nonatomic, copy) NSString *latestVersion;

@end


