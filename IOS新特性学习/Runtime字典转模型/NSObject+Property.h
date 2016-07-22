//
//  NSObject+Property.h
//  IOS新特性
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//  通过解析字典自动生成属性代码

#import <Foundation/Foundation.h>

@interface NSObject (Property)

+(NSString *)createPropertyCodeWithDict:(NSDictionary *)dict;

@end
