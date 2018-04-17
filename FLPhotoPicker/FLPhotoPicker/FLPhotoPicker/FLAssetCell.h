//
//  FLAssetCell.h
//  FLPhotoPicker
//
//  Created by microleo on 2018/4/16.
//  Copyright © 2018年 leo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum : NSUInteger {
    FLAssetCellTypePhoto = 0,
    FLAssetCellTypeLivePhoto,
    FLAssetCellTypePhotoGif,
    FLAssetCellTypeVideo,
    FLAssetCellTypeAudio,
}  FLAssetCellType;

@class FLAssetModel;
@interface FLAssetCell : UICollectionViewCell

@property (weak, nonatomic) UIButton *selectPhotoButton;
@property (nonatomic, strong) FLAssetModel *model;
@property (nonatomic, copy) void (^didSelectPhotoBlock)(BOOL);
@property (nonatomic, assign) FLAssetCellType type;
@property (nonatomic, copy) NSString *representedAssetIdentifier;
@property (nonatomic, assign) int32_t imageRequestID;

@property (nonatomic, copy) NSString *photoSelImageName;
@property (nonatomic, copy) NSString *photoDefImageName;

@property (nonatomic, assign) BOOL showSelectBtn;

@end





@interface FLAssetCameraCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *imageView;

@end
