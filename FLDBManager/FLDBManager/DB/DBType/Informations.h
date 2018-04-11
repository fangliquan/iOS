
#import <Foundation/Foundation.h>
#import "BaseModel.h"

#define KEY_DB_CREATE_TIMESTAMP @"KEY_DB_CREATE_TIMESTAMP"


@interface Informations : BaseModel

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *itemValue;

+(id)getValueByName:(NSString*)name;

@end


