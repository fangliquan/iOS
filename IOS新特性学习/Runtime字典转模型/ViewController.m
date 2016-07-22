//
//  ViewController.m
//  Runtime字典转模型
//
//  Created by leo on 16/7/22.
//  Copyright © 2016年 leo. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+Property.h"
#import "Status.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"status.plist" ofType:nil];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePath];
    NSArray *dictArr = dict[@"statuses"];
    NSMutableArray *statusArray = [NSMutableArray array];
    for (NSDictionary *dictArray in dictArr) {
         Status *status = [Status statusWithDict:dictArray];
        [statusArray addObject:status];
    }
    
    
    NSLog(@"%@",statusArray);
    //[NSObject createPropertyCodeWithDict:dictArr[0]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
