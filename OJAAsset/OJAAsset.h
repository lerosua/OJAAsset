//
//  OJAAsset.h
//  OJia
//
//  Created by lerosua on 15/11/2.
//  Copyright © 2015年 com.ouj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "OJAPhotosLibrary.h"
@import Photos;

typedef NS_ENUM(NSUInteger, OJAFetchImageType) {
    OJAFetchImageTypeThumbnail = 0,
    OJAFetchImageTypeFullScreen,
    OJAFetchImageTypeOrigin
};

@interface OJAAsset : NSObject

@property (nonatomic, strong) ALAsset *oldAsset;
@property (nonatomic, strong) PHAsset *asset;

- (instancetype) initWithALAsset:(ALAsset *)asset;
- (instancetype) initWithPHAsset:(PHAsset *)asset;

- (NSString *)accessibilityLabel;

- (BOOL)isPhoto;
- (BOOL)isVideo;

- (BOOL)isEqual:(id)object;

- (NSString *) assetType;
- (CGImageRef)thumbnail;

- (ALAssetRepresentation *)defaultRepresentation;

- (void) fetchThumbnailImage:(OJAAssetFetchImageResultsBlock)fetchBlock;

- (void) fetchImage:(OJAFetchImageType)type synchronous:(BOOL)sync resultBlock:(OJAAssetFetchImageResultsBlock)fetchBlock;
//获取要求大小的图片，同步方法
- (void) fetchImageWithSize:(CGSize)targetSize resultBlock:(OJAAssetFetchImageResultsBlock)fetchBlock;

- (void) fetchImageData:(OJAAssetFetchImageDataResultsBlock)fetchBlock;

@end
