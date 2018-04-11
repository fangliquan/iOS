//
//  ELiveTabBarViewController.m
//  ELearingLive
//
//  Created by microleo on 2017/5/3.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "ELiveTabBarViewController.h"
#import "ELiveNewsMainViewController.h"
#import "ELiveMineFocusViewController.h"
#import "ELiveCastMainViewController.h"
#import "ELiveMainClassesViewController.h"
#import "ELiveSettingMainViewController.h"

#import "ELiveNavigationViewController.h"
@interface ELiveTabBarViewController ()


@property(nonatomic) UIInterfaceOrientationMask orietation;

@end

@implementation ELiveTabBarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.tabBar.tintColor = EL_COLOR_Segment_Yellow;
    
    [self setupAllChildViewControllers];
}

-(void)roateLandscapeLeft
{
    NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationLandscapeLeft];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.orietation = UIInterfaceOrientationMaskLandscapeLeft;
}

-(void)roatePortrait
{
    NSNumber *value = [NSNumber numberWithInt:UIDeviceOrientationPortrait];
    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self.orietation = UIInterfaceOrientationMaskPortrait;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self roatePortrait];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return self.orietation;
}

- (void)setupAllChildViewControllers
{
    ELiveNewsMainViewController *news = [[ELiveNewsMainViewController alloc] init];
    [self setupChildViewController:news title:@"新闻" imageName:@"tabbar_news" selectedImageName:nil];
    //XAppDelegate.news = news;
    
    ELiveMineFocusViewController *focus = [[ELiveMineFocusViewController alloc] init];
    [self setupChildViewController:focus title:@"关注" imageName:@"tabbar_pics" selectedImageName:nil];
   // XAppDelegate.focus =focus;
    
    ELiveCastMainViewController *picture = [[ELiveCastMainViewController alloc] init];
    [self setupChildViewController:picture title:@"直播" imageName:@"tabbar_video" selectedImageName:nil];
    //XAppDelegate.picture = picture;
    
    ELiveMainClassesViewController *about = [[ELiveMainClassesViewController alloc] init];
    [self setupChildViewController:about title:@"专家" imageName:@"tabbar_pics" selectedImageName:nil];
    
    ELiveSettingMainViewController *setting = [[ELiveSettingMainViewController alloc] init];
    [self setupChildViewController:setting title:@"我" imageName:@"tabbar_about" selectedImageName:nil];
}


- (void)setupChildViewController:(UIViewController *)childVc title:(NSString *)title imageName:(NSString *)imageName selectedImageName:(NSString *)selectedImageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    
    if (selectedImageName != nil)
    {
        UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
        
        childVc.tabBarItem.selectedImage = selectedImage;
    }
    
    childVc.tabBarItem.image = image;
    
    childVc.title = title;
    
    ELiveNavigationViewController *nav = [[ELiveNavigationViewController alloc] initWithRootViewController:childVc];
    [self addChildViewController:nav];
}



@end
