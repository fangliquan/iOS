//
//  ViewController.m
//  runtime_demo
//
//  Created by microleo on 2018/4/13.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}
//队列组/依赖
-(void) gdcGroup{
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("microleo.com", DISPATCH_QUEUE_PRIORITY_DEFAULT);
    dispatch_group_async(group, queue, ^{
        for (int i =0; i <400; i ++) {
            if (i ==200) {
                NSLog(@"1111111");
            }
        }
    });
    dispatch_async(queue, ^{
        NSLog(@"22222222");
    });
    dispatch_async(queue, ^{
        NSLog(@"33333333");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"4444444");
    });
    dispatch_group_async(group, queue, ^{
        NSLog(@"5555555");
    });
    dispatch_group_notify(group, queue, ^{
        NSLog(@"done");
    });
}
-(void)queueGoup {
    //创建操作队列
    NSOperationQueue *operationQueue = [[NSOperationQueue alloc]init];
    NSBlockOperation *lastBlockQueue =[NSBlockOperation blockOperationWithBlock:^{
        sleep(1);
        NSLog(@"最后的任务");
    }];
    for (int i =0; i <4; i++) {
        //创建多线程操作
        NSBlockOperation *blockOperation =[NSBlockOperation blockOperationWithBlock:^{
            sleep(i);
            NSLog(@"第%d个任务",i);
        }];
        //设置依赖操作为最后一个操作
        [blockOperation addDependency:lastBlockQueue];
        [operationQueue addOperation:blockOperation];
    }
    [operationQueue addOperation:lastBlockQueue];
}

-(void)gdctest{
    
    dispatch_queue_t queue =dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        //异步任务
        NSLog(@"异步执行任务....");
        dispatch_async(dispatch_get_main_queue(), ^{
            //回归主线程
            NSLog(@"回归主线程....");
        });
        
    });
}
-(void)operationTest{
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
    //切换到子线程
    [queue addOperationWithBlock:^{
        
        NSLog(@"子线程-----");
        [[NSOperationQueue mainQueue]addOperationWithBlock:^{
            //切换到主线程
            NSLog(@"主线程-----");
        }];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
