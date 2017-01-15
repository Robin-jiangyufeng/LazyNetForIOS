//
//  UIImage+Addition.h
//  WeiJiFIN
//
//  Created by Ray on 16/7/20.
//  Copyright © 2016年 WeiJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Addition)

@property (nonatomic, assign, readonly) CGFloat dp_width;
@property (nonatomic, assign, readonly) CGFloat dp_height;

+ (UIImage *)dp_imageWithColor:(UIColor *)color;
- (UIImage *)dp_imageWithTintColor:(UIColor *)tintColor;
- (UIImage *)dp_imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *)dp_roundImageWithDiameter:(CGFloat)diameter;
- (UIImage *)dp_croppedImage:(CGRect)bounds;
- (UIImage *)dp_resizedImageToSize:(CGSize)dstSize;
- (UIImage *)dp_resizedImageToFitInSize:(CGSize)boundingSize scaleIfSmaller:(BOOL)scale;

+ (UIImage *)drawBackGround;
+ (UIImage *)drawNavBar;
+ (UIImage *)calendarBackgroundImage : (float)height;

@end
