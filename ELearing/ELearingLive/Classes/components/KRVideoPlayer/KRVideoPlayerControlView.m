//
//  KRVideoPlayerControlView.m
//  KRKit
//
//  Created by aidenluo on 5/23/15.
//  Copyright (c) 2015 36kr. All rights reserved.
//

#import "KRVideoPlayerControlView.h"
#import "UIImage+Andy.h"
#import "AndyQualityView.h"
#import "MBProgressHUD+MJ.h"

#define BrightTitleLabelFont [UIFont fontWithName:@"Helvetica-Bold" size:kVideoControlBrightLabelFontSize]
#define SeekTimeLabelFont [UIFont fontWithName:@"Helvetica-Bold" size:kVideoControlSeekLabelFontSize]

#define iOSBlurAdjustAlpha iOS8AndLater ? 0.9 : 1.0
#define iOSBlurAdjustColor iOS8AndLater ? AndyColor(25, 25, 25, 1.0) : AndyColor(75, 75, 75, 1.0)

CGFloat const gestureMinimumTranslation = 0.0;

typedef enum :NSInteger {
    kCameraMoveDirectionNone,
    kCameraMoveDirectionUp,
    kCameraMoveDirectionDown,
    kCameraMoveDirectionRight,
    kCameraMoveDirectionLeft
} CameraMoveDirection;

static const CGFloat kVideoControlTopBarHeight = 53.0;
//static const CGFloat kVideoControlTopBarHeight = 40.0;
static const CGFloat kVideoControlBottomBarHeight = 40.0;
static const CGFloat kVideoControlAnimationTimeinterval = 0.2;
static const CGFloat kVideoControlTimeLabelFontSize = 10.0;
static const CGFloat kVideoControlTitleLabelFontSize = 17.0;
static const CGFloat kVideoControlBarAutoFadeOutTimeinterval = 5.0;


static const CGFloat kVideoControlBrightUIViewWith = 153.0;
static const CGFloat kVideoControlBrightUIViewHeight = 153.0;
static const CGFloat kVideoControlBrightLabelFontSize = 15.5;
static const CGFloat kVideoControlSeekLabelFontSize = 18.5;
static const CGFloat kVideoControlBrightUIViewSliderWith = 130.0;
static const CGFloat kVideoControlBrightUIViewSliderHeight = 7.0;
static const CGFloat kVideoControlBrightUIViewSliderResponseInterval = 0.5;
static const CGFloat kVideoBrightUIViewAutoFadeOutTimeinterval = 1.0;
static const CGFloat kVideoBrightUIViewAnimationTimeinterval = 0.4;
static const CGFloat kVideoBrightUIViewSliderTotalColumns = 16;

static const CGFloat kVideoControlSeekUIViewWith = 145.0;
static const CGFloat kVideoControlSeekUIViewHeight = 85.0;
static const CGFloat kVideoSeekUIViewAnimationTimeinterval = 0.0;
static const CGFloat kVideoSeekUIViewAutoFadeOutTimeinterval = 0.0;
static const CGFloat kVideoSeekUIViewResponseInterval = 0.5;

static const CGFloat kVideoControlCamaraButtonWith = 25.0;
static const CGFloat kVideoControlCamaraButtonheight = 25.0;

@interface KRVideoPlayerControlView () <AndyQualityViewDelegate>
{
    CameraMoveDirection direction;
    BOOL isVerticalMoving;
    BOOL isHorizontalMoving;
}

@property (nonatomic, strong) UIView *topBar;
@property (nonatomic, strong) UIView *bottomBar;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *pauseButton;
@property (nonatomic, strong) UIButton *fullScreenButton;
@property (nonatomic, strong) UIButton *shrinkScreenButton;
@property (nonatomic, strong) UISlider *progressSlider;
@property (nonatomic, strong) UIButton *closeButton;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, assign) BOOL isBarShowing;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) UIView *brightUIView;
@property (nonatomic, strong) UILabel *brightLabel;
@property (nonatomic, strong) UIImageView *brightImageView;
@property (nonatomic, strong) UIView *brightUIViewSlider;
@property (nonatomic, strong) UIToolbar *brightToolbar;
@property(nonatomic, strong) UIVisualEffectView *brightEffectView;
@property (nonatomic, strong) NSMutableArray *brightUIViewSliderValueM;
@property (nonatomic, assign) CGFloat brightSquareWith;
@property (nonatomic, assign) BOOL isBrightUIViewShowing;

@property (nonatomic, strong) UIView *seekUIView;
@property (nonatomic, strong) UIImageView *seekDirectionImageView;
@property (nonatomic, strong) UIToolbar *seekUIToolbar;
@property(nonatomic, strong) UIVisualEffectView *seekEffectView;
@property (nonatomic, assign) BOOL isSeekUIViewShowing;

@property(nonatomic, strong) UIButton *lockButton;

@property (nonatomic, strong) UIView *guestureUIView;

@property(nonatomic, strong) AndyQualityView *qualityView;
@property (nonatomic, assign) BOOL isQualityViewShowing;

@property(nonatomic, strong) MPMusicPlayerController *musicPlayer;

@property (nonatomic, assign) CGFloat currentPointMockX;
@property (nonatomic, assign) CGFloat currentPointMockY;

@property (nonatomic, assign) BOOL isTouchLeft;

@property (nonatomic, assign) BOOL isDoubleTapOn;

@property(nonatomic, strong) UITapGestureRecognizer *tapGesture;
@property(nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property(nonatomic, strong) UITapGestureRecognizer *doubleTapGesture;

@end

@implementation KRVideoPlayerControlView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.topBar];
        [self.topBar addSubview:self.closeButton];
        [self.topBar addSubview:self.titleLabel];
        [self.topBar addSubview:self.cameraButton];
        [self.topBar addSubview:self.qualityButton];
        [self addSubview:self.bottomBar];
        [self.bottomBar addSubview:self.playButton];
        [self.bottomBar addSubview:self.pauseButton];
        self.pauseButton.hidden = YES;
        [self.bottomBar addSubview:self.fullScreenButton];
        [self.bottomBar addSubview:self.shrinkScreenButton];
        self.shrinkScreenButton.hidden = YES;
        [self.bottomBar addSubview:self.progressSlider];
        [self.bottomBar addSubview:self.timeLabel];
        [self addSubview:self.indicatorView];
        
        [self addSubview:self.guestureUIView];
        
        [self addSubview:self.brightUIView];
        
        [self addSubview:self.seekUIView];
        
        [self addSubview:self.lockButton];
        
        self.tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
        [self.guestureUIView addGestureRecognizer:self.tapGesture];
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onPan:)];
        [self.guestureUIView addGestureRecognizer:self.panGesture];
        
        self.doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
        self.doubleTapGesture.numberOfTapsRequired = 2;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        self.isDoubleTapOn = [defaults boolForKey:SettingDoubleTapKey];
        if (self.isDoubleTapOn)
        {
            [self.guestureUIView addGestureRecognizer:self.doubleTapGesture];
        }
        else
        {
            [self.guestureUIView removeGestureRecognizer:self.doubleTapGesture];
        }
    }
    return self;
}

- (CameraMoveDirection)determineCameraDirectionIfNeeded:(CGPoint)translation
{
    if (direction != kCameraMoveDirectionNone)
        return direction;
    // determine if horizontal swipe only if you meet some minimum velocity
    if (fabs(translation.x) > gestureMinimumTranslation)
    {
        BOOL gestureHorizontal = NO;
        if (translation.y ==0.0)
            gestureHorizontal = YES;
        else
            gestureHorizontal = (fabs(translation.x / translation.y) >5.0);
        if (gestureHorizontal)
        {
            if (translation.x >0.0)
                return kCameraMoveDirectionRight;
            else
                return kCameraMoveDirectionLeft;
        }
    }
    // determine if vertical swipe only if you meet some minimum velocity
    else if (fabs(translation.y) > gestureMinimumTranslation)
    {
        BOOL gestureVertical = NO;
        if (translation.x ==0.0)
            gestureVertical = YES;
        else
            gestureVertical = (fabs(translation.y / translation.x) >5.0);
        if (gestureVertical)
        {
            if (translation.y >0.0)
                return kCameraMoveDirectionDown;
            else
                return kCameraMoveDirectionUp;
        }
    }
    return direction;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    // 当前触摸点
    CGPoint current = [touch locationInView:self];
    
    AndyLog(@"x:%f", current.x);
    
    if (current.x <= AndyMainScreenSize.width / 2.0f)
    {
        self.isTouchLeft = true;
    }
    else
    {
        self.isTouchLeft = false;
    }
}

- (void)onPan:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    if (recognizer.state ==UIGestureRecognizerStateBegan)
    {
        direction = kCameraMoveDirectionNone;
        self.currentPointMockX = 0.0;
        self.currentPointMockY = 0.0;
        
        isVerticalMoving = NO;
        isHorizontalMoving = NO;
        
        AndyLog(@"%f", translation.x);
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged && direction == kCameraMoveDirectionNone)
    {
        direction = [self determineCameraDirectionIfNeeded:translation];
        switch (direction) {
            case kCameraMoveDirectionUp:
            case kCameraMoveDirectionDown:
                isVerticalMoving = YES;
                isHorizontalMoving = NO;
                AndyLog(@"垂直移动");
                if (self.isTouchLeft)
                {
                    [self animateBrightUIViewShow];
                }
                break;
            case kCameraMoveDirectionLeft:
            case kCameraMoveDirectionRight:
                isVerticalMoving = NO;
                isHorizontalMoving = YES;
                AndyLog(@"水平移动");
                
                [self animateSeekUIViewShow];
                [self.krVideoPlayer progressSliderTouchBegan:self.progressSlider];
                
                break;
            default:
                break;
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded)
    {
        if (isHorizontalMoving)
        {
            [self.krVideoPlayer progressSliderTouchEnded:self.progressSlider];
            [self autoFadeOutSeekUIView];
        }
        else
        {
            if (isVerticalMoving)
            {
                if (self.isTouchLeft)
                {
                    [self autoFadeOutBrightUIView];
                }
            }
        }
    }
    
    if (isVerticalMoving)
    {
        if (self.isTouchLeft)
        {
            if (self.isBrightUIViewShowing == NO)
            {
                [self animateBrightUIViewShow];
                AndyLog(@"再次执行亮度提示显示");
            }
            
            //获取屏幕当前亮度，并赋值给可操控字段
            float Screenbrightness = [UIScreen mainScreen].brightness;
            
            if (translation.y > self.currentPointMockY)
            {
                AndyLog(@"向下移动");
                if (Screenbrightness - 0.03f >= -0.03f)
                {
                    Screenbrightness -= 0.03;
                    [UIScreen mainScreen].brightness = Screenbrightness;
                }
            }
            else
            {
                AndyLog(@"向上移动");
                
                if (Screenbrightness + 0.03f <= 1.03f)
                {
                    Screenbrightness += 0.03f;
                    [UIScreen mainScreen].brightness = Screenbrightness;
                }
            }
            
            if(fabs(self.currentPointMockY - translation.y) >= kVideoControlBrightUIViewSliderResponseInterval)
            {
                self.currentPointMockY = translation.y;
                [self controlBrightUIViewSliderSquare:Screenbrightness];
            }
        }
        else
        {
            CGFloat currentVolume = self.musicPlayer.volume;

            if (translation.y > self.currentPointMockY)
            {
                AndyLog(@"向下移动");
                if (currentVolume - 0.03f >= -0.03f)
                {
                    currentVolume -= 0.03;
                    self.musicPlayer.volume = currentVolume;
                }
            }
            else
            {
                AndyLog(@"向上移动");
                
                if (currentVolume + 0.03f <= 1.03f)
                {
                    currentVolume += 0.03f;
                    self.musicPlayer.volume = currentVolume;
                }
            }
            
            self.currentPointMockY = translation.y;

        }
        
    }else if (isHorizontalMoving)
    {
        CGFloat proSliderMaxValue = self.progressSlider.maximumValue;
        CGFloat proSliderMinValue = self.progressSlider.minimumValue;
        
        CGFloat stepProportion = self.krVideoPlayer.duration * 0.005f;
        //CGFloat stepProportion = 0.1f;
        
        //self.progressSlider.value = self.krVideoPlayer.curTime;
        
        CGFloat currentTime = self.progressSlider.value;
        
        BOOL isSeekingForward = NO;
        
        if (translation.x > self.currentPointMockX)
        {
            isSeekingForward = YES;
            AndyLog(@"向右移动");
            if (currentTime < proSliderMaxValue)
            {
                self.progressSlider.value += stepProportion;
            }
        }
        else
        {
            isSeekingForward = NO;
            AndyLog(@"向左移动");
            
            if (currentTime > proSliderMinValue)
            {
                self.progressSlider.value -= stepProportion;
            }
        }
        
        AndyLog(@"%f", fabs(self.currentPointMockX - translation.x));
        
        if (fabs(self.currentPointMockX - translation.x) > 0)
        {
            [self controlSeekDirectionImageView:isSeekingForward];
            
            self.currentPointMockX = translation.x;
        }
        
        [self.krVideoPlayer progressSliderValueChanged:self.progressSlider];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.topBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetMinY(self.bounds), CGRectGetWidth(self.bounds), kVideoControlTopBarHeight);
    self.closeButton.frame = CGRectMake(-8, CGRectGetMinX(self.topBar.bounds) + 8, CGRectGetWidth(self.closeButton.bounds), CGRectGetHeight(self.closeButton.bounds));
    //self.closeButton.frame = CGRectMake(0, CGRectGetMinX(self.topBar.bounds), CGRectGetWidth(self.closeButton.bounds), CGRectGetHeight(self.closeButton.bounds));
    self.cameraButton.center = CGPointMake(CGRectGetWidth(self.topBar.frame) - kVideoControlCamaraButtonWith, CGRectGetMidY(self.topBar.frame) + 8);
    self.qualityButton.center = CGPointMake(CGRectGetWidth(self.topBar.frame) - kVideoControlCamaraButtonWith - 45, CGRectGetMidY(self.topBar.frame) + 8);
    
    self.guestureUIView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    NSMutableDictionary *titleLabelMD = [NSMutableDictionary dictionary];
    titleLabelMD[NSFontAttributeName] = [UIFont systemFontOfSize:kVideoControlTitleLabelFontSize];
    //_titleLabel.text = @"本地视频哈哈哈哈哈哈";
    CGSize titleLabelSize = [_titleLabel.text sizeWithAttributes:titleLabelMD];
    
    CGFloat titleLabelX = CGRectGetMaxX(self.closeButton.frame);
    CGFloat titleLabelY = (self.topBar.frame.size.height - titleLabelSize.height) / 2;
    
    self.titleLabel.frame = CGRectMake(titleLabelX - 10, titleLabelY + 8, titleLabelSize.width, titleLabelSize.height);
    //self.titleLabel.frame = CGRectMake(titleLabelX, titleLabelY, titleLabelSize.width, titleLabelSize.height);
    AndyLog(@"%f, %f, %f, %f", self.titleLabel.frame.origin.x, self.titleLabel.frame.origin.y, self.titleLabel.frame.size.width, self.titleLabel.frame.size.height);
    self.bottomBar.frame = CGRectMake(CGRectGetMinX(self.bounds), CGRectGetHeight(self.bounds) - kVideoControlBottomBarHeight, CGRectGetWidth(self.bounds), kVideoControlBottomBarHeight);
    self.playButton.frame = CGRectMake(CGRectGetMinX(self.bottomBar.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.playButton.bounds)/2, CGRectGetWidth(self.playButton.bounds), CGRectGetHeight(self.playButton.bounds));
    self.pauseButton.frame = self.playButton.frame;
    self.fullScreenButton.frame = CGRectMake(CGRectGetWidth(self.bottomBar.bounds) - CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.fullScreenButton.bounds)/2, CGRectGetWidth(self.fullScreenButton.bounds), CGRectGetHeight(self.fullScreenButton.bounds));
    self.shrinkScreenButton.frame = self.fullScreenButton.frame;
    self.progressSlider.frame = CGRectMake(CGRectGetMaxX(self.playButton.frame), CGRectGetHeight(self.bottomBar.bounds)/2 - CGRectGetHeight(self.progressSlider.bounds)/2, self.bottomBar.frame.size.width - 15 - CGRectGetMaxX(self.playButton.frame), CGRectGetHeight(self.progressSlider.bounds));
    self.timeLabel.frame = CGRectMake(CGRectGetMidX(self.progressSlider.frame), CGRectGetHeight(self.bottomBar.bounds) - CGRectGetHeight(self.timeLabel.bounds) - 2.0, CGRectGetWidth(self.progressSlider.bounds)/2, CGRectGetHeight(self.timeLabel.bounds));
    self.indicatorView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    
    
    self.brightUIView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    if (iOS8AndLater)
    {
        self.brightEffectView.center = CGPointMake(CGRectGetMidX(self.brightUIView.bounds), CGRectGetMidY(self.brightUIView.bounds));
    }
    else
    {
        self.brightToolbar.center = CGPointMake(CGRectGetMidX(self.brightUIView.bounds), CGRectGetMidY(self.brightUIView.bounds));
    }
    
    self.brightLabel.text = @"亮度";
    NSMutableDictionary *brightLabelMD = [NSMutableDictionary dictionary];
    brightLabelMD[NSFontAttributeName] = BrightTitleLabelFont;
    CGSize brightLabelSize = [self.brightLabel.text sizeWithAttributes:brightLabelMD];
    CGFloat brightLabelX = (self.brightUIView.bounds.size.width - brightLabelSize.width) / 2;
    CGFloat brightLabelY = 10.0;
    self.brightLabel.frame = (CGRect){{brightLabelX, brightLabelY}, brightLabelSize};
    
    CGFloat brightImageViewWith = 70;
    CGFloat brightImageViewHeight = 70;
    CGFloat brightImageViewX = (self.brightUIView.bounds.size.width - brightImageViewWith) / 2;
    CGFloat brightImageViewY = CGRectGetMaxY(self.brightLabel.frame) + 15;
    self.brightImageView.frame = CGRectMake(brightImageViewX, brightImageViewY, brightImageViewWith, brightImageViewHeight);
    
    CGFloat brightUIViewSliderWith = kVideoControlBrightUIViewSliderWith;
    CGFloat brightUIViewSliderHeight = kVideoControlBrightUIViewSliderHeight;
    CGFloat brightUIViewSliderX = (self.brightUIView.bounds.size.width - brightUIViewSliderWith) / 2;
    CGFloat brightUIViewSliderY = self.brightUIView.bounds.size.height - 21;
    self.brightUIViewSlider.frame = CGRectMake(brightUIViewSliderX, brightUIViewSliderY, brightUIViewSliderWith, brightUIViewSliderHeight);
    
    CGFloat squareMargin = 1;
    CGFloat squareHeight = brightUIViewSliderHeight - 2;
    CGFloat squareWith = (brightUIViewSliderWith - (kVideoBrightUIViewSliderTotalColumns + 1) * squareMargin) / kVideoBrightUIViewSliderTotalColumns;
    self.brightSquareWith = squareWith;

    for (int i = 0; i < self.brightUIViewSliderValueM.count; i++)
    {
        UIView *square = (UIView *)self.brightUIViewSliderValueM[i];
        
        CGFloat squareX = squareMargin + i * (squareWith + squareMargin);
        
        CGFloat squareY = squareMargin;
        
        square.frame = CGRectMake(squareX, squareY, squareWith, squareHeight);
    }
    
    [self controlBrightUIViewSliderSquare:[UIScreen mainScreen].brightness];
    
    
    self.seekUIView.center = CGPointMake(CGRectGetMidX(self.bounds), 125);
    if (iOS8AndLater)
    {
        self.seekEffectView.center = CGPointMake(CGRectGetMidX(self.seekUIView.bounds), CGRectGetMidY(self.seekUIView.bounds));
    }
    else
    {
        self.seekUIToolbar.center = CGPointMake(CGRectGetMidX(self.seekUIView.bounds), CGRectGetMidY(self.seekUIView.bounds));
    }
    
    CGFloat seekImageViewWith = 60;
    CGFloat seekImageViewHeight = 60;
    CGFloat seekImageViewX = (self.seekUIView.bounds.size.width - seekImageViewWith) / 2;
    CGFloat seekImageViewY = 0;
    self.seekDirectionImageView.frame = CGRectMake(seekImageViewX, seekImageViewY, seekImageViewWith, seekImageViewHeight);

    CGFloat seekTimeLabelX = 0;
    CGFloat seekTimeLabelY = CGRectGetMaxY(self.seekDirectionImageView.frame) - 5;
    self.seekTimeLabel.frame = CGRectMake(seekTimeLabelX, seekTimeLabelY, kVideoControlSeekUIViewWith, kVideoControlSeekLabelFontSize);
    
    CGFloat lockButtonX = 45;
    CGFloat lockButtonY = CGRectGetMidY(self.bounds);
    CGFloat lockButtonWith = 45;
    CGFloat lockButtonHeight = 45;
    self.lockButton.bounds = CGRectMake(0, 0, lockButtonWith, lockButtonHeight);
    self.lockButton.center = CGPointMake(lockButtonX, lockButtonY);
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    self.isBarShowing = YES;
    self.isBrightUIViewShowing = NO;
    self.isSeekUIViewShowing = NO;
    self.isQualityViewShowing = NO;
}

- (void)animateSeekUIViewShow
{
    if (self.isSeekUIViewShowing == YES) {
        return;
    }
    
    [UIView animateWithDuration:0.0 animations:^{
        self.seekUIView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isSeekUIViewShowing = YES;
        
        AndyLog(@"快进快退已显示");
    }];
}

- (void)animateSeekUIViewHide
{
    if (self.isSeekUIViewShowing == NO)
    {
        return;
    }
    
    [UIView animateWithDuration:kVideoSeekUIViewAnimationTimeinterval animations:^{
        self.seekUIView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isSeekUIViewShowing = NO;
    }];
}

- (void)autoFadeOutSeekUIView
{
    if (!self.isSeekUIViewShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateSeekUIViewHide) object:nil];
    [self performSelector:@selector(animateSeekUIViewHide) withObject:nil afterDelay:kVideoSeekUIViewAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutSeekUIView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateSeekUIViewHide) object:nil];
}

- (void)animateBrightUIViewShow
{
    if (self.isBrightUIViewShowing == YES) {
        return;
    }
    
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.brightUIView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isBrightUIViewShowing = YES;
    }];
}

- (void)animateBrightUIViewHide
{
    if (self.isBrightUIViewShowing == NO)
    {
        return;
    }
    
    [UIView animateWithDuration:kVideoBrightUIViewAnimationTimeinterval animations:^{
        self.brightUIView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isBrightUIViewShowing = NO;
    }];
}

- (void)autoFadeOutBrightUIView
{
    if (!self.isBrightUIViewShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBrightUIViewHide) object:nil];
    [self performSelector:@selector(animateBrightUIViewHide) withObject:nil afterDelay:kVideoBrightUIViewAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutBrightUIView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateBrightUIViewHide) object:nil];
}

- (void)animateHide
{
    if (!self.isBarShowing) {
        return;
    }

    [self animateQualityViewHide];
    
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 0.0;
        self.bottomBar.alpha = 0.0;
        if (!self.lockButton.selected)
        {
            self.lockButton.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        self.isBarShowing = NO;
        if (self.krVideoPlayer != nil)
        {
            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
        }
    }];
}

- (void)animateShow
{
    if (self.isBarShowing) {
        return;
    }

    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.topBar.alpha = 1.0;
        self.bottomBar.alpha = 1.0;
        self.lockButton.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isBarShowing = YES;
        
        [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
        
        if (!self.indicatorView.isAnimating)
        {
            [self autoFadeOutControlBar];
        }
    }];
}

- (void)autoFadeOutControlBar
{
    if (!self.isBarShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
    [self performSelector:@selector(animateHide) withObject:nil afterDelay:kVideoControlBarAutoFadeOutTimeinterval];
}

- (void)cancelAutoFadeOutControlBar
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateHide) object:nil];
}

- (void)animateQualityViewHide
{
    if (!self.isQualityViewShowing) {
        return;
    }
    
    [UIView animateWithDuration:kVideoControlAnimationTimeinterval animations:^{
        self.qualityView.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.isQualityViewShowing = NO;
        self.qualityView.userInteractionEnabled = NO;
    }];
}

- (void)animateQualityViewShow
{
    if (self.isQualityViewShowing) {
        return;
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        self.qualityView.alpha = 1.0;
    } completion:^(BOOL finished) {
        self.isQualityViewShowing = YES;
        self.qualityView.userInteractionEnabled = YES;
        [self autoFadeOutQualityView];
    }];
}

- (void)autoFadeOutQualityView
{
    if (!self.isQualityViewShowing) {
        return;
    }
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateQualityViewHide) object:nil];
    [self performSelector:@selector(animateQualityViewHide) withObject:nil afterDelay:2.0];
}

- (void)cancelAutoFadeOutQualityView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(animateQualityViewHide) object:nil];
}

- (void)onTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        if (self.isBarShowing && !self.indicatorView.isAnimating) {
            [self animateHide];
        } else {
            [self animateShow];
        }
    }
}

- (void)onDoubleTap:(UITapGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateRecognized) {
        [self.krVideoPlayer dismiss];
    }
}

- (void)controlBrightUIViewSliderSquare:(CGFloat)brightValue
{
    int squareIndex = (int)(brightValue * kVideoControlBrightUIViewSliderWith / self.brightSquareWith);
    
    if (squareIndex == 0)
    {
        squareIndex = 1;
    }
    
    for (int i = 0; i < self.brightUIViewSliderValueM.count; i++)
    {
        UIView *square = (UIView *)self.brightUIViewSliderValueM[i];
        if (i < squareIndex)
        {
            square.alpha = 1.0;
        }
        else
        {
            square.alpha = 0.0;
        }
    }
}

- (void)controlSeekDirectionImageView:(BOOL)isSeekingForward
{
    UIImage *img = [UIImage imageNamed:[self videoImageName:isSeekingForward ? @"progress_icon_r" : @"progress_icon_l"]];
    UIImage *tintImg = [img rt_tintedImageWithColor:iOSBlurAdjustColor];
    
    [self.seekDirectionImageView setImage:tintImg];
}

- (void)lockButtonSelected:(UIButton *)button
{
    button.selected = !button.selected;
    
    if (button.isSelected)
    {
        button.alpha = 1.0;
        
        [self animateHide];
        
        [self.guestureUIView removeGestureRecognizer:self.tapGesture];

        [self.guestureUIView removeGestureRecognizer:self.panGesture];
        
        [self.guestureUIView removeGestureRecognizer:self.doubleTapGesture];
    }
    else
    {
        [self animateShow];
        
        [self.guestureUIView addGestureRecognizer:self.tapGesture];
        
        [self.guestureUIView addGestureRecognizer:self.panGesture];
        
        if (self.isDoubleTapOn)
        {
            [self.guestureUIView addGestureRecognizer:self.doubleTapGesture];
        }
        else
        {
            [self.guestureUIView removeGestureRecognizer:self.doubleTapGesture];
        }
    }
}

- (void)cameraCaptureButtonClick:(UIButton *)button
{
    [self.krVideoPlayer requestThumbnailImagesAtTimes:@[@(self.krVideoPlayer.currentPlaybackTime)] timeOption:MPMovieTimeOptionExact];
    
    [self captureNoticeShow:^{
        [MBProgressHUD showSuccess:@"画面捕捉完成，已存至相册" shouldAutoRoateAngle:M_PI_2];
    }];
}

- (void)captureNoticeShow:(void (^)())completed
{
    UIView *noticeView = [[UIView alloc] initWithFrame:self.bounds];
    noticeView.backgroundColor = [UIColor whiteColor];
    noticeView.alpha = 0.0;
    [self addSubview:noticeView];
    
    [UIView animateWithDuration:0.1 animations:^{
        noticeView.alpha = 0.9;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.4 animations:^{
            noticeView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (completed)
            {
                [noticeView removeFromSuperview];
                completed();
            }
        }];
    }];
}

- (void)qualityView:(AndyQualityView *)qualityView didClickedButtonWithQualityLabel:(NSString *)qualityLabel andPlayUrl:(NSURL *)playNSURL from:(int)from to:(int)to
{
    if (from != to)
    {
        [self.qualityButton setTitle:qualityLabel forState:UIControlStateNormal];
        
        self.krVideoPlayer.contentURL = playNSURL;
    }
    
    [self.krVideoPlayer stopDurationTimer];
    
    [self.indicatorView startAnimating];
    
    [self cancelAutoFadeOutControlBar];
    
    [self animateQualityViewHide];
}

- (void)qualityButtonClick:(UIButton *)button
{
    if (self.isQualityViewShowing) {
        [self animateQualityViewHide];
    } else {
        [self animateQualityViewShow];
    }
}

- (void)combineQualityView:(NSArray *)qualityArray
{
    if (qualityArray == nil || qualityArray.count == 0)
    {
        self.qualityButton.enabled = NO;
        self.qualityButton.alpha = 0;
    }
    else
    {
        self.qualityButton.alpha = 1.0;
        
        NSDictionary *qualityDic = (NSDictionary *)qualityArray[0];
        NSString *keyStr = (NSString *)[qualityDic allKeys][0];
        
        [self.qualityButton setTitle:keyStr forState:UIControlStateNormal];
        
        if (qualityArray.count == 1)
        {
            self.qualityButton.enabled = NO;
        }
        else
        {
            self.qualityButton.enabled = YES;
            
            CGFloat qualityViewWith = 45;
            CGFloat qualityViewHeight = qualityArray.count * 38;
            
            self.qualityView.frame = CGRectMake(CGRectGetMinX(self.qualityButton.frame), CGRectGetMaxY(self.topBar.frame) + 2, qualityViewWith, qualityViewHeight);
            
            [self addSubview:self.qualityView];
            
            [self.qualityView setupQualityButtonWithArray:qualityArray];
        }
    }
}

#pragma mark - Property

- (AndyQualityView *)qualityView
{
    if (_qualityView == nil)
    {
        _qualityView = [[AndyQualityView alloc] init];
        _qualityView.backgroundColor = AndyColor(0, 0, 0, 0.4);
        _qualityView.alpha = 0;
        _qualityView.userInteractionEnabled = NO;
        _qualityView.delegate  =self;
    }
    return _qualityView;
}

- (UIButton *)qualityButton
{
    if (_qualityButton == nil)
    {
        _qualityButton = [[UIButton alloc] init];
        _qualityButton.bounds = CGRectMake(0, 0, 45, 45);
        [_qualityButton setTitle:@"高清" forState:UIControlStateNormal];
        [_qualityButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_qualityButton setTitleColor:AndyColor(170, 170, 170, 1.0) forState:UIControlStateHighlighted];
        [_qualityButton setTitleColor:AndyColor(170, 170, 170, 1.0) forState:UIControlStateDisabled];
        _qualityButton.titleLabel.font = [UIFont systemFontOfSize:15];
        _qualityButton.enabled = NO;
        _qualityButton.alpha = 0.0;
        [_qualityButton addTarget:self action:@selector(qualityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _qualityButton;
}

- (UIButton *)lockButton
{
    if (_lockButton == nil)
    {
        _lockButton = [[UIButton alloc] init];

        _lockButton.alpha = 1.0;
        
        _lockButton.backgroundColor = [UIColor clearColor];
        
        UIImage *imgNormal = [UIImage imageNamed:[self videoImageName:@"lockScreen_off_p"]];
        //UIImage *tintImgNormal = [imgNormal rt_tintedImageWithColor:AndyColor(75, 75, 75, 1.0)];
        [_lockButton setImage:[imgNormal imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        
        UIImage *imgSelected = [UIImage imageNamed:[self videoImageName:@"lockScreen_on_p"]];
        //UIImage *tintimgSelected = [imgSelected rt_tintedImageWithColor:AndyColor(75, 75, 75, 1.0)];
        [_lockButton setImage:[imgSelected imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        
        [_lockButton addTarget:self action:(@selector(lockButtonSelected:)) forControlEvents:UIControlEventTouchUpInside];
    }
    return _lockButton;
}

- (UIButton *)cameraButton
{
    if (_cameraButton == nil)
    {
        _cameraButton = [[UIButton alloc] init];
        
        UIImage *imgNormal = [UIImage imageNamed:[self videoImageName:@"Camera"]];
        [_cameraButton setImage:imgNormal forState:UIControlStateNormal];
        UIImage *tintimgDisabled = [imgNormal rt_tintedImageWithColor:AndyColor(75, 75, 75, 1.0)];
         [_cameraButton setImage:tintimgDisabled forState:UIControlStateDisabled];
        _cameraButton.enabled = NO;
        _cameraButton.bounds = CGRectMake(0, 0, kVideoControlCamaraButtonWith, kVideoControlCamaraButtonheight);
        [_cameraButton addTarget:self action:@selector(cameraCaptureButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cameraButton;
}

- (NSMutableArray *)brightUIViewSliderValueM
{
    if (_brightUIViewSliderValueM == nil)
    {
        _brightUIViewSliderValueM = [NSMutableArray array];
    }
    return _brightUIViewSliderValueM;
}

- (UIView *)guestureUIView
{
    if (_guestureUIView == nil)
    {
        _guestureUIView = [[UIView alloc] init];
        //UIView只有在背景不为黑色的时候，才会去响应Pan事件。这也是为什么当视频刚开始黑色画面的时候快进快退不显示指示SeekUIView的原因。
        _guestureUIView.backgroundColor = [UIColor clearColor];
        _guestureUIView.bounds = CGRectMake(0, 0, AndyMainScreenSize.width, AndyMainScreenSize.height - kVideoControlTopBarHeight - kVideoControlBottomBarHeight);
    }
    return _guestureUIView;
}

- (UIView *)seekUIView
{
    if (_seekUIView == nil)
    {
        _seekUIView = [[UIView alloc] init];
        _seekUIView.backgroundColor = [UIColor clearColor];
        _seekUIView.alpha = 0.0;
        _seekUIView.bounds = CGRectMake(0, 0, kVideoControlSeekUIViewWith, kVideoControlSeekUIViewHeight);
        _seekUIView.clipsToBounds = YES;
        _seekUIView.layer.cornerRadius = 7;
        if (iOS8AndLater)
        {
            [_seekUIView addSubview:self.seekEffectView];
        }
        else
        {
            [_seekUIView addSubview:self.seekUIToolbar];
        }
        [_seekUIView addSubview:self.seekDirectionImageView];
        [_seekUIView addSubview:self.seekTimeLabel];
    }
    return _seekUIView;
}

- (UIToolbar *)seekUIToolbar
{
    if (_seekUIToolbar == nil)
    {
        _seekUIToolbar = [[UIToolbar alloc] init];
        _seekUIToolbar.bounds = CGRectMake(0, 0, kVideoControlSeekUIViewWith, kVideoControlSeekUIViewHeight);
    }
    return _seekUIToolbar;
}

- (UIVisualEffectView *)seekEffectView
{
    if (_seekEffectView == nil)
    {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        _seekEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _seekEffectView.bounds = CGRectMake(0, 0, kVideoControlSeekUIViewWith, kVideoControlSeekUIViewHeight);
        //_brightToolbar.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _seekEffectView;
}

- (UIImageView *)seekDirectionImageView
{
    if (_seekDirectionImageView == nil)
    {
        _seekDirectionImageView = [[UIImageView alloc] init];
        _seekDirectionImageView.alpha = iOSBlurAdjustAlpha;
        UIImage *img = [UIImage imageNamed:[self videoImageName:@"progress_icon_r"]];
        UIImage *tintImg = [img rt_tintedImageWithColor:iOSBlurAdjustColor];
        
        [_seekDirectionImageView setImage:tintImg];
    }
    return _seekDirectionImageView;
}

- (UILabel *)seekTimeLabel
{
    if (_seekTimeLabel == nil)
    {
        _seekTimeLabel = [[UILabel alloc] init];
        _seekTimeLabel.alpha = iOSBlurAdjustAlpha;
        _seekTimeLabel.font = [UIFont systemFontOfSize:kVideoControlSeekLabelFontSize];
        _seekTimeLabel.textColor = iOSBlurAdjustColor;
        _seekTimeLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _seekTimeLabel;
}

- (UIView *)brightUIView
{
    if (_brightUIView == nil)
    {
        _brightUIView = [[UIView alloc] init];
        _brightUIView.backgroundColor = [UIColor clearColor];
        _brightUIView.alpha = 0.0;
        _brightUIView.bounds = CGRectMake(0, 0, kVideoControlBrightUIViewWith, kVideoControlBrightUIViewHeight);
        _brightUIView.clipsToBounds = YES;
        _brightUIView.layer.cornerRadius = 7;
        if (iOS8AndLater)
        {
            [_brightUIView addSubview:self.brightEffectView];
        }
        else
        {
            [_brightUIView addSubview:self.brightToolbar];
        }
        [_brightUIView addSubview:self.brightLabel];
        [_brightUIView addSubview:self.brightImageView];
        [_brightUIView addSubview:self.brightUIViewSlider];
    }
    return _brightUIView;
}

- (UIToolbar *)brightToolbar
{
    if (_brightToolbar == nil)
    {
        _brightToolbar = [[UIToolbar alloc] init];
        _brightToolbar.bounds = CGRectMake(0, 0, kVideoControlBrightUIViewWith, kVideoControlBrightUIViewHeight);
        //_brightToolbar.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _brightToolbar;
}

- (UIVisualEffectView *)brightEffectView
{
    if (_brightEffectView == nil)
    {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        
        _brightEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _brightEffectView.bounds = CGRectMake(0, 0, kVideoControlBrightUIViewWith, kVideoControlBrightUIViewHeight);
        //_brightToolbar.layer.anchorPoint = CGPointMake(0.5, 0.5);
    }
    return _brightEffectView;
}

- (UILabel *)brightLabel
{
    if (_brightLabel == nil)
    {
        _brightLabel = [[UILabel alloc] init];
        _brightLabel.font = BrightTitleLabelFont;
        _brightLabel.alpha = iOSBlurAdjustAlpha;
        _brightLabel.textColor = iOSBlurAdjustColor;
    }
    return _brightLabel;
}

- (UIImageView *)brightImageView
{
    if (_brightImageView == nil)
    {
        _brightImageView = [[UIImageView alloc] init];
        _brightImageView.alpha = iOSBlurAdjustAlpha;
        UIImage *img = [UIImage imageNamed:[self videoImageName:@"player_bright_big"]];
        UIImage *tintImg = [img rt_tintedImageWithColor:iOSBlurAdjustColor];
        
        [_brightImageView setImage:tintImg];
    }
    return _brightImageView;
}

- (UIView *)brightUIViewSlider
{
    if (_brightUIViewSlider == nil)
    {
        _brightUIViewSlider = [[UIView alloc] init];
        _brightUIViewSlider.backgroundColor = iOSBlurAdjustColor;
        
        for (int i = 0; i < kVideoBrightUIViewSliderTotalColumns; i++)
        {
            UIView *square = [[UIView alloc] init];
            square.backgroundColor = [UIColor whiteColor];
            [self.brightUIViewSliderValueM addObject:square];
            [self.brightUIViewSlider addSubview:square];
        }
    }
    return _brightUIViewSlider;
}

- (MPMusicPlayerController *)musicPlayer
{
    if (_musicPlayer == nil)
    {
        _musicPlayer = [MPMusicPlayerController iPodMusicPlayer];
    }
    return _musicPlayer;
}


- (UIView *)topBar
{
    if (!_topBar) {
        _topBar = [UIView new];
        _topBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _topBar;
}

- (UIView *)bottomBar
{
    if (!_bottomBar) {
        _bottomBar = [UIView new];
        _bottomBar.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    }
    return _bottomBar;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playButton setImage:[UIImage imageNamed:[self videoImageName:@"kr-video-player-play"]] forState:UIControlStateNormal];
        _playButton.bounds = CGRectMake(0, 0, kVideoControlBottomBarHeight, kVideoControlBottomBarHeight);
    }
    return _playButton;
}

- (UIButton *)pauseButton
{
    if (!_pauseButton) {
        _pauseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_pauseButton setImage:[UIImage imageNamed:[self videoImageName:@"kr-video-player-pause"]] forState:UIControlStateNormal];
        _pauseButton.bounds = CGRectMake(0, 0, kVideoControlBottomBarHeight, kVideoControlBottomBarHeight);
    }
    return _pauseButton;
}

- (UIButton *)fullScreenButton
{
    if (!_fullScreenButton) {
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_fullScreenButton setImage:[UIImage imageNamed:[self videoImageName:@"kr-video-player-fullscreen"]] forState:UIControlStateNormal];
        _fullScreenButton.bounds = CGRectMake(0, 0, kVideoControlBottomBarHeight, kVideoControlBottomBarHeight);
    }
    return _fullScreenButton;
}

- (UIButton *)shrinkScreenButton
{
    if (!_shrinkScreenButton) {
        _shrinkScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shrinkScreenButton setImage:[UIImage imageNamed:[self videoImageName:@"kr-video-player-shrinkscreen"]] forState:UIControlStateNormal];
        _shrinkScreenButton.bounds = CGRectMake(0, 0, kVideoControlBottomBarHeight, kVideoControlBottomBarHeight);
    }
    return _shrinkScreenButton;
}

- (UISlider *)progressSlider
{
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        [_progressSlider setThumbImage:[UIImage imageNamed:[self videoImageName:@"kr-video-player-point"]] forState:UIControlStateNormal];
        [_progressSlider setMinimumTrackTintColor:[UIColor whiteColor]];
        [_progressSlider setMaximumTrackTintColor:[UIColor lightGrayColor]];
        _progressSlider.value = 0.f;
        _progressSlider.continuous = YES;
    }
    return _progressSlider;
}

- (UIButton *)closeButton
{
    if (!_closeButton) {
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_closeButton setImage:[UIImage imageNamed:[self videoImageName:@"kr-video-player-close"]] forState:UIControlStateNormal];
        _closeButton.bounds = CGRectMake(0, 0, kVideoControlTopBarHeight, kVideoControlTopBarHeight);
    }
    return _closeButton;
}

- (UILabel *)timeLabel
{
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.font = [UIFont systemFontOfSize:kVideoControlTimeLabelFontSize];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.bounds = CGRectMake(0, 0, kVideoControlTimeLabelFontSize, kVideoControlTimeLabelFontSize);
    }
    return _timeLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel)
    {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:kVideoControlTitleLabelFontSize];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
    }
    
    return _titleLabel;
}

- (UIActivityIndicatorView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [_indicatorView stopAnimating];
    }
    return _indicatorView;
}

#pragma mark - Private Method

- (NSString *)videoImageName:(NSString *)name
{
    if (name) {
        NSString *path = [NSString stringWithFormat:@"%@",name];
        return path;
    }
    return nil;
}

@end
