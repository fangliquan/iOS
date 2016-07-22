//
//  User.h
//  IOS新特性
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property(nonatomic, strong) NSString *profile_image_url;

@property(nonatomic, assign) BOOL vip;

@property(nonatomic, strong) NSString *name;

@property(nonatomic, assign) int mbrank;

@property(nonatomic, assign) int mbtype;

@end
