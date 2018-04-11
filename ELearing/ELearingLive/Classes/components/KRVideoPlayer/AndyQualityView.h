//
//  AndyQualityView.h
//  EyeSight
//
//  Created by 李扬 on 15/12/12.
//  Copyright © 2015年 andyli. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AndyQualityView;

@protocol AndyQualityViewDelegate <NSObject>

@optional
- (void)qualityView:(AndyQualityView *)qualityView didClickedButtonWithQualityLabel:(NSString *)qualityLabel andPlayUrl:(NSURL *)playNSURL from:(int)from to:(int)to;

@end

@interface AndyQualityView : UIView

- (void)setupQualityButtonWithArray:(NSArray *)qualityArray;

@property (nonatomic, weak) id<AndyQualityViewDelegate> delegate;

@end
