//
//  ELiveNavigationViewController.m
//  ELearingLive
//
//  Created by microleo on 2017/5/3.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ELiveNavigationViewController.h"

@interface ELiveNavigationViewController ()

@end

@implementation ELiveNavigationViewController

+ (void)initialize
{
    [self setupNavBarTheme];
    [self setupBarButtonItemTheme];
    
    
}

+ (void)setupBarButtonItemTheme
{
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    
    
    //NSMutableDictionary *textDictionaryM = [NSMutableDictionary dictionary];
    //        textDictionaryM[UITextAttributeTextColor] = [UIColor whiteColor];
    //        textDictionaryM[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    //textDictionaryM[NSFontAttributeName] = [UIFont systemFontOfSize:14.5];
    //[item setTitleTextAttributes:textDictionaryM forState:UIControlStateNormal];
    //        [item setTitleTextAttributes:textDictionaryM forState:UIControlStateHighlighted];
    
    //        NSMutableDictionary *disableTextDictionaryM = [NSMutableDictionary dictionary];
    //        disableTextDictionaryM[UITextAttributeTextColor] = [UIColor lightGrayColor];
    //        [item setTitleTextAttributes:disableTextDictionaryM forState:UIControlStateDisabled];
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
//}

//- (BOOL)shouldAutorotate
//{
//    return NO;
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return UIInterfaceOrientationMaskPortrait;
//}

//- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
//    return [self.topViewController supportedInterfaceOrientations];
//}
//
//- (BOOL)shouldAutorotate {
//    return self.topViewController.shouldAutorotate;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
//    return [self.topViewController shouldAutorotateToInterfaceOrientation:interfaceOrientation];
//}

+ (void)setupNavBarTheme
{
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    NSMutableDictionary *textDictionaryM = [NSMutableDictionary dictionary];
    textDictionaryM[NSForegroundColorAttributeName] = EL_COLOR_Segment_Yellow;
    //textDictionaryM[UITextAttributeTextShadowOffset] = [NSValue valueWithUIOffset:UIOffsetZero];
    //textDictionaryM[UITextAttributeFont] = [UIFont boldSystemFontOfSize:19];
    [navBar setTitleTextAttributes:textDictionaryM];
    
    //[navBar setBarTintColor:AndyNavigationBarTintColor];
    [navBar setTintColor:[UIColor blackColor]];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllers.count > 0)
    {
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
    
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
