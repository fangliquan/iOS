//
//  Person.m
//  IOS新特性
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "Person.h"
#import <objc/message.h>
@implementation Person
//定义函数
void asas(id self, SEL _cmd,id param1){
    NSLog(@"调用eat %@ %@ %@",self,NSStringFromSelector(_cmd),param1);
}

//默认一个方法都有两个参数，self，_cmd
//self 方法调用者
//_cmd：调用方法的编号
/**
 *  动态添加方法，首先实现这个方法
 *  resolveInstanceMethod调用:当调用了没有实现的方法 没有实现就会调用resolveInstanceMethod
 *  @param sel 没有实现的方法
 *
 *  @return
 */
+(BOOL)resolveInstanceMethod:(SEL)sel{
    
    NSLog(@"%@",NSStringFromSelector(sel));
    //动态添加eat方法
    if (sel == @selector(eat:)) {
        /**
         *  class 给那个类添加方法
         *  SEL:添加方法的方法编号是什么
         *  IMP:方法实现。函数入口,函数名
         *  types：方法类型
         */
        class_addMethod(self, sel, (IMP)asas, "v@:@");
    }
    return [super resolveInstanceMethod:sel];
    
}
@end
