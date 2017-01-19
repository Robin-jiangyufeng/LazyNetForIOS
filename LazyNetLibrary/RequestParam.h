//
//  ReuqestParam.h
//  WeiJiFIN
//  请求需要的相关参数
//  Created by 江钰锋 on 2017/1/9.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>

/**http缓存加载类型*/
typedef NS_ENUM(NSUInteger, HttpCacheLoadType) {
    /** 不使用缓存,不管缓存中有无数据,直接从网络中加载,不更新缓存 */
    NOT_USE_CACHE=1,
    /** 不使用缓存,只使用网络加载,加载成功后更新缓存(要更新缓存,这种情况需要设置缓存过期时间) */
    NOT_USE_CACHE_UPDATE_CACHE=2,
    /** 先加载缓存,再请求网络,并且更新缓存(要更新缓存,这种情况需要设置缓存过期时间) */
    USE_CACHE_UPDATE_CACHE=3,
    /** 先加载缓存,再请求网络,不更新缓存 */
    USE_CACHE=4
};

@interface RequestParam : NSObject{
    /**请求id*/
    NSString*_requestId;
    /**请求地址*/
    NSString*_url;
    /**请求头*/
    NSMutableDictionary*_heasers;
    /**请求体*/
    NSMutableDictionary*_bodys;
}

/**请求超时时间*/
@property (nonatomic) int request_timeout;
/**缓存加载类型*/
@property (nonatomic) HttpCacheLoadType cacheLoadType;

/**
 * 请求参数构造方法
 * @param requestId 请求id
 * @param url 请求地址
 */
-(instancetype)initWithRequestId:(NSString*)requestId withUrl:(NSString*)url;

/**
 * 请求参数构造方法
 * @param url 请求地址
 */
-(instancetype)initWithUrl:(NSString*)url;

/**的到请求id*/
-(NSString*)requestId;

/**的到当前请求的唯一标识*/
-(NSString*)getUniqueId;

/**得到url连接*/
-(NSString*)url;

/**获取请求头*/
-(NSDictionary*)headers;

/**
 * 设置单个请求头(会替换对应的key)
 * @param 
 */
-(void)setHeader:(NSString*)values withKey:(NSString*)key;

/**
 * 设置请求头，此方法会替换之前设置的所有请求头
 * @param headers 请求头列表
 *
 */
-(void)setHeaders:(NSDictionary*)headers;

/**获取body字典*/
-(NSDictionary*)getBodys;

/**获取请求体*/
-(id)bodys;

/**
 * 添加请求头(不会替换)
 * @param headers 请求头列表
 */
-(void)addHeaders:(NSDictionary*)headers;

/**
 * 添加请求参数(健值对方式)
 * @param values
 * @param key
 */
-(void)addBody:(NSString*)values withKey:(NSString*)key;

/**
 * 添加请求方式(字典方式)
 * @param bodys
 */
-(void)addBodys:(NSDictionary*)bodys;

/**
 * 添加请求方式(普通对象方式)
 *
 */
-(void)addBodyOfObject:(id)bodys;
@end
