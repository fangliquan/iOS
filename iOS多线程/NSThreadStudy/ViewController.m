//
//  ViewController.m
//  NSThreadStudy
//
//  Created by leo on 16/7/28.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    /**
     alloc init 
     需要手动开启线程，可以拿到线程对象进行详细设置
     //创建线程
     第一个参数 目标对象
     第二个参数 选择器，线程启动要调用哪个方法
     第三个参数 前面方法要接收的参数（最多只能接收一个参数，没有则传nil)
     */
    NSThread *thread = [[NSThread alloc]initWithTarget:self selector:@selector(run) object:nil];
    [thread start];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    NSLog(@"%@",[NSThread currentThread]);
    
    //ch
}
@end
