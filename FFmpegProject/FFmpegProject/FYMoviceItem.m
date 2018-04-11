//
//  FYMoviceItem.m
//  FFmpegProject
//
//  Created by microleo on 2017/11/8.
//  Copyright © 2017年 leo. All rights reserved.
//

#import "FYMoviceItem.h"
@interface FYMoviceItem (){

}

@property(nonatomic,copy) NSString *currentPath;
@end;

@implementation FYMoviceItem
{
    AVFormatContext *FYFormatCtx;
    AVCodecContext  *FYCodecCtx;
    AVFrame         *FYFrame;
    AVStream        *stream;
    AVPacket        packet;
    AVPicture       picture;
    int             videoStream;
    double          fps;
    BOOL            isMoviceReleseResources;
}

-(instancetype) initWithVideo:(NSString *)moviePath{
    if (!(self = [super init])) {
        return nil;
    }
    if ([self initializeMoviceSourse:[moviePath UTF8String]]) {
        _currentPath = [moviePath copy];
        return self;
    }else{
        return nil;
    }
    
  
}

- (BOOL)initializeMoviceSourse:(const char *)filePath {
    
    isMoviceReleseResources = NO;
    AVCodec *avCodec;
    
    avcodec_register_all();
    av_register_all();
    avformat_network_init();
    //打开视频文件
    if (avformat_open_input(&FYFormatCtx, filePath, NULL, NULL)!=0) {
        NSLog(@"--------------error: open file failed ");
        goto  initError;
    }
    //检查数据流
    
    if (avformat_find_stream_info(FYFormatCtx, NULL) < 0) {
        NSLog(@"--------------------检查数据流失败");
        goto initError;
    }
    //根据数据流，找到第一个视频流
    if ((videoStream = av_find_best_stream(FYFormatCtx, AVMEDIA_TYPE_VIDEO, -1, -1, &avCodec, 0))<0) {
        NSLog(@"----------没有找到第一个视频流");
        goto initError;
    }
    
    //获取视频流的编解码上下文的指针
    
    stream  = FYFormatCtx ->streams[videoStream];
    FYCodecCtx = stream ->codec;
    
#if  DEBUG
    //打印
    av_dump_format(FYFormatCtx, videoStream, filePath, 0);
#endif
    if (stream ->avg_frame_rate.den && stream ->avg_frame_rate.num) {
        fps = av_q2d(stream ->avg_frame_rate);
    }else{
        fps = 30;
    }
    
    //查找解码器
    avCodec = avcodec_find_decoder(FYCodecCtx ->codec_id);
    if (avCodec == NULL) {
        NSLog(@"----没有找到解码器");
        goto initError;
    }
    //打开解码器
    
    if (avcodec_open2(FYCodecCtx, avCodec, NULL) <0) {
        NSLog(@"------ 打开解码器失败");
        goto initError;
    }
    
    //分配视频帧
    FYFrame = av_frame_alloc();
    _outImageWidth = FYCodecCtx ->width;
    _outImageHeight = FYCodecCtx ->height;
    return YES;
initError:
    return NO;
    
}
    











@end
