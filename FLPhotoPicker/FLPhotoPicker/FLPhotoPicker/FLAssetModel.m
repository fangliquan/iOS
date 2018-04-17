//
//  FLAssetModel.m
//  FLPhotoPicker
//
//  Created by microleo on 2018/4/16.
//  Copyright © 2018年 leo. All rights reserved.
//

#import "FLAssetModel.h"

@implementation FLAssetModel

+ (instancetype)modelWithAsset:(id)asset type:(FLAssetModelMediaType)type{
    FLAssetModel *model = [[FLAssetModel alloc] init];
    model.asset = asset;
    model.isSelected = NO;
    model.type = type;
    return model;
}

@end
