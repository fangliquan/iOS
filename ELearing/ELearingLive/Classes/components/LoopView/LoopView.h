//
//  LoopView.h
//  wwface
//
//  Created by James on 15/5/8.
//  Copyright (c) 2015年 WangChongyang. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLoopViewHeightAndWidthScale  1/3.0              

@interface LoopView : UIView

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls loopPictures:(NSArray *)loopPictures handler:(void (^)(UIViewController *vc))handler;

- (instancetype)initWithFrame:(CGRect)frame imageUrls:(NSArray *)imageUrls loopPictures:(NSArray *)loopPictures completion:(void (^)(NSString * route, NSInteger selectIndex))handler;

- (void)stopLoop;

@end
