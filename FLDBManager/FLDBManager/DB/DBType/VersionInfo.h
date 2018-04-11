
#import <Foundation/Foundation.h>
#import "BaseModel.h"
@interface VersionInfo : BaseModel

@property (nonatomic, copy) NSString *version;
@property (nonatomic, copy) NSString *minSupport;
@property (nonatomic, copy) NSString *revision;
@property (nonatomic ,assign) long long buildTime;
@property (nonatomic, copy) NSString *relativePath;
@property (nonatomic, copy) NSString *releaseNote;
@property (nonatomic,copy)  NSString *releasePicture;

@end
