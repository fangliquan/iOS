//
//  SonPerson.h
//  IOS新特性
//
//  Created by leo on 16/7/21.
//  Copyright © 2016年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Person.h"
@interface SonPerson :Person

/**
 *  会自动识别当前对象类型
 *
 */
+(instancetype)person;

//__kindof Person *：表示可以是Person类或者他的子类
+(__kindof Person*)personkindof;

@end
