//
//  ViewController.m
//  Runtime消息机制
//
//  Created by leo on 16/7/21.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
//使用运行时第一步，导入<objc/message.h>

//第二步设置 BuildSetting  msg 设置为NO
#import <objc/message.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    Person *p = [[Person alloc]init];
    
    
    
    
    
    //吃东西
   // [p eat];
    //OC :运行时机制，消息机制是运行时截止最重要的机制
    //消息机制：任何方法调用，本质都是发消息。
    
    //SEL:方法编号，根据方法编号就可以找到对应的方法实现
    //[p performSelector:@selector(eat)];
    
    //运行时，发送消息，谁做事情就那谁
    //xcode5 之后苹果不建议使用底层方法
    //xcode5 之后使用运行时。
    
    //p发消息
    //objc_msgSend(p, @selector(eat));
    //objc_msgSend(p, @selector(run:),10);
    //类名方法 本质类名转换成类对象
    // [Person eat];
    
    //获取类对象
    Class personClass = [Person class];
    //[personClass  performSelector:@selector(eat)];
    
    //运行时
    
    objc_msgSend(personClass, @selector(eat));
    
    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
























@end
