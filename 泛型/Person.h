//
//  Person.h
//  IOS新特性
//
//  Created by leo on 16/7/21.
//  Copyright © 2016年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Language.h"

@interface Person<__covariant ObjectType> : NSObject


@property(nonatomic) ObjectType language;


-(ObjectType)language;

-(void)setLanguage:(ObjectType)language;

/**
 *  id:任何对象都可以传过来
    language 在外面调用没有提示，
 */


@end
