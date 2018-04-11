//
//  ViewController.m
//  FLExcelDemo
//
//  Created by microleo on 2017/12/1.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    NSMutableArray *arrays = [NSMutableArray arrayWithObjects:@"1",@"2" ,@"2" ,@"3" ,@"3" ,@"4" ,@"4" ,@"5",@"5" ,@"6" ,@"6",nil];
    
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    for (NSString *obj in arrays) {
        if (obj&& ![dic objectForKey:obj]) {
            [dic setObject:obj forKey:obj];
        }
    }
    NSLog(@"------%@",dic);
    
    NSMutableSet *set = [NSMutableSet setWithArray:arrays];
    
    NSLog(@"------%@",set);
    
    
    NSMutableArray *carr = [NSMutableArray array];
    for (NSString *str in arrays) {
        if (![carr containsObject:str]) {
            [carr addObject:str];
        }
    }
    
    NSLog(@"------%@",carr);
    
    NSMutableArray *carrUnion = [NSMutableArray array];
    
    arrays = [arrays valueForKeyPath:@"@distinctUnionOfObjects.self"];
    
    NSLog(@"----------%@",arrays);
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
