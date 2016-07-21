//
//  UIImage+image.m
//  IOS新特性
//
//  Created by leo on 16/7/21.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "UIImage+image.h"
#import <objc/message.h>
@implementation UIImage(Image)

+(void)load{
    NSLog(@"%s",__func__);
    
    //交换方法实现，方法都是定义在类里面
    //class_getMethodImplementation:获取方法实现
    //class_getInstanceMethod(<#__unsafe_unretained Class cls#>, <#SEL name#>)获取对象
    //class_getClassMethod(<#__unsafe_unretained Class cls#>, <#SEL name#>)获取类方法
    //IMP:方法实现
    //Class:获取那个类方法，SEL 获取方法编号，根据SEL就能去对应的类找方法
    
    Method imageNameMethod = class_getClassMethod([UIImage class], @selector(imageNamed:));
    
    Method microImageNameMethod = class_getClassMethod([UIImage class], @selector(micro_imageName:));
    //交换方法
    method_exchangeImplementations(imageNameMethod, microImageNameMethod);
}
//运行时
//先写一个其他方法，实现这个功能
//在分类里面不能调用super，分类木有父类
+(UIImage*)micro_imageName:(NSString *)imageName{
    UIImage *image = [UIImage micro_imageName:imageName];
    if (image == nil) {
        NSLog(@"%@ image is null",imageName);
    }else{
        NSLog(@"%@ image is not null",imageName);
    }
    return image;
}
@end
