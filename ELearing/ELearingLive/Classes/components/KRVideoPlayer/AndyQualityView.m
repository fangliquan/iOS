//
//  AndyQualityView.m
//  EyeSight
//
//  Created by 李扬 on 15/12/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import "AndyQualityView.h"
#import "UIImage+Andy.h"

@interface AndyQualityView ()

@property (nonatomic, strong) NSMutableArray *qualityButtonsM;

@property (nonatomic, strong) NSArray *quarlityArray;

@property (nonatomic, weak) UIButton *selectedButton;

@end

@implementation AndyQualityView

- (NSMutableArray *)qualityButtonsM
{
    if (_qualityButtonsM == nil)
    {
        _qualityButtonsM = [NSMutableArray array];
    }
    return _qualityButtonsM;
}

- (void)setupQualityButtonWithArray:(NSArray *)qualityArray
{
    self.quarlityArray = qualityArray;
    
    for (int i = 0; i < qualityArray.count; i++)
    {
        UIButton *qualityButton = [[UIButton alloc] init];
        
        NSDictionary *qualityDic = (NSDictionary *)qualityArray[i];
        NSString *keyStr = (NSString *)[qualityDic allKeys][0];
        [qualityButton setTitle:keyStr forState:UIControlStateNormal];
        
        qualityButton.tag = i;
        
        [qualityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [qualityButton setBackgroundImage:[UIImage createImageWithColor:AndyColor(80, 80, 80, 0.3)] forState:UIControlStateNormal];
        [qualityButton setTitleColor:AndyColor(170, 170, 170, 1.0) forState:UIControlStateHighlighted];
        [qualityButton setTitleColor:AndyColor(69, 142, 249, 1.0) forState:UIControlStateSelected];
        [qualityButton setBackgroundImage:[UIImage createImageWithColor:[UIColor clearColor]] forState:UIControlStateSelected];
        [qualityButton setTitleColor:AndyColor(170, 170, 170, 1.0) forState:UIControlStateDisabled];
        
        qualityButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [qualityButton addTarget:self action:@selector(qualityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.qualityButtonsM addObject:qualityButton];
        
        [self addSubview:qualityButton];
        
        if (self.qualityButtonsM.count == 1)
        {
            qualityButton.selected = YES;
            self.selectedButton = qualityButton;
        }
    }
}

- (void)qualityButtonClick:(UIButton *)button
{
    if ([self.delegate respondsToSelector:@selector(qualityView:didClickedButtonWithQualityLabel:andPlayUrl:from:to:)])
    {
        int index = (int)button.tag;
        NSDictionary *qualityDic = self.quarlityArray[index];
        NSString *keyStr = (NSString *)[qualityDic allKeys][0];
        NSString *playUrl = [qualityDic objectForKey:keyStr];
        
        NSArray *array = [playUrl componentsSeparatedByString:@"/"];
        NSString *videoName = (NSString *)[array lastObject];
        NSString *path = [AndyCommonFunction getVideoDownloadFilePathWithFileName:videoName];
        
        NSURL *playNSURL = nil;
        
        if([AndyCommonFunction checkFileIfExist:path])
        {
            playNSURL = [NSURL fileURLWithPath:path];
        }
        else
        {
            playNSURL = [NSURL URLWithString:[playUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        }
        
        [self.delegate qualityView:self didClickedButtonWithQualityLabel:keyStr andPlayUrl:playNSURL from:(int)self.selectedButton.tag to:(int)button.tag];
    }
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    AndyLog(@"%f, %f, %f, %f", self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
    CGFloat qualityButtonWith = self.frame.size.width;
    CGFloat qualityButtonHeight = 38;
    CGFloat qualityButtonX = 0;
    
    for (int i = 0; i < self.qualityButtonsM.count; i++)
    {
        CGFloat qualityButtonY = i * qualityButtonHeight;
        
        UIButton *qualityButton = (UIButton *)self.qualityButtonsM[i];
        
        qualityButton.frame = CGRectMake(qualityButtonX, qualityButtonY, qualityButtonWith, qualityButtonHeight);
    }
}














@end
