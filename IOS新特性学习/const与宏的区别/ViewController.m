//
//  ViewController.m
//  const与宏的区别
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end
/**
 * 宏常见用法:
   1 常用的字符串抽成宏
   2 常用的代码抽成宏
 */

/**
 *  const:常量
    const:当有字符串常量的时候，苹果推荐我们使用const
    const与与宏的区别
    1.编译时刻:宏预编译，const：编译shike
    2.编译检查:宏：不会检查错误 const:会检查错误
    3.宏的好处:可以定义代码
    4.宏的坏处:编译时间过长，因此常用的字符串通常使用const修饰
 */


@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
