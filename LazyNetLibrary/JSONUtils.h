//
//  JSONUtils.h
//  WeiJiFIN
//  json解析工具
//  Created by 江钰锋 on 2017/1/6.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface JSONUtils : NSObject
/**
 * 将json数据转换成object对象
 * @param json json数据原型(NSString类型,NSDictionary类型等)
 * @param clazz 等到的object对象类型(根据类型转换对象)
 */
+(id)jsonToObject:(id)json withClass:(Class)clazz;

/**
 * 将对象转换成字典
 * @param values 需要转换的对象
 */
+(NSDictionary*)objectToDictionary:(id)values;

/**
 * 将对象数组转换成
 * @param array 对象数组
 * @param clazz 对象类型
 */
+(NSArray*)objectArrayToDictionary:(NSArray *)array withClass:(Class)clazz;

/**
 * 对象转json字符串
 * @param values
 */
+(NSString*)objectToJSONString:(id)values;

/**
 * 字典转String
 * @param values
 */
+(NSString*)dictionaryToJSONString:(id)values;
@end
