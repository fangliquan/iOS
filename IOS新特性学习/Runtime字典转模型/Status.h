//
//  Status.h
//  IOS新特性
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@interface Status : NSObject

@property(nonatomic, assign) int ID;
@property(nonatomic, strong) NSString *source;

@property(nonatomic, assign) int reposts_count;

@property(nonatomic, strong) NSArray *pic_urls;

@property(nonatomic, strong) NSString *created_at;

@property(nonatomic, assign) int attitudes_count;

@property(nonatomic, strong) NSString *idstr;

@property(nonatomic, strong) NSString *text;

@property(nonatomic, assign) int comments_count;

@property(nonatomic, strong) User *user;
@property(nonatomic, strong) NSDictionary *retweeted_status;
//模型属性名跟字典一一对应
+(__kindof Status *)statusWithDict:(NSDictionary *)dict;

@end

