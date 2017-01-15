//
//  UIColor+WJExtend.m
//  WeiJiFIN
//
//  Created by WKY on 16/7/14.
//  Copyright © 2016年 WeiJi. All rights reserved.
//

#import "UIColor+WJExtend.h"

@implementation UIColor (WJExtend)

+ (UIColor *)colorForHex:(NSUInteger )hexColor{
    
    NSUInteger a = ((hexColor >> 24) & 0x000000FF);
    float fa = ((0 == a) ? 1.0f : (a * 1.0f) / 255.0f);
    
    return [UIColor colorForHex:hexColor alpha:fa];
}

+ (UIColor *)colorForHex:(NSUInteger)hexColor alpha:(float)alpha{
    
    if ( hexColor == 0xECE8E3 ) {
        
    }
    NSUInteger r = ((hexColor >> 16) & 0x000000FF);
    NSUInteger g = ((hexColor >> 8) & 0x000000FF);
    NSUInteger b = ((hexColor >> 0) & 0x000000FF);
    
    float fr = (r * 1.0f) / 255.0f;
    float fg = (g * 1.0f) / 255.0f;
    float fb = (b * 1.0f) / 255.0f;
    
    return [UIColor colorWithRed:fr green:fg blue:fb alpha:alpha];
    
}

+(UIColor *)randomColor{
    static BOOL seed = NO;
    if (!seed) {
        seed = YES;
        srandom((unsigned)time(NULL));
    }
    CGFloat red = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat green = (CGFloat)random()/(CGFloat)RAND_MAX;
    CGFloat blue = (CGFloat)random()/(CGFloat)RAND_MAX;
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0f];//alpha为1.0,颜色完全不透明
}

+ (UIColor *)colorForHexWithString:(NSString *)hexColor{
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [hexColor substringWithRange:range];
    range.location = 2;
    NSString *gString = [hexColor substringWithRange:range];
    range.location = 4;
    NSString *bString = [hexColor substringWithRange:range];
    
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


+(UIColor*)wjDefaultButtonHighLightColor{
    return UIColorFromRGB(0xd54546) ;
}


@end
