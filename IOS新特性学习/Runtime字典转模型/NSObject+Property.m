//
//  NSObject+Property.m
//  IOS新特性
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "NSObject+Property.h"

@implementation NSObject (Property)

+(NSString *)createPropertyCodeWithDict:(NSDictionary *)dict{
    
  //  @property(nonatomic, strong) NSArray *array;
    
    
    
    
    //属性代码
    NSMutableString *strM = [NSMutableString string];
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull propertyName, id  _Nonnull value, BOOL * _Nonnull stop) {
        NSLog(@"%@ %@",propertyName,[value class]);
        NSString *code;
        //属性策略 判断value类型，对象strong，基本数据类型 assign
        if ([value isKindOfClass:NSClassFromString(@"__NSCFString")]) {
            code = [NSString stringWithFormat:@"@property(nonatomic, strong) NSString *%@;",propertyName];
        }else if ( [value isKindOfClass:NSClassFromString(@"__NSCFArray")]) {
            code = [NSString stringWithFormat:@"@property(nonatomic, strong) NSArray *%@;",propertyName];
        }else if ([value isKindOfClass:NSClassFromString(@"__NSCFDictionary")]) {
            code = [NSString stringWithFormat:@"@property(nonatomic, strong) NSDictionary *%@;",propertyName];
        } else if ( [value isKindOfClass:NSClassFromString(@"__NSCFNumber")]) {
            code = [NSString stringWithFormat:@"@property(nonatomic, assign) int %@;",propertyName];
        }
        [strM appendFormat:@"\n%@\n",code];
    }];
    NSLog(@"%@",strM);
    
//    NSString *polity;//属性策略
//    NSString *type;//属性类型
//    NSString *propertyName;//属性名
    return @"";
   // code = [NSString stringWithFormat:@"@property(nonatomic, %@) %@ %@",polity,type,propertyName];
}
@end
