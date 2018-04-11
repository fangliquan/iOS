//
//  WWTextManager.h
//  wwface
//
//  Created by pc on 16/12/15.
//  Copyright © 2016年 fo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#define kNormalLineSpace    5


@interface WWTextManager : NSObject

#pragma mark - textSize

+ (CGFloat)textOfAlineHeightWithFontSize:(NSInteger)fontSize;


+ (CGSize)textSizeWithStringZeroSpace:(NSString *)text width:(float)width fontSize:(NSInteger)fontSize;

+ (CGSize)textSizeWithString:(NSString *)text width:(float)width fontSize:(NSInteger)fontSize lineSpace:(CGFloat)space;


+(NSMutableArray *)getMessageMentionTags:(NSString*)text;

#pragma mark - isPhoneNum
+ (BOOL)validateMobile:(NSString *)mobile;

+(int)getTextMaxFontWithMaxSize:(CGSize)size andDespStr:(NSString *)desp andCurrentFontSize:(int) fontSize andMaxFontSize:(int) maxFontSize;

@end
