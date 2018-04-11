//
//  WWRefreshStyle.h
//  wwface
//
//  Created by pc on 17/2/6.
//  Copyright © 2017年 fo. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RefreshStyle) {
    RefreshStyle_None,   // 首次加载
    RefreshStyle_Head,   // 下拉加载
    RefreshStyle_Tail,   // 上拉加载
};

@interface WWRefreshStyle : NSObject

@end
