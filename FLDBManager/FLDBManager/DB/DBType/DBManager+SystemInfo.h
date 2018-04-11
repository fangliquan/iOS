
#import "DBManagerBase.h"
#import "SystemInfo.h"
@class VersionInfo;

@interface DBManager (SystemInfo)

-(NSString *) getCurrentVersion;
-(void)saveCurrentVersion:(NSString*)version;

-(VersionInfo *) getLatestVersion;
-(void)saveLatestVersion:(VersionInfo*)version;

-(long long) getLastVersionCheckTime;
-(void)saveLastVersionCheckTime:(long long)timeStamp;

@end
