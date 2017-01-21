//
//  JSONUtils.m
//  LazyNetLibrary
//  json解析工具
//  Created by 江钰锋 on 2017/1/6.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "JSONUtils.h"

@implementation JSONUtils
+(id)jsonToObject:(id)json withClass:(__unsafe_unretained Class)clazz{
    id result=[clazz mj_objectWithKeyValues:json];
    return result;
}

+(NSDictionary *)objectToDictionary:(NSObject*)values{
    if(!values)return nil;
    return values.mj_keyValues;
}

+(NSArray *)objectArrayToDictionary:(NSArray *)array withClass:(__unsafe_unretained Class)clazz{
    return [clazz mj_keyValuesArrayWithObjectArray:array];
}

+(NSString *)objectToJSONString:(id)values{
    if(!values)return nil;
    return [values mj_JSONString];
}

+(NSString*)dictionaryToJSONString:(id)values
{
    if(!values)return nil;
    NSString *jsonString = nil;
    @try {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:values
                                                           options:NSJSONWritingPrettyPrinted error:&error];
        if (jsonData)
        {
            jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        }
        jsonString = [jsonString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];  //去除掉首尾的空白字符和换行字符
        [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    } @catch (NSException *exception) {
        jsonString=[values description];
    } @finally {
        
    }
    
    return jsonString;
}
@end
