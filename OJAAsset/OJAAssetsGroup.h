//
//  OJAAssetsGroup.h
//  OJia
//
//  Created by lerosua on 15/11/2.
//  Copyright © 2015年 com.ouj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "OJAPhotosLibrary.h"

@import PhotosUI;

@class OJAAsset;

typedef void (^OJAAssetsGroupEnumerationResultsBlock)(OJAAsset *result, NSUInteger index, BOOL *stop);

@interface OJAAssetsGroup : NSObject

@property (nonatomic, strong) ALAssetsGroup *assetsGroup;
@property (nonatomic, strong) PHAssetCollection *assetCollection;


- (instancetype) initWithGroup:(ALAssetsGroup *)group;
- (instancetype) initWithCollection:(PHAssetCollection *)collection;

- (BOOL)isEqual:(id)object;

- (BOOL) isDefaultGroup;

- (CGImageRef)posterImage;
- (NSString *)groupName;
- (NSURL *)groupURL;

- (NSInteger)numberOfAssets;

- (void)enumerateAssetsUsingBlock:(OJAAssetsGroupEnumerationResultsBlock)enumerationBlock;

- (void) fetchPosterImage:(OJAAssetFetchImageResultsBlock)fetchBlock;
@end
