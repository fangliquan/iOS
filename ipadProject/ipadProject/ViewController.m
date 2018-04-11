//
//  ViewController.m
//  ipadProject
//
//  Created by microleo on 2017/11/17.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"菜单" style:UIBarButtonItemStylePlain target:self action:@selector(menuItemClick)];
    // Do any additional setup after loading the view, typically from a nib.
}

-(void)menuItemClick{
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
