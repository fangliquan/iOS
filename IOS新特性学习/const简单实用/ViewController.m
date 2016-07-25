//
//  ViewController.m
//  const简单实用
//
//  Created by microleo on 16/7/23.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
/*
 const作用:
 1.仅仅是用来修饰右边的变量(只能修饰变量：基本变量，指针变量，对象变量)
 2.const修饰的变量，表示只读
 
 
 const 书写规范:移动要放在变量的左边
 
 */
//宏替代常用的字符串常量
/*
 const 开发中使用场景
1. 定义一个只读的变量
2. 在方法中定义只读参数
 
 */
@implementation ViewController

NSString * const name = @"1234500";

//修饰对象
-(void )test:(NSString * const)name{
    
}
//修饰基本变量
-(void)test1 :(int const)a{
    
}
//修饰指针变量
-(void)test2:(int const *)p{
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //const修饰基本变量
    //只读变量
    //方式一
    //int const a = 10;
    //方式二
    //const int b = 10;
    
    
    //用const 修饰指针变量
    /*
     int *const p = &m;//p:只读变量 *p:变量
     const int *p = &m;//*p:只读变量 p:变量
     int const *p = &m; //*p:只读 p:变量
     int const * const p = &m; //*p: 只读 p:只读
     const int * const p = &m ;//*p: 只读 p:只读
     */
    int m = 10;
    int n = 20;
    
    int *p = &m;
    
    *p = 30;
    
    //const 修饰对象变量
    
    NSString * const name = @"";
    
    //name = @"";
    
    NSLog(@"%d",n);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
