//
//  NSObject+Objc.m
//  IOS新特性
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "NSObject+Objc.h"
#import <objc/message.h>

@implementation NSObject (Objc)

static NSString *_name;

-(void)setName:(NSString *)name{
    
    /**
     *  添加属性，跟对象
     给某个对象产生关系，添加属性
     object:给那个对象添加属性
     key:属性名，根据key区获取关联的对象，void* = id
     vlaue:g关联的值
     policy:策越
     */
    objc_setAssociatedObject(self, @"name", name, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    //_name = name;
}

-(NSString *)name{
    return objc_getAssociatedObject(self, @"name");
}


@end
