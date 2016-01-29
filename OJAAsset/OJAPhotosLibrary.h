//
//  OJAAssetsLibrary.h
//  OJia
//
//  Created by lerosua on 15/11/2.
//  Copyright © 2015年 com.ouj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
@import Photos;

@class OJAAssetsGroup;
@class OJAAsset;

typedef void (^OJAAssetsLibraryGroupsEnumerationResultsBlock)(OJAAssetsGroup *group, BOOL *stop);
typedef void (^OJAAssetFetchImageResultsBlock)(UIImage *image);
typedef void (^OJAAssetFetchImageDataResultsBlock)(NSData *data);
typedef void (^OJAAssetsLibraryAssetForURLResultBlock)(OJAAsset *asset);

@interface OJAPhotosLibrary : NSObject

@property (nonatomic, strong) ALAssetsLibrary *assetsLibrary;
@property (nonatomic, strong) PHPhotoLibrary *photoLibrary;

//标识是否使用新的Photos框架
@property (nonatomic, assign,readonly) BOOL isPhotoAPI;

#pragma mark -
- (instancetype) init;

#pragma mark -
- (void)writeImageToSavedPhotosAlbum:(UIImage *)image  completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock;

- (void)assetForURL:(NSURL *)assetURL resultBlock:(OJAAssetsLibraryAssetForURLResultBlock)resultBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock;

- (void)groupForURL:(NSURL *)groupURL resultBlock:(ALAssetsLibraryGroupResultBlock)resultBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock ;

- (void)enumerateGroupsWithTypes:(ALAssetsGroupType)types usingBlock:(OJAAssetsLibraryGroupsEnumerationResultsBlock)enumerationBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock;

+ (PHImageRequestOptions *) thumbnailOptions;

@end
