//
//  Define.h
//
//  Created by WKY on 16/7/14.
//  Copyright © 2016年 jiangyufeng. All rights reserved.
//

#ifndef Define_h
#define Define_h

/************************* 设备信息 *************************/
#define DEVICE_USERNAME        [[UIDevice currentDevice] name]
#define DEVICE_SYSTEMNAME      [[UIDevice currentDevice] systemName]
#define DEVICE_VESION          ([[[UIDevice currentDevice] systemVersion] floatValue])
#define DEVICE_VESION_STR       [[UIDevice currentDevice] systemVersion]
#define DEVICE_IPHONEORPAD     [[UIDevice currentDevice] userInterfaceIdiom]
#define DEVICE_ISIPAD          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define DEVICE_ADUUID          [[[ASIdentifierManager sharedManager] advertisingIdentifier]UUIDString] 

/********************** APP应用信息宏定义 **********************/
#define pub_appDelegate APP_DELEGATE
#define APP_DELEGATE ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define APP_VERSION            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
#define APP_NAME               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

/************************* 导航栏宏定义 *************************/
#define NAV_TITLE_COLOR [UIColor blackColor]
#define NAV_TITLE_FONT [UIFont systemFontOfSize:18.0]
#define NAV_BACKGROUND_COLOR  [UIColor whiteColor]
#define NAV_BUTTON_WIDTH 44.0
#define NAV_BUTTON_HEIGHT 44.0
#define NAV_BUTTON_FONT [UIFont systemFontOfSize:15.0]
#define NAV_BUTTON_COLOR [UIColor blackColor]
#define NAV_LEFTBUTTON_ICON [UIImage imageNamed:@"ic_goback"]
#define NAV_HEIGHT 64.0


/************************ 屏幕尺寸宏定义 ************************/
//设备屏幕宽度(320)
#define SCREEN_WIDTH   CGRectGetWidth([[UIScreen mainScreen] bounds])
//设备屏幕高度(480/568)
#define SCREEN_HEIGHT  CGRectGetHeight([[UIScreen mainScreen] bounds])
//获取按屏幕大小比例数值
#define SCREEN_RATIOVALUE(x) ((x/375.0)*SCREEN_WIDTH)

/**
 投资记录默认字体
 @return 解决1与9对不齐的问题
 */
#define kFont_DefaultFont(x) [UIFont fontWithName:@"Helvetica" size:x];

#define kImageName(imageName) [UIImage imageNamed:[NSString stringWithFormat:imageName]]

#endif /* WCDefines_h */

//#define WEAKSELF typeof(self) __weak weakSelf = self;
/************************ 其他宏定义 ************************/
//单例
#undef	AS_SINGLETON
#define AS_SINGLETON( __class ) \
- (__class *)sharedInstance; \
+ (__class *)sharedInstance;
#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
- (__class *)sharedInstance \
{ \
return [__class sharedInstance]; \
} \
+ (__class *)sharedInstance \
{ \
static dispatch_once_t once; \
static __class * __singleton__; \
dispatch_once( &once, ^{ __singleton__ = [[[self class] alloc] init]; } ); \
return __singleton__; \
}

