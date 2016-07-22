//
//  Status.m
//  IOS新特性
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "Status.h"

@implementation Status

+(Status *)statusWithDict:(NSDictionary *)dict{
    Status *status = [[self alloc]init];
    //KVC
    [status setValuesForKeysWithDictionary:dict];
    return status;
}
//解决KVC报错
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = [value intValue];
    }
    //key 没有找到的key
    //value 没有找到的key值
    NSLog(@"%@,%@",key ,value);
}


@end
