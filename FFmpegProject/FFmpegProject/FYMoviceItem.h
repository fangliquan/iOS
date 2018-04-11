//
//  FYMoviceItem.h
//  FFmpegProject
//
//  Created by microleo on 2017/11/8.
//  Copyright © 2017年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#include <libavcodec/avcodec.h>
#include <libavformat/avformat.h>
#include <libswscale/swscale.h>

@interface FYMoviceItem : NSObject
//视频第一关键帧UIImage
@property(nonatomic,strong,readonly) UIImage *currentImage;
//视频的Frame宽高
@property(nonatomic,assign,readonly) float videoWidth ,videoHeight;
//图片的大小
@property(nonatomic,assign,readonly) float outImageWidth ,outImageHeight;

/* 视频的长度，秒为单位 */
@property (nonatomic, assign, readonly) double duration;

/* 视频的当前秒数 */
@property (nonatomic, assign, readonly) double currentTime;

/* 视频的帧率 */
@property (nonatomic, assign, readonly) double fps;

/* 视频路径。 */
- (instancetype)initWithVideo:(NSString *)moviePath;

/* 切换资源 */
- (void)replaceTheResources:(NSString *)moviePath;

/*重播*/
- (void)resetPaly;

/* 从视频流中读取下一帧。返回假，如果没有帧读取（视频）。 */
- (BOOL)stepFrame;

/* 寻求最近的关键帧在指定的时间 */
- (void)seekTime:(double)seconds;



@end
