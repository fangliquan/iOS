//
//  NSObject+Objc.h
//  IOS新特性
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

//只会生成声明和get方法
@interface NSObject (Objc)

@property(nonatomic, strong) NSString *name;

@end
