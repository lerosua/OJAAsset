//
//  OJAAssetsLibrary.m
//  OJia
//
//  Created by lerosua on 15/11/2.
//  Copyright © 2015年 com.ouj. All rights reserved.
//

#import "OJAPhotosLibrary.h"
#import "OJAAssetsGroup.h"
#import "OJAAsset.h"

@implementation OJAPhotosLibrary

- (instancetype) init{
    self = [super init];
    if(self){
        if(NSClassFromString(@"PHPhotoLibrary")){
            _isPhotoAPI = YES;
            self.photoLibrary = [PHPhotoLibrary sharedPhotoLibrary];
        }else{
            _isPhotoAPI = NO;
            self.assetsLibrary = [[ALAssetsLibrary alloc] init];
        }
    }
    return self;
}



+ (PHImageRequestOptions *) thumbnailOptions {
    
    static dispatch_once_t pred = 0;
    static PHImageRequestOptions *options = nil;
    dispatch_once(&pred,^
                  {
                      PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
                      options.resizeMode = PHImageRequestOptionsResizeModeExact;
                      options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
                      
                  });
    return options;
}


- (void)writeImageToSavedPhotosAlbum:(UIImage *)image completionBlock:(ALAssetsLibraryWriteImageCompletionBlock)completionBlock {
    if (self.isPhotoAPI) {

        __block NSURL *assetURL;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
           PHAssetChangeRequest * changeRequest = [PHAssetChangeRequest creationRequestForAssetFromImage:image];
            PHObjectPlaceholder *obj = changeRequest.placeholderForCreatedAsset;
            assetURL =[NSURL URLWithString:obj.localIdentifier];
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            if(success){
                completionBlock(assetURL, error);
            }else{
                completionBlock(nil, error);
            }
        }];
        
    }else{
        [self.assetsLibrary writeImageToSavedPhotosAlbum:image.CGImage orientation:(ALAssetOrientation)image.imageOrientation completionBlock:completionBlock];
    }
}

- (void)assetForURL:(NSURL *)assetURL resultBlock:(OJAAssetsLibraryAssetForURLResultBlock)resultBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock{
    if (self.isPhotoAPI) {
        
      PHFetchResult *result = [PHAsset fetchAssetsWithLocalIdentifiers:@[assetURL.absoluteString] options:nil];
        PHAsset *asset = result.firstObject;
        if(asset){
            OJAAsset *myAsset = [[OJAAsset alloc] initWithPHAsset:asset];
            resultBlock(myAsset);
        }else{
            NSError *error = [NSError errorWithDomain:@"no-exit" code:-1 userInfo:nil];
            failureBlock(error);
        }
        
    }else{
        [self.assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            OJAAsset *myAsset = [[OJAAsset alloc] initWithALAsset:asset];
            resultBlock(myAsset);
        } failureBlock:failureBlock];
    }
}

- (void)groupForURL:(NSURL *)groupURL resultBlock:(ALAssetsLibraryGroupResultBlock)resultBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock {
    [self.assetsLibrary groupForURL:groupURL resultBlock:resultBlock failureBlock:failureBlock];
}
- (void)enumerateGroupsWithTypes:(ALAssetsGroupType)types usingBlock:(OJAAssetsLibraryGroupsEnumerationResultsBlock)enumerationBlock failureBlock:(ALAssetsLibraryAccessFailureBlock)failureBlock {
    
    if(self.isPhotoAPI){

        PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
        
        [userAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *collection, NSUInteger idx, BOOL *stop) {
            OJAAssetsGroup *group = [[OJAAssetsGroup alloc] initWithCollection:collection];
            enumerationBlock(group, stop);
//            DLog(@"album title %@", collection.localizedTitle);
        }];
        
    }else{
        [self.assetsLibrary enumerateGroupsWithTypes:types usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            if(group.numberOfAssets > 0){
                OJAAssetsGroup *myGroup = [[OJAAssetsGroup alloc] initWithGroup:group];
                enumerationBlock(myGroup, stop);
            }
            
        } failureBlock:failureBlock];
    }
}



@end
