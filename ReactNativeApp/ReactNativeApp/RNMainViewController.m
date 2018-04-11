//
//  RNMainViewController.m
//  ReactNativeApp
//
//  Created by microleo on 2017/12/20.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "RNMainViewController.h"
#import "RNView.h"

@interface RNMainViewController ()

@end

@implementation RNMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"RN模块首页";
    
    RNView * rnView = [[RNView alloc] initWithFrame:self.view.bounds];
    self.view = rnView;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退出" style:UIBarButtonItemStylePlain target:self action:@selector(exitVc)];
}



-(void)exitVc{
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    
}
@end




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

