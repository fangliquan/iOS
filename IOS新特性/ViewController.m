//
//  ViewController.m
//  IOS新特性
//
//  Created by leo on 16/7/21.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()



//IOS9 关键字 nullable nonnull 只能修饰对象 不能修饰基本数据类型
@property(nonatomic, strong,null_resettable) NSString *temp;



//null_unspecified
/**
 
 不确定是否为空
 __null_unspecified
 _Null_unspecified
 

 @property(nonatomic, strong) NSString *_Null_unspecified temp1;
*/
@property(nonatomic, strong) NSString *_Null_unspecified specified;


//null_resettable
/**
  get:不能返回为空，set可以返回空
  注意:如果使用 null_resettable,必须 重写get方法或者set方法，处理传递的值为空的情况
  书写方式 @property(nonatomic, strong,null_resettable) NSString *temp;
 
 */


/*
 NS_ASSUME_NONNULL_BEGIN 之间NS_ASSUME_NONNULL_END 宏之间的都是nonnull的
 
 NS_ASSUME_NONNULL_BEGIN
 
 @property(nonatomic, strong) NSString *temp;
 NS_ASSUME_NONNULL_END

 */


//__nullable
/**
 可以为null
 *  nullable 三种方法
 @property(nonatomic, strong,nullable) NSString *temp;
 
 @property(nonatomic, strong) NSString * _Nullable temp2;
 
 @property(nonatomic, strong) NSString * __nullable temp3;
 
 */

//nonnull
/**
*  非null
 @property(nonatomic, strong,nonnull) NSString *temp;
 
 @property(nonatomic, strong) NSString * _Nonnull temp2;
 
 @property(nonatomic, strong) NSString * __nonnull temp3;
*/

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
