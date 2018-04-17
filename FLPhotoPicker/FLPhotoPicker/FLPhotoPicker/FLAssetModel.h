//
//  FLAssetModel.h
//  FLPhotoPicker
//
//  Created by microleo on 2018/4/16.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum : NSUInteger {
    FLAssetModelMediaTypePhoto = 0,
    FLAssetModelMediaTypeLivePhoto,
    FLAssetModelMediaTypePhotoGif,
    FLAssetModelMediaTypeVideo,
    FLAssetModelMediaTypeAudio
} FLAssetModelMediaType;

@class PHAsset;
@interface FLAssetModel : NSObject

@property (nonatomic, strong) id asset;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) FLAssetModelMediaType type;

/// 用PHAsset/ALAsset实例，初始化模型
+ (instancetype)modelWithAsset:(id)asset type:(FLAssetModelMediaType)type;


@end

