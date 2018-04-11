//
//  LoopView.m
//  wwface
//
//  Created by James on 15/5/8.
//  Copyright (c) 2015年 WangChongyang. All rights reserved.
//

#import "LoopView.h"
#import "UIButton+WebCache.h"

@interface LoopView()<UIScrollViewDelegate> {
    UIScrollView *_sc;
    UIPageControl *_pageControl;
    UILabel *_tilteLabel;
    NSArray *_dataSource;
    NSArray *_loopPicturesArray;
    NSTimer *_timer;
    
    void (^_callBack)(NSInteger selectIndex);
    void (^_callBackViewController)(UIViewController * vc);
    void (^_callBackVCAndIndex)(NSString * route, NSInteger currentIndex);
}

@end

@implementation LoopView

- (instancetype)initWithFrame:(CGRect)frame urls:(NSArray *)urls handler:(void (^)(NSInteger))handler {
    
    if (self = [super initWithFrame:frame]) {
        _dataSource = urls;
        _callBack = [handler copy];
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls loopPictures:(NSArray *)loopPictures completion:(void (^)(NSString * route, NSInteger selectIndex))handler {
    if (self = [super initWithFrame:frame]) {
        _dataSource = imageUrls;
        _loopPicturesArray = loopPictures;
        _callBackVCAndIndex = [handler copy];
        [self initialize];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls loopPictures:(NSArray *)loopPictures handler:(void (^)(UIViewController *vc))handler{
    if (self = [super initWithFrame:frame]) {
        _dataSource = imageUrls;
        _loopPicturesArray = loopPictures;
        _callBackViewController = [handler copy];
        [self initialize];
    }
    return self;
}

- (void)initialize {
    
    _sc = [[UIScrollView alloc]init];
    _sc.delegate = self;
    _sc.bounces = NO;
    _sc.pagingEnabled = YES;
    _sc.showsHorizontalScrollIndicator = NO;
    [self addSubview:_sc];
    
    [_sc mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _pageControl = [[UIPageControl alloc]init];
    _pageControl.numberOfPages = _dataSource.count;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.pageIndicatorTintColor = [UIColor colorWithWhite:1 alpha:0.5];
    [self addSubview:_pageControl];
    
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@10);
        make.right.equalTo(self.mas_right).offset(-15);
        make.bottom.equalTo(self.mas_bottom).offset(-5);
    }];
    
    UIView *contentView = [[UIView alloc]init];
    [_sc addSubview:contentView];
    
    UIView *lastView;
    
    NSInteger count = _dataSource.count;
    
    if (count > 1) {
        count += 2;
    }
    bool isRetrunVc = _loopPicturesArray.count >0?YES:NO;
    
    for (NSInteger i = 0; i < count; i++) {
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (isRetrunVc) {
            [btn addTarget:self action:@selector(clickActionReturnVc:) forControlEvents:UIControlEventTouchUpInside];
        } else {
            [btn addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [contentView addSubview:btn];
        
        NSString *url = nil;
        if (i == 0) {
            url = [_dataSource lastObject];
            btn.tag = _dataSource.count - 1;
        } else if (i == _dataSource.count + 1 && _dataSource.count > 1) {
            url = [_dataSource firstObject];
            btn.tag = 0;
        } else {
            url = _dataSource[i - 1];
            btn.tag = i - 1;
        }
        btn.imageView.contentMode = UIViewContentModeScaleToFill;
        btn.imageView.layer.masksToBounds = YES;
        [btn setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:EL_Default_Image];
        
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.equalTo(contentView);
            make.left.equalTo(lastView ? lastView.mas_right : @0);
            make.width.equalTo(self.mas_width);
        }];
        lastView = btn;
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.text = @"xxxx";
        titleLabel.textColor= [UIColor whiteColor];
        titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
        titleLabel.font = [UIFont systemFontOfSize:16];
        [btn addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(btn.mas_bottom);
            make.left.equalTo(btn.mas_left).offset(0);
            make.width.equalTo(@(Main_Screen_Width));
            make.height.equalTo(@26);
        }];
        
    }
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_sc);
        make.height.equalTo(_sc);
        if (count > 0) {
            make.right.equalTo(lastView.mas_right);
        }else {
            make.right.equalTo(self.mas_left);
        }
    }];
    
    if (count > 1) {
        _sc.contentSize = CGSizeMake((_dataSource.count + 2) * self.frame.size.width, self.frame.size.height);
        _sc.contentOffset = CGPointMake(self.frame.size.width, 0);
        _timer = [NSTimer scheduledTimerWithTimeInterval:8 target:self selector:@selector(timerLoop) userInfo:nil repeats:YES];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGPoint point = scrollView.contentOffset;
    
    if (point.x == self.frame.size.width * (_dataSource.count + 1)) {
        
        scrollView.contentOffset = CGPointMake(self.frame.size.width, 0);
        _pageControl.currentPage = 0;
        
    } else if (point.x == 0) {
        
        scrollView.contentOffset = CGPointMake(self.frame.size.width * _dataSource.count, 0);
        _pageControl.currentPage = _dataSource.count - 1;
    } else {
        NSInteger num = point.x/self.frame.size.width - 1;
        _pageControl.currentPage = num;
    }
    if (_callBackVCAndIndex) {
        _callBackVCAndIndex(nil, _pageControl.currentPage);
    }
}

- (void)timerLoop {
    CGPoint point = _sc.contentOffset;
    
    if (point.x == self.frame.size.width * _dataSource.count) {
        _sc.contentOffset = CGPointMake(self.frame.size.width, 0);
        _pageControl.currentPage = 0;
    } else {
        CGFloat value = point.x - _pageControl.currentPage*CGRectGetWidth(self.frame);
        value = fabs(value - CGRectGetWidth(self.frame));
        
        if (value) return;
        
        point.x = point.x + self.frame.size.width;
        
        [UIView animateWithDuration:0.5 animations:^{
            _sc.contentOffset = point;
        }];
        int num = point.x / self.frame.size.width;
        _pageControl.currentPage = num - 1;
    }
}

- (void)clickAction:(UIButton *)btn {
    if (_callBack) {
        _callBack(btn.tag);
    }
}

- (void)clickActionReturnVc:(UIButton *)btn {
    NSInteger index = btn.tag;
    NSObject * loopPicModel = _loopPicturesArray.count >index? _loopPicturesArray[index] :nil;
//    if ([loopPicModel isKindOfClass:[HedoneLoopPictureDTO class]]) {
//        HedoneLoopPictureDTO *loopPic =(HedoneLoopPictureDTO*)loopPicModel;
//        if (loopPic) {
//            [self clickActionOperateWithLinkString:loopPic.location];
//        }
//    } else if ([loopPicModel isKindOfClass:[DiscoverLoopPic class]]) {
//        DiscoverLoopPic *loopPic =(DiscoverLoopPic*)loopPicModel;
//        if (loopPic) {
//            [self clickActionOperateWithLinkString:loopPic.location];
//        }
//    } else if ([loopPicModel isKindOfClass:[GenDiscoverLoopPicture class]]) {
//        GenDiscoverLoopPicture *loopPic =(GenDiscoverLoopPicture*)loopPicModel;
//        if (loopPic) {
//            [self clickActionOperateWithLinkString:loopPic.location];
//        }
//    } else if ([loopPicModel isKindOfClass:[HedoneAdRoute class]]) {
//        HedoneAdRoute * loopPic = (HedoneAdRoute*)loopPicModel;
//        if (loopPic) {
//            [self clickActionOperateWithLinkString:loopPic.route];
//        }
//    } else if ([loopPicModel isKindOfClass:[HedoneUnitItem class]]) {
//        HedoneUnitItem * unitItem = (HedoneUnitItem *)loopPicModel;
//        if (unitItem) {
//            [self clickActionOperateWithLinkString:unitItem.route];
//        }
//    }
}

- (void)clickActionOperateWithLinkString:(NSString *)route {
    if (_callBackViewController) {
//        [WWUrlParsingManager parsingWithActionString:route result:^(UIViewController *viewController, NSURLRequest *request, BOOL succeed,WWUrlParsingModel *model) {
//            if (viewController) {
//                _callBackViewController(viewController);
//            }
//        }];
    }
    if (_callBackVCAndIndex) {
        _callBackVCAndIndex(route, _pageControl.currentPage);
    }
}

- (void)stopLoop {
    if ([_timer isValid]) {
        [_timer invalidate];
    }
}

- (void)dealloc {
    _sc.delegate = nil;
    _timer = nil;
}


@end
