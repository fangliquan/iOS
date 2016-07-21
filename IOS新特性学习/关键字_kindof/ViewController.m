//
//  ViewController.m
//  关键字_kindof
//
//  Created by leo on 16/7/21.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"
#import "SonPerson.h"

@interface ViewController ()

@end

@implementation ViewController

/**
 *  __kindof ：表示当前类或者子类
    __kindof 书写格式：
    放在类型前面,表示修饰这个类型
    __kindof :在调用的时候，很清楚的知道返回类型
 */


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //id 1.不能在编译的时候检查真实类型，
    //   2.返回值，没有提示
    
    SonPerson *p = [[SonPerson alloc]init];
    [SonPerson personkindof];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
