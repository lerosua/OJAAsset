//
//  UIImage+OJAAsset.m
//  OJAAssetDemo
//
//  Created by lerosua on 16/1/29.
//  Copyright © 2016年 lerosua. All rights reserved.
//

#import "UIImage+OJAAsset.h"
#import <AssetsLibrary/AssetsLibrary.h>

@implementation UIImage (OJAAsset)

+ (UIImage *) oja_imageFormALAsset:(ALAsset *)asset {
    if(asset){
        ALAssetRepresentation* representation = [asset defaultRepresentation];
        UIImageOrientation orientation = UIImageOrientationUp;
        NSNumber* orientationValue = [asset valueForProperty:@"ALAssetPropertyOrientation"];
        if (orientationValue != nil) {
            orientation = [orientationValue intValue];
        }
        return  [UIImage imageWithCGImage:[representation fullResolutionImage] scale:1.0 orientation:orientation];
    }
    return nil;
}

- (UIImage *) oja_imageWithSize:(CGSize)size {
    CGSize imageSize = self.size;
    
    //小于目标宽度则返回自己
    if (imageSize.width < size.width) {
        return self;
    }
    
    CGSize scale;
    int num = size.width;
    
    scale.width = num;
    scale.height = (imageSize.height /imageSize.width) *num;
    
    return  [UIImage getScaleImage:self withSize:scale];
    
}
//按size缩放图片
+ (UIImage*)getScaleImage:(UIImage*)image withSize:(CGSize)size{
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
