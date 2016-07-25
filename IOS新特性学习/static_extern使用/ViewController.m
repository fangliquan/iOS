//
//  ViewController.m
//  static_extern使用
//
//  Created by leo on 16/7/25.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
//定义一个全局变量
static int i  = 2;
/**
 *  当前字符串中只能在本文件中使用，并且只读，不能修改
 */
static NSString *const name = @"1234";
@implementation ViewController

/**
 
 static 作用：
 1. 修饰局部变量
    * 延长这个局部变量的声明周期，只要成员运行，局部变量就会一直存在
    * 局部变量只会分配一次内存，因为用static修饰的代码，只会在程序一启动就会执行，以后就不会在执行
 2. 修饰全局变量
    *只会修改全部变量的作用域，表示只能是当前文件内使用
 
 extern作用:
  1。声明一个全局变量，不能定义变量
  注意:extern 修饰的变量不能初始化
 
  使用场景:一般用于声明全局变量
 */

/**

static 和const 修饰全局变量
static 修饰全局变量，修改作用域，表示在当前
const 修饰变量，变量只读
静态全局只读变量


*/
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
