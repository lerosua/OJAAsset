//
//  OJAAssetsGroup.m
//  OJia
//
//  Created by lerosua on 15/11/2.
//  Copyright © 2015年 com.ouj. All rights reserved.
//

#import "OJAAssetsGroup.h"
#import "OJAPhotosLibrary.h"
#import "OJAAsset.h"
#import "OJAAssetHeader.h"

@implementation OJAAssetsGroup

- (instancetype) initWithGroup:(ALAssetsGroup *)group {
    self = [super init];
    if(self){
        self.assetsGroup = group;
        [self.assetsGroup setAssetsFilter:[ALAssetsFilter allAssets]];
    }
    return self;
}

- (instancetype) initWithCollection:(PHAssetCollection *)collection {
    self = [super init];
    if(self){
        self.assetCollection = collection;
    }
    return self;
}

#pragma mark -
- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:OJAAssetsGroup.class])
        return NO;
    
    return ([[self groupURL] isEqual:[object groupURL]]);
}

#pragma mark -
- (BOOL) isDefaultGroup {
    if (self.assetsGroup) {
        ALAssetsGroupType assetType = (ALAssetsGroupType)[[self.assetsGroup valueForProperty:ALAssetsGroupPropertyType] intValue];
        return assetType == ALAssetsGroupLibrary;
    }else if (self.assetCollection){
        return (self.assetCollection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary);
    }else{
        return NO;
    }
}
- (CGImageRef)posterImage{
    return self.assetsGroup.posterImage;
}

- (void) fetchPosterImage:(OJAAssetFetchImageResultsBlock)fetchBlock{
    if (self.assetCollection) {
        PHFetchResult *assetsFetchResult = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:nil];
        PHAsset *asset = [assetsFetchResult lastObject];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
        options.synchronous = YES;
        CGFloat scale = [UIScreen mainScreen].scale;
        CGFloat dimension = 48;
        CGSize size = CGSizeMake(dimension*scale, dimension*scale);
        
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:size contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *result, NSDictionary *info) {
            fetchBlock(result);
        }];
        
        
    }else{
        CGImageRef posterImage      = self.assetsGroup.posterImage;
        size_t height               = CGImageGetHeight(posterImage);
        float scale                 = height / (OJAAssetThumbnailLength);
        UIImage *image              = [UIImage imageWithCGImage:posterImage scale:scale orientation:UIImageOrientationUp];
        fetchBlock(image);
    }
}

- (NSString *)groupName {
    if(self.assetCollection){
        return self.assetCollection.localizedTitle;
    }else{
        return [self.assetsGroup valueForProperty:ALAssetsGroupPropertyName];
    }
}

- (NSURL *)groupURL {
    if(self.assetCollection){
        return [NSURL URLWithString:self.assetCollection.localIdentifier];
    }else{
        return  [self.assetsGroup  valueForProperty:ALAssetsGroupPropertyURL];
    }
}

- (NSInteger)numberOfAssets {
    if(self.assetCollection){
        if (self.assetCollection.estimatedAssetCount == NSNotFound){
            PHFetchOptions *options = [PHFetchOptions new];
            options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
            PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options];
            return result.count;
        }else{
            return self.assetCollection.estimatedAssetCount;
        }
        
    }else{
        return self.assetsGroup.numberOfAssets;
    }
}

#pragma mark -
- (void)enumerateAssetsUsingBlock:(OJAAssetsGroupEnumerationResultsBlock)enumerationBlock{
    
    if(self.assetCollection){
        PHFetchOptions *options = [PHFetchOptions new];
        options.predicate = [NSPredicate predicateWithFormat:@"mediaType = %i", PHAssetMediaTypeImage];
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:self.assetCollection options:options];

        [result enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            OJAAsset *asset = [[OJAAsset alloc] initWithPHAsset:obj];
            enumerationBlock(asset, idx, stop);
        }];
        
//        [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//            OJAAsset *asset = [[OJAAsset alloc] initWithPHAsset:obj];
//            enumerationBlock(asset, idx, stop);
//        }];
        
    }else{
        [self.assetsGroup enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            OJAAsset *asset = [[OJAAsset alloc] initWithALAsset:result];
            enumerationBlock(asset, index, stop);
        }];
//        [self.assetsGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
//            OJAAsset *asset = [[OJAAsset alloc] initWithALAsset:result];
//            enumerationBlock(asset, index, stop);
//        }];
    }
}


@end
