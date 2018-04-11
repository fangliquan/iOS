//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)
#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view shouldAutoRoateAngle:(CGFloat)angle
{
    if (view == nil) view = [[UIApplication sharedApplication].windows lastObject];
    
    if([view isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")])
    {
        unsigned long windowCounts = [UIApplication sharedApplication].windows.count;
        if (windowCounts >= 2)
        {
            view = [UIApplication sharedApplication].windows[1];
        }
    }
    
    [view setTransform:CGAffineTransformMakeRotation(angle)];
    
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:0.7];
}

#pragma mark 显示错误信息

+ (void)showError:(NSString *)error toView:(UIView *)view
{
    [self show:error icon:@"error.png" view:view shouldAutoRoateAngle:0];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view shouldAutoRoateAngle:0];
}

+ (void)showError:(NSString *)error toView:(UIView *)view shouldAutoRoateAngle:(CGFloat)angle{
    [self show:error icon:@"error.png" view:view shouldAutoRoateAngle:angle];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view shouldAutoRoateAngle:(CGFloat)angle
{
    [self show:success icon:@"success.png" view:view shouldAutoRoateAngle:angle];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil)
    {
        view = [[UIApplication sharedApplication].windows lastObject];
    }
    
    if([view isKindOfClass:NSClassFromString(@"UIRemoteKeyboardWindow")])
    {
        unsigned long windowCounts = [UIApplication sharedApplication].windows.count;
        if (windowCounts >= 2)
        {
            view = [UIApplication sharedApplication].windows[1];
        }
    }
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil shouldAutoRoateAngle:0];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil shouldAutoRoateAngle:0];
}

+ (void)showSuccess:(NSString *)success shouldAutoRoateAngle:(CGFloat)angle
{
    [self showSuccess:success toView:nil shouldAutoRoateAngle:angle];
}

+ (void)showError:(NSString *)error shouldAutoRoateAngle:(CGFloat)angle
{
    [self showError:error toView:nil shouldAutoRoateAngle:angle];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}
@end
