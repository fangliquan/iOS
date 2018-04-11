//
//  KRVideoPlayerController.m
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import "KRVideoPlayerController.h"
#import "KRVideoPlayerControlView.h"
#import "AndyTabBarController.h"
#import "MBProgressHUD+MJ.h"

static const CGFloat kVideoPlayerControllerAnimationTimeinterval = 0.0f;

@interface KRVideoPlayerController ()

@property (nonatomic, strong) KRVideoPlayerControlView *videoControl;
@property (nonatomic, strong) UIView *movieBackgroundView;
@property (nonatomic, assign) BOOL isFullscreenMode;
@property (nonatomic, assign) CGRect originFrame;
@property (nonatomic, strong) NSTimer *durationTimer;

@property (nonatomic, assign) BOOL isProgressSliderTouchDown;

@end

@implementation KRVideoPlayerController

- (void)dealloc
{
    [self cancelObserver];
    AndyLog(@"播放器已销毁");
}

- (instancetype)initWithFrame:(CGRect)frame
{
//    AndyTabBarViewController *tabVC = (AndyTabBarViewController *)[UIApplication sharedApplication].windows.firstObject.rootViewController;
//    [tabVC roateLandscapeLeft];
//    
//    NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//    [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    
    self = [super init];
    if (self) {
        self.view.frame = frame;
        self.view.backgroundColor = [UIColor clearColor];
        self.controlStyle = MPMovieControlStyleNone;
        [self.view addSubview:self.videoControl];
        self.videoControl.frame = self.view.bounds;
        self.videoControl.krVideoPlayer = self;
        [self cancelObserver];
        [self configObserver];
        [self configControlAction];
        
        XAppDelegate.isCanCapture = YES;
    }
    return self;
}

- (void)setQualityArray:(NSArray *)qualityArray
{
    _qualityArray = qualityArray;
    [self.videoControl combineQualityView:qualityArray];
}

#pragma mark - Override Method

- (void)setContentURL:(NSURL *)contentURL
{
    [self stop];
    self.videoControl.playButton.enabled = NO;
    self.videoControl.pauseButton.enabled = NO;
    self.videoControl.progressSlider.value = 0.f;
    self.videoControl.progressSlider.enabled = NO;
    [self setTimeLabelValues:0.f totalTime:0.f];
    [super setContentURL:contentURL];
    [self play];
}

- (void)setVideoTitle:(NSString *)videoTitle
{
    _videoTitle = videoTitle;
    self.videoControl.titleLabel.text = videoTitle;
    
    [self fullScreenButtonClick];
}

#pragma mark - Publick Method

- (void)showInWindow
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        keyWindow = [[[UIApplication sharedApplication] windows] firstObject];
    }
    
    //修复UIAlertView弹出导致UIWindows添加控件位置错误的问题
    if ([keyWindow isKindOfClass:NSClassFromString(@"UIApplicationRotationFollowingWindow")])
    {
        unsigned long windowCounts = [UIApplication sharedApplication].windows.count;
        if (windowCounts >= 2)
        {
            keyWindow = [UIApplication sharedApplication].windows[windowCounts - 2];
        }
    }
    
    [keyWindow addSubview:self.view];
    self.view.alpha = 0.0;
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
        self.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)dismiss
{
    self.videoControl.krVideoPlayer = nil;

    AndyTabBarController *tabVC = (AndyTabBarController *)[UIApplication sharedApplication].windows.firstObject.rootViewController;
    [tabVC roatePortrait];
    
    [self stopDurationTimer];
    [self stop];
    self.contentURL = nil;
    
    [UIView animateWithDuration:kVideoPlayerControllerAnimationTimeinterval animations:^{
        self.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        if (self.dimissCompleteBlock) {
            self.dimissCompleteBlock();
        }
    }];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

#pragma mark - Private Method

- (void)configObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerPlaybackStateDidChangeNotification) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerLoadStateDidChangeNotification) name:MPMoviePlayerLoadStateDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMoviePlayerReadyForDisplayDidChangeNotification) name:MPMoviePlayerReadyForDisplayDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onMPMovieDurationAvailableNotification) name:MPMovieDurationAvailableNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(captureFinished:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
}

- (void)cancelObserver
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configControlAction
{
    [self.videoControl.playButton addTarget:self action:@selector(playButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.pauseButton addTarget:self action:@selector(pauseButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.closeButton addTarget:self action:@selector(closeButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.fullScreenButton addTarget:self action:@selector(fullScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.shrinkScreenButton addTarget:self action:@selector(shrinkScreenButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchBegan:) forControlEvents:UIControlEventTouchDown];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpInside];
    [self.videoControl.progressSlider addTarget:self action:@selector(progressSliderTouchEnded:) forControlEvents:UIControlEventTouchUpOutside];
    [self setProgressSliderMaxMinValues];
    [self monitorVideoPlayback];
    
    //我添加的
    [self.videoControl.indicatorView startAnimating];
}

- (void)captureFinished:(NSNotification *)notification
{
    if (XAppDelegate.isCanCapture)
    {
        XAppDelegate.isCanCapture = NO;
        UIImage *image = notification.userInfo[MPMoviePlayerThumbnailImageKey];
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        NSLog(@"截屏");
    }
    else
    {
        AndyLog(@"不可截屏状态");
    }
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    XAppDelegate.isCanCapture = YES;
    //已暂时取消此方法的编写
}

- (void)onMPMoviePlayerPlaybackStateDidChangeNotification
{
    if (self.playbackState == MPMoviePlaybackStatePlaying) {
        self.videoControl.playButton.enabled = YES;
        self.videoControl.pauseButton.enabled = YES;
        self.videoControl.progressSlider.enabled = YES;
        self.videoControl.cameraButton.enabled = YES;
        //[self setCurrentPlaybackTime:self.curTime];
        self.videoControl.pauseButton.hidden = NO;
        self.videoControl.playButton.hidden = YES;
        [self startDurationTimer];
        [self.videoControl.indicatorView stopAnimating];
        [self.videoControl autoFadeOutControlBar];

    } else {
        self.videoControl.pauseButton.hidden = YES;
        self.videoControl.playButton.hidden = NO;
        [self stopDurationTimer];
        [self.videoControl animateShow];
        if (self.playbackState == MPMoviePlaybackStateStopped) {
            [self.videoControl animateShow];
        }
    }
}

- (void)onMPMoviePlayerLoadStateDidChangeNotification
{
    AndyLog(@"loadState: %lu", (unsigned long)self.loadState);
    if (self.loadState & MPMovieLoadStateStalled) {
        [self.videoControl.indicatorView startAnimating];
    } else if (self.loadState & MPMovieLoadStatePlaythroughOK) {
         [self.videoControl.indicatorView stopAnimating];
    }
}

//- (void)onMPMoviePlayerLoadStateDidChangeNotification
//{
////    if (self.loadState & (MPMoviePlaybackStateSeekingForward | MPMoviePlaybackStateSeekingBackward)) {
////        [self.videoControl.indicatorView startAnimating];
////    }
//    
//    if (self.loadState)
//    {
//        if (MPMovieLoadStatePlayable)
//        {
//            AndyLog(@"MPMovieLoadStatePlayable");
//        }
//        else if (MPMovieLoadStatePlaythroughOK)
//        {
//            AndyLog(@"MPMovieLoadStatePlaythroughOK");
//        }
//        else if (MPMovieLoadStateUnknown)
//        {
//            AndyLog(@"MPMovieLoadStateUnknown");
//        }
//        else if (MPMovieLoadStateStalled)
//        {
//            AndyLog(@"MPMovieLoadStateStalled");
//        }
//    }
//    
////    if (self.loadState & MPMovieLoadStatePlayable) {
////        [self.videoControl.indicatorView startAnimating];
////    }
//}

- (void)onMPMoviePlayerReadyForDisplayDidChangeNotification
{
    
}

- (void)onMPMovieDurationAvailableNotification
{
    [self setProgressSliderMaxMinValues];
}

- (void)playButtonClick
{
    [self play];
    self.videoControl.playButton.hidden = YES;
    self.videoControl.pauseButton.hidden = NO;
}

- (void)pauseButtonClick
{
    [self pause];
    self.videoControl.playButton.hidden = NO;
    self.videoControl.pauseButton.hidden = YES; 
}

- (void)closeButtonClick
{
    [self dismiss];
}


- (void)fullScreenButtonClick
{
    if (self.isFullscreenMode) {
        return;
    }
    
    self.originFrame = self.view.frame;
//    CGFloat height = [[UIScreen mainScreen] bounds].size.width;
//    CGFloat width = [[UIScreen mainScreen] bounds].size.height;
//    CGRect frame = CGRectMake((height - width) / 2, (width - height) / 2, width, height);
    CGRect frame = CGRectMake(0, 0, AndyMainScreenSize.width, AndyMainScreenSize.height);
    [UIView animateWithDuration:0.0f animations:^{
        self.frame = frame;
        //[self.view setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        
//        NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
//        [[UIDevice currentDevice] setValue:value forKey:@"orientation"];
        
    } completion:^(BOOL finished) {
        self.isFullscreenMode = YES;
        self.videoControl.fullScreenButton.hidden = YES;
        self.videoControl.shrinkScreenButton.hidden = YES;
    }];
}

- (void)shrinkScreenButtonClick
{
    if (!self.isFullscreenMode) {
        return;
    }
    [UIView animateWithDuration:0.2f animations:^{
        [self.view setTransform:CGAffineTransformIdentity];
        self.frame = self.originFrame;
    } completion:^(BOOL finished) {
        self.isFullscreenMode = NO;
        self.videoControl.fullScreenButton.hidden = NO;
        self.videoControl.shrinkScreenButton.hidden = YES;
    }];
}

- (void)setProgressSliderMaxMinValues {
    CGFloat duration = self.duration;
    self.videoControl.progressSlider.minimumValue = 0.f;
    self.videoControl.progressSlider.maximumValue = duration;
}

- (void)progressSliderTouchBegan:(UISlider *)slider {
    [self pause];
    self.isProgressSliderTouchDown = YES;
    [self.videoControl cancelAutoFadeOutControlBar];
}

- (void)progressSliderTouchEnded:(UISlider *)slider {
    self.isProgressSliderTouchDown = NO;
    [self setCurrentPlaybackTime:floor(slider.value)];
    self.curTime = floor(slider.value);
    [self play];
    [self.videoControl autoFadeOutControlBar];
}

- (void)progressSliderValueChanged:(UISlider *)slider {
    double currentTime = floor(slider.value);
    double totalTime = floor(self.duration);
    self.curTime = currentTime;
    [self setTimeLabelValues:currentTime totalTime:totalTime];
}

- (void)monitorVideoPlayback
{
    double currentTime = floor(self.currentPlaybackTime);
    double totalTime = floor(self.duration);
    
//    if (self.isProgressSliderTouchDown == NO)
//    {
        [self setTimeLabelValues:currentTime totalTime:totalTime];
        self.videoControl.progressSlider.value = currentTime;
    //}
    
    self.curTime = currentTime;
    
    if (totalTime > 0 && currentTime == totalTime)
    {
        AndyLog(@"播放结束");
        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        BOOL isVideoAutoBack = [defaults boolForKey:SettingIsVideoAutoBack];
//        
//        if (isVideoAutoBack)
//        {
            [self dismiss];
        //}
    }
}

- (void)setTimeLabelValues:(double)currentTime totalTime:(double)totalTime {
    double minutesElapsed = floor(currentTime / 60.0);
    double secondsElapsed = fmod(currentTime, 60.0);
    if (minutesElapsed < 0.0)
    {
        minutesElapsed = 0.0;
    }
    if (secondsElapsed == 0.0)
    {
        secondsElapsed = 0.0;
    }
    NSString *timeElapsedString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesElapsed, secondsElapsed];
    
    double minutesRemaining = floor(totalTime / 60.0);;
    double secondsRemaining = floor(fmod(totalTime, 60.0));;
    NSString *timeRmainingString = [NSString stringWithFormat:@"%02.0f:%02.0f", minutesRemaining, secondsRemaining];
    
    self.videoControl.timeLabel.text = [NSString stringWithFormat:@"%@ / %@",timeElapsedString,timeRmainingString];
    
    self.videoControl.seekTimeLabel.text = self.videoControl.timeLabel.text;
}

- (void)startDurationTimer
{
    self.durationTimer = [NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(monitorVideoPlayback) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSDefaultRunLoopMode];
}

- (void)stopDurationTimer
{
    [self.durationTimer invalidate];
}

- (void)fadeDismissControl
{
    [self.videoControl animateHide];
}

#pragma mark - Property

- (KRVideoPlayerControlView *)videoControl
{
    if (!_videoControl) {
        _videoControl = [[KRVideoPlayerControlView alloc] init];
    }
    return _videoControl;
}

- (UIView *)movieBackgroundView
{
    if (!_movieBackgroundView) {
        _movieBackgroundView = [UIView new];
        _movieBackgroundView.alpha = 0.0;
        _movieBackgroundView.backgroundColor = [UIColor blackColor];
    }
    return _movieBackgroundView;
}

- (void)setFrame:(CGRect)frame
{
    [self.view setFrame:frame];
    [self.videoControl setFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
    [self.videoControl setNeedsLayout];
    [self.videoControl layoutIfNeeded];
}

@end
