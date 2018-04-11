
#import "BaseModel.h"
#include <sqlite3.h>
#import "DBManager.h"
@implementation BaseModel

@synthesize updateTime, deleted;

+(bool)isInSystemDB {
    return NO;
}

+(bool)isOrderDesc {
    return YES;
}

+(BaseModel*)createModelFromDic:(NSDictionary*)dic
{
    if(![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    BaseModel *model = [[self class] alloc];
    
    LKModelInfos* infos = [self getModelInfos];
    
    LKDBProperty* primaryProperty = [model singlePrimaryKeyProperty];
    
    for (int i=0; i<infos.count; i++) {
        
        LKDBProperty* property = [infos objectWithIndex:i];
        if([LKDBUtils checkStringIsEmpty:property.sqlColumnName])
            continue;
        
        if([property isEqual:primaryProperty])
        {
            id val = [dic objectForKey:@"id"];
            if(val){
                [model setValue:val forKey:property.sqlColumnName];
            }
        }
        else if([dic objectForKey:property.propertyName])
        {
            id columnValue = [dic objectForKey:property.propertyName];
            if(columnValue){
                [model setValue:columnValue forKey:property.propertyName];//recordTime赋值后有错误model类型改为long long正确
            }
        }
    }
    
    return model;
}

+(BOOL)isContainParent
{
    return YES;
}

+(id)loadDataById:(long)pkId
{
    return [[DBManager sharedInstance] loadTableFirstData:[self class] Condition:[NSString stringWithFormat:@" where %@ = %ld", [self getPrimaryKey], pkId]];
}

-(void)save {
    [[DBManager sharedInstance] saveData:self];
}

@end

@implementation NSObject(PrintSQL)

+(NSString *)getCreateTableSQL
{
    LKModelInfos* infos = [self getModelInfos];
    NSString* primaryKey = [self getPrimaryKey];
    NSMutableString* table_pars = [NSMutableString string];
    for (int i=0; i<infos.count; i++) {
        
        if(i > 0)
            [table_pars appendString:@","];
        
        LKDBProperty* property =  [infos objectWithIndex:i];
        [self columnAttributeWithProperty:property];
        
        [table_pars appendFormat:@"%@ %@",property.sqlColumnName,property.sqlColumnType];
        
        if([property.sqlColumnType isEqualToString:LKSQL_Type_Text])
        {
            if(property.length>0)
            {
                [table_pars appendFormat:@"(%d)",property.length];
            }
        }
        if(property.isNotNull)
        {
            [table_pars appendFormat:@" %@",LKSQL_Attribute_NotNull];
        }
        if(property.isUnique)
        {
            [table_pars appendFormat:@" %@",LKSQL_Attribute_Unique];
        }
        if(property.checkValue)
        {
            [table_pars appendFormat:@" %@(%@)",LKSQL_Attribute_Check,property.checkValue];
        }
        if(property.defaultValue)
        {
            [table_pars appendFormat:@" %@ %@",LKSQL_Attribute_Default,property.defaultValue];
        }
        if(primaryKey && [property.sqlColumnName isEqualToString:primaryKey])
        {
            [table_pars appendFormat:@" %@",LKSQL_Attribute_PrimaryKey];
        }
    }
    NSString* createTableSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@(%@)",[self getTableName],table_pars];
    return createTableSQL;
}

+(NSDictionary*)getDictionaryForModel:(BaseModel*)model
{
    NSMutableDictionary *ret = [[NSMutableDictionary alloc] init];
    
    LKModelInfos* infos = [self getModelInfos];
    
    LKDBProperty* primaryProperty = [model singlePrimaryKeyProperty];
    
    for (int i=0; i<infos.count; i++) {
        
        LKDBProperty* property = [infos objectWithIndex:i];
        if([LKDBUtils checkStringIsEmpty:property.sqlColumnName])
            continue;
        
        NSString *key = property.propertyName;
        if([property isEqual:primaryProperty])
        {
            if([model singlePrimaryKeyValueIsEmpty])
                continue;
            key = @"id";
        }
        
        
        id value = [BaseModel modelValueWithProperty:property model:model];
        if([self isPropertyTypeOfBOOL:property.propertyName forModel:model]){
            value = [@"0" isEqualToString:value] ? @"false" : @"true";
        }
        
        [ret setValue:value forKey:key];
    }
    
    return ret;
}

+(BOOL)isPropertyTypeOfBOOL:(NSString*)propertyName forModel:(BaseModel*)model{
    objc_property_t theProperty = class_getProperty([model class], [propertyName UTF8String]);
    const char * propertyAttrs = property_getAttributes(theProperty);
    NSString *propertyTypeString = [NSString stringWithCString: propertyAttrs encoding:NSUTF8StringEncoding];
    BOOL isBool = [propertyTypeString hasPrefix:@"TB"];
    return isBool;
}

+(NSString*)getInsertDataSQL:(BaseModel*)model
{
    LKModelInfos* infos = [self getModelInfos];
    
    NSMutableString* insertKey = [NSMutableString stringWithCapacity:0];
    NSMutableString* insertValuesString = [NSMutableString stringWithCapacity:0];
    NSMutableArray* insertValues = [NSMutableArray arrayWithCapacity:infos.count];
    
    
    LKDBProperty* primaryProperty = [model singlePrimaryKeyProperty];
    
    for (int i=0; i<infos.count; i++) {
        
        LKDBProperty* property = [infos objectWithIndex:i];
        if([LKDBUtils checkStringIsEmpty:property.sqlColumnName])
            continue;
        
        if([property isEqual:primaryProperty])
        {
            if([model singlePrimaryKeyValueIsEmpty])
                continue;
        }
        
        if(insertKey.length>0)
        {
            [insertKey appendString:@","];
            [insertValuesString appendString:@","];
        }
        
        [insertKey appendString:property.sqlColumnName];
        
        id value = [BaseModel modelValueWithProperty:property model:model];
        if(![value isKindOfClass:[NSNull class]]) {
            const char *s = [value UTF8String];
            char *str = (char *)sqlite3_mprintf("%q",s);
            NSString *valueString = [NSString stringWithCString:str encoding:NSUTF8StringEncoding];
            [insertValuesString appendFormat:@"\'%@\'", valueString];
        } else {
            [insertValuesString appendString:@"\''"];
        }
        
        [insertValues addObject:value];
    }
    
    //拼接insertSQL 语句  采用 replace 插入
    NSString* insertSQL = [NSString localizedStringWithFormat:@"replace into %@(%@) values (%@)",[self getTableName],insertKey,insertValuesString];
    
    return insertSQL;
}

-(id)modelValueWithProperty:(LKDBProperty *)property model:(NSObject *)model {
    id value = nil;
    if(property.isUserCalculate)
    {
        value = [model userGetValueForModel:property];
    }
    else
    {
        value = [model modelGetValue:property];
    }
    if(value == nil)
    {
        value = @"";
    }
    return value;
}

@end
