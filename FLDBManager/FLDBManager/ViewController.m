//
//  ViewController.m
//  FLDBManager
//
//  Created by microleo on 2017/12/5.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ViewController.h"
#import "DBManager+SystemInfo.h"
#import "DBManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[DBManager sharedInstance]saveCurrentVersion:BundleVersionString];
    [[DBManager sharedInstance]saveInformationItem:@"大家好，今天很开心" value:@"KEY"];
    
    LoginInfo *currentInfo = [[DBManager sharedInstance]loadTableFirstData:[LoginInfo class] Condition:@""];
    if (!currentInfo) {
        LoginInfo *loginInfo =[[LoginInfo alloc]init];
        loginInfo.userId = 124;
        loginInfo.isLogined = 1;
        loginInfo.phone = @"124";
        [[DBManager sharedInstance]saveData:loginInfo];
    }

    
    NSArray *informationArray = [[DBManager sharedInstance]loadTableData:[Informations class] Condition:@""];
    
    NSLog(@"---------informationArray%@",informationArray);
    
    NSLog(@"----------------version:%@",[[DBManager sharedInstance]getCurrentVersion]);
    
    UserInfoTemp *temp1 = [[UserInfoTemp alloc]init];
    temp1.userId = 1;
    temp1.userName = @"1";
    temp1.age = 16;
    
    [UserInfoTemp insertUserInfo:temp1];
    
    NSLog(@"1:--------------%@",[NSDate date]);
    NSMutableArray *userArray = [NSMutableArray array];
    
    for (int i =0; i <100000; i ++) {
        UserInfoTemp *temp = [[UserInfoTemp alloc]init];
        temp.userId = i;
        temp.userName = [NSString stringWithFormat:@"%d", i + 100];
        temp.age = 16 +i;
        [userArray addObject:temp];
    }
    [UserInfoTemp insertUserInfos:userArray];
    NSLog(@"2:--------------%@",[NSDate date]);

    
    NSArray *userArray1 = [UserInfoTemp getAllUserInfoWithCondition:@""];
    
    NSLog(@"userArray1:--------------%ld",userArray1.count);
    
    NSArray *userArray2 = [UserInfoTemp getAllUserInfoWithCondition:@"where age < 80"];
    NSLog(@"userArray2:--------------%ld",userArray2.count);
    
    NSLog(@"temp1:--------------%@",temp1.userName);
    temp1.userId = 101;
    [UserInfoTemp udateUserInfo:temp1];
    
    UserInfoTemp *uptemp = [UserInfoTemp getUserInfoWithUserId:temp1.userId];
    NSLog(@"temp1:--------------%@",uptemp.userName);
    
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
