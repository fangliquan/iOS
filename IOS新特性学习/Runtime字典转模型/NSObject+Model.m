//
//  NSObject+Model.m
//  IOS新特性
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/message.h>
@implementation NSObject (Model)

+(instancetype)modelWithDict:(NSDictionary *)dict{
    //创建对应类的对象
    id objc = [[self alloc]init];
    //runtime：遍历模型中所有属性名，去字典查找
    //属性定义在哪，定义在类，类里面有个属性列表（数组)
    //遍历模型所有属性名
    //ivar :成员属性
    //class_coypIvarList把成员属性列表复制一份给你
    //Ivar*:指向一个成员变量的数组
//    Ivar ivar1;
//    Ivar ivar2;
//    Ivar a[] = {ivar1,ivar2};
     /// class 获取那个类的成员属性列表
    //count 成员属性的总数，
    unsigned int count = 0;
    Ivar *ivarList = class_copyIvarList(self, &count);
    for (int i =0 ; i< count; i++) {
        //获取成员属性
        Ivar ivar = ivarList[i];
        //获取成员名
        NSString *propertyName = [NSString stringWithUTF8String:ivar_getName(ivar)];
        //获取key
        NSString *key = [propertyName substringFromIndex:1];
        //user value :字典
        //获取字典的value
        id value = dict[key];
        //给模型的属性赋值
        //value:字典的值
        //key：属性名
        //获取成员名，成员属性类型
        NSString *propertyType = [NSString stringWithUTF8String:ivar_getTypeEncoding(ivar)];
        //NSLog(@"%@",propertyType);
        //二级转换
        //值是字典，成员属性的类型不是字典，才需要转换成模型
        if ([value isKindOfClass:[NSDictionary class]] && ![propertyType containsString:@"NS"]) {//组要将字典转成模型
            //转换成那个类型
            //获取需要转换类的类对象
            NSRange range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringFromIndex:range.location +range.length];
            range = [propertyType rangeOfString:@"\""];
            propertyType = [propertyType substringToIndex:range.location];
            Class modelClass = NSClassFromString(propertyType);
            if (modelClass) {
                value = [modelClass modelWithDict:value];
            }
        }
        if (value) {
            [objc setValue:value forKey:key];
        }
    }
    return objc;
}
@end
