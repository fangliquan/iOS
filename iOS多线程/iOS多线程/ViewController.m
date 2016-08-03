//
//  ViewController.m
//  iOS多线程
//
//  Created by leo on 16/7/28.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"
#import <pthread.h>
@interface ViewController ()

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
- (IBAction)btnClick:(id)sender {
    
    NSLog(@"%@",[NSThread mainThread]);
    //创建线程
    pthread_t thread;
    /*
     第一个参数:线程对象
     第二个参数:线程属性
     第三个参数:void *(*)(void *) 指向函数的指针
     第四个参数:函数的参数
     */
    pthread_create(&thread, NULL, run, NULL);
    
    pthread_t thread1;
    pthread_create(&thread1, NULL, run, NULL);
}
//void *(*)(void *)
void *run(void *param)
{
    //    NSLog(@"---%@-",[NSThread currentThread]);
    for (NSInteger i =0 ; i<10000; i++) {
        NSLog(@"%zd--%@-",i,[NSThread currentThread]);
    }
    return NULL;
}
@end
