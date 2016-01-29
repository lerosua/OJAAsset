//
//  OJAAsset.m
//  OJia
//
//  Created by lerosua on 15/11/2.
//  Copyright © 2015年 com.ouj. All rights reserved.
//

#import "OJAAsset.h"
#import "UIImage+OJAAsset.h"

@implementation OJAAsset

- (instancetype) initWithALAsset:(ALAsset *)asset {
    self = [super init];
    if(self){
        self.oldAsset = asset;
    }
    return self;
}
- (instancetype) initWithPHAsset:(PHAsset *)asset {
    self = [super init];
    if(self){
        self.asset = asset;
    }
    return self;
}

#pragma mark -
- (NSString *)accessibilityLabel
{
    return @"test";
}
- (BOOL)isPhoto
{
    if(self.asset){
        return   self.asset.mediaType == PHAssetMediaTypeImage;
    }else{
        return [[self.oldAsset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypePhoto];
    }
}

- (BOOL)isVideo
{
    if(self.asset){
        return self.asset.mediaType == PHAssetMediaTypeVideo;
    }else{
        return [[self.oldAsset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo];
    }
}

- (BOOL)isEqual:(id)object
{
    if (![object isKindOfClass:OJAAsset.class])
        return NO;
    
    return ([[self assetURL] isEqual:[object assetURL]]);
}

- (NSURL *)assetURL {
    if(self.asset){
        return [NSURL URLWithString:self.asset.localIdentifier];
    }else{
        return  [self.oldAsset  valueForProperty:ALAssetPropertyAssetURL];
    }
}

- (NSString *)assetType{
    if(self.asset){
        switch (self.asset.mediaType) {
            case PHAssetMediaTypeUnknown:
                return @"PHAssetMediaTypeUnknown";
                break;
            case PHAssetMediaTypeImage:
                return @"PHAssetMediaTypeImage";
                break;
            case PHAssetMediaTypeVideo:
                return @"PHAssetMediaTypeVideo";
                break;
            case PHAssetMediaTypeAudio:
                return @"PHAssetMediaTypeAudio";
                break;
            default:
                return @"PHAssetMediaTypeUnknown";
                break;
        }
    }else{
        return [self.oldAsset valueForProperty:ALAssetPropertyType];
    }
}

- (ALAssetRepresentation *)defaultRepresentation{
    return self.oldAsset.defaultRepresentation;
}

- (CGImageRef)thumbnail {
    return self.oldAsset.thumbnail;
}

#define kThumbnailSizeWith 80
- (void) fetchThumbnailImage:(OJAAssetFetchImageResultsBlock)fetchBlock {
    
    if (self.asset) {
        
        NSInteger retinaScale = [UIScreen mainScreen].scale;
        CGSize retinaSquare = CGSizeMake(kThumbnailSizeWith*retinaScale, kThumbnailSizeWith*retinaScale);
        
//        PHImageRequestOptions *options = [OJAPhotosLibrary thumbnailOptions];
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
        options.synchronous = NO;
        CGFloat cropSideLength = MIN(self.asset.pixelWidth, self.asset.pixelHeight);
        CGRect square = CGRectMake(0, 0, cropSideLength, cropSideLength);
        CGRect cropRect = CGRectApplyAffineTransform(square,
                                                     CGAffineTransformMakeScale(1.0 / self.asset.pixelWidth,
                                                                                1.0 / self.asset.pixelHeight));
        options.normalizedCropRect = cropRect;
        
        [[PHImageManager  defaultManager] requestImageForAsset:self.asset targetSize:retinaSquare contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            fetchBlock(result);
        }];
    }else{
        UIImage *image = [UIImage imageWithCGImage:self.oldAsset.thumbnail];
        fetchBlock(image);
    }
}

- (void) fetchImage:(OJAFetchImageType)type synchronous:(BOOL)sync resultBlock:(OJAAssetFetchImageResultsBlock)fetchBlock{
    
    if (OJAFetchImageTypeThumbnail == type) {
        [self fetchThumbnailImage:fetchBlock];
    }else if (OJAFetchImageTypeFullScreen == type){
        
        if(self.asset){
            CGSize size = [UIScreen mainScreen].bounds.size;
            CGFloat scale = [UIScreen mainScreen].scale;
            CGSize targetSize = CGSizeMake(size.width * scale, size.height *scale);
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeOpportunistic;
            options.synchronous = YES;
            
            [[PHImageManager  defaultManager] requestImageForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeAspectFit options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                fetchBlock(result);
            }];
        }else{
            UIImage *image = [UIImage imageWithCGImage:self.oldAsset.defaultRepresentation.fullScreenImage
                                                    scale:1.0
                                              orientation:UIImageOrientationUp];
            fetchBlock(image);
        }
        
    }else if (OJAFetchImageTypeOrigin == type){
        if (self.asset) {
            PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
            options.resizeMode = PHImageRequestOptionsResizeModeExact;
            options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
            options.synchronous = sync;

            [[PHImageManager  defaultManager] requestImageForAsset:self.asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                fetchBlock(result);
            }];
        }else{
            UIImage *image = [UIImage oja_imageFormALAsset:self.oldAsset];
            fetchBlock(image);
        }
    }
        
}

- (void) fetchImageWithSize:(CGSize)targetSize resultBlock:(OJAAssetFetchImageResultsBlock)fetchBlock {
    if(self.asset){
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.synchronous = YES;
        
        [[PHImageManager  defaultManager] requestImageForAsset:self.asset targetSize:targetSize contentMode:PHImageContentModeDefault options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            fetchBlock(result);
        }];
    }else{
        UIImage *image = [UIImage oja_imageFormALAsset:self.oldAsset];
        UIImage *scaleImage = [image oja_imageWithSize:targetSize];
        fetchBlock(scaleImage);

    }
}
- (void) fetchImageData:(OJAAssetFetchImageDataResultsBlock)fetchBlock {
    if(self.asset){
        PHImageRequestOptions *options = [PHImageRequestOptions new];
        options.synchronous = YES;
        [[PHImageManager defaultManager] requestImageDataForAsset:self.asset options:options resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            fetchBlock(imageData);
        }];
        
    }else{

            ALAssetRepresentation* representation = [self.oldAsset defaultRepresentation];
            
            NSLog(@"size of original asset %llu", [representation size]);
            
            // I generally would write directly to a `NSOutputStream`, but if you want it in a
            // NSData, it would be something like:
            
            NSMutableData *data = [NSMutableData data];
            
            // now loop, reading data into buffer and writing that to our data strea
            NSError *error;
            long long bufferOffset = 0ll;
            NSInteger bufferSize = 10000;
            long long bytesRemaining = [representation size];
            uint8_t buffer[bufferSize];
            NSUInteger bytesRead;
            while (bytesRemaining > 0)
            {
                bytesRead = [representation getBytes:buffer fromOffset:bufferOffset length:bufferSize error:&error];
                if (bytesRead == 0)
                {
                    NSLog(@"error reading asset representation: %@", error);
                    fetchBlock(nil);
                    return;
                }
                bytesRemaining -= bytesRead;
                bufferOffset   += bytesRead;
                [data appendBytes:buffer length:bytesRead];
            }

        fetchBlock(data);

    }
}


@end
