//
//  UIImage+OJAAsset.h
//  OJAAssetDemo
//
//  Created by lerosua on 16/1/29.
//  Copyright © 2016年 lerosua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ALAsset;

@interface UIImage (OJAAsset)

+ (UIImage *) oja_imageFormALAsset:(ALAsset *)asset;
- (UIImage *) oja_imageWithSize:(CGSize)size;
@end
