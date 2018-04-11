//
//  KRVideoPlayerController.h
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

@import MediaPlayer;

@interface KRVideoPlayerController : MPMoviePlayerController

@property (nonatomic, copy)void(^dimissCompleteBlock)(void);
@property (nonatomic, assign) CGRect frame;

@property (nonatomic, copy) NSString *videoTitle;

@property (nonatomic, copy) NSString *videoDesc;

@property (nonatomic, copy) NSString *imageUrl;

@property(nonatomic, strong) NSArray *qualityArray;

@property (nonatomic, assign) double curTime;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)showInWindow;
- (void)dismiss;

- (void)progressSliderTouchBegan:(UISlider *)slider;
- (void)progressSliderTouchEnded:(UISlider *)slider;
- (void)progressSliderValueChanged:(UISlider *)slider;

- (void)stopDurationTimer;

@end