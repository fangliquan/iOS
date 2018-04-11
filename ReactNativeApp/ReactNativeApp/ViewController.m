//
//  ViewController.m
//  ReactNativeApp
//
//  Created by microleo on 2017/12/20.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ViewController.h"
#import "RNMainViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)btnclick:(id)sender {
    RNMainViewController *vc = [[RNMainViewController alloc]init];
    UINavigationController *nvc = [[UINavigationController alloc]initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil]; 
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
