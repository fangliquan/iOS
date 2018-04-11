
#import "DBManager+SystemInfo.h"
#import "VersionInfo.h"
@implementation DBManager (SystemInfo)

#pragma mark - public function

-(NSString *) getCurrentVersion
{
    SystemInfo * systemInfo = [self loadTableFirstData:[SystemInfo class] Condition:nil];
    return systemInfo.currentVersion;
}

-(void)saveCurrentVersion:(NSString *)version
{
    NSArray *arr = [self loadTableData:[SystemInfo class]];
    if (arr && arr.count > 1) {
        [self cleanTableData:[SystemInfo class]];
    }
    SystemInfo * systemInfo = [self loadTableFirstData:[SystemInfo class] Condition:nil];
    if (!systemInfo) {
        systemInfo = [[SystemInfo alloc] init];
    }
    systemInfo.currentVersion = version;
    
    [[DBManager sharedInstance] saveData:systemInfo];
}

-(VersionInfo *) getLatestVersion
{
    return [self loadTableFirstData:[VersionInfo class] Condition:nil];
}

-(void)saveLatestVersion:(VersionInfo *)version
{
    [self cleanTableData:[VersionInfo class]];
    [self saveData:version];
}

-(long long) getLastVersionCheckTime
{
    SystemInfo * systemInfo = [self loadTableFirstData:[SystemInfo class] Condition:nil];
    return systemInfo.lastVersionCheckTime;
}

-(void)saveLastVersionCheckTime:(long long)timeStamp
{
    SystemInfo * systemInfo = [self loadTableFirstData:[SystemInfo class] Condition:nil];
    if (!systemInfo) {
        systemInfo = [[SystemInfo alloc] init];
    }
    systemInfo.lastVersionCheckTime = timeStamp;
    
    [[DBManager sharedInstance] saveData:systemInfo];
}

@end
