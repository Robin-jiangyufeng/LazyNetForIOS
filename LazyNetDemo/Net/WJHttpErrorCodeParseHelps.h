//
//  WJHttpErrorCodeParseHelps.h
//
//  Created by 江钰锋 on 2017/1/12.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>
/**服务端返回的数据为空*/
#define ERROR_EMPTY_DATA @"00701"
/**返回数据与app端定义数据不一致*/
#define ERROR_DIFFER_DATA @"00702"
@interface WJHttpErrorCodeParseHelps : NSObject
/***
 * 根据对应的状态码解析成字符串信息
 */
+(NSString*)getMessageByStatusCode:(NSInteger)statusCode;
@end
