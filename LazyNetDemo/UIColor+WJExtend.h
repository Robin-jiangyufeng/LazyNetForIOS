//
//  UIColor+WJExtend.h
//  LazyNetDemo
//
//  Created by WKY on 16/7/14.
//  Copyright © 2016年 jiangyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef	RGB
#define RGB(R,G,B)		[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:1.0f]

#undef	RGBA
#define RGBA(R,G,B,A)	[UIColor colorWithRed:R/255.0f green:G/255.0f blue:B/255.0f alpha:A]

#undef	HEX_RGB
#define HEX_RGB(V)		[UIColor colorForHex:V]

#undef	HEX_RGBA
#define HEX_RGBA(V, A)	[UIColor colorForHex:V alpha:A]

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0x00FF0000) >> 16)) / 255.0     \
green:((float)((rgbValue & 0x0000FF00) >>  8)) / 255.0     \
blue:((float)((rgbValue & 0x000000FF) >>  0)) / 255.0     \
alpha:1.0]


#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0x00FF0000) >> 16)) / 255.0     \
green:((float)((rgbValue & 0x0000FF00) >>  8)) / 255.0     \
blue:((float)((rgbValue & 0x000000FF) >>  0)) / 255.0     \
alpha:1.0]


///红色默认按钮颜色
#define kColorButtonRedNormal UIColorFromRGB(0xed4c4d)

#define kColorButtonRedHighted UIColorFromRGB(0xd54546)


@interface UIColor (WJExtend)

/**
 *  通过十六进制获取颜色
 *
 *  @param hexColor 十六进制
 *
 */
+ (UIColor *)colorForHex:(NSUInteger)hexColor;


+ (UIColor *)colorForHex:(NSUInteger)hexColor alpha:(float)alpha;

/**
 *  生成随机颜色
 */
+ (UIColor *)randomColor;

+ (UIColor *)colorForHexWithString:(NSString *)hexColor;

+(UIColor*)wjDefaultTextColor ; //默认文字颜色
+(UIColor*)wjDefaultButtonColor ; //按钮颜色
+(UIColor*)wjDefaultButtonHighLightColor ; //按钮选中颜色

@end
