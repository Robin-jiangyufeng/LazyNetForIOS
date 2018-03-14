//
//  ResponseProcess.h
//  WeiJiFIN
//  服务端返回数据加工器
//  Created by 江钰锋 on 2017/1/11.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseProcess : NSObject
/**
 * 加工方法
 */
-(id)process:(id)response;
@end
