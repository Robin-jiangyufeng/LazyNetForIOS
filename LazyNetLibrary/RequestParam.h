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
/**文件信息包装类*/
@interface FileInfor : NSObject
/**文件实体,类型只能为括号中的三种几种(NSData,NSInputStream,NSURL)*/
@property (nonatomic, strong) id body;
/**文件名*/
@property (nonatomic, copy) NSString *fileName;
/**文件类型*/
@property (nonatomic, copy) NSString *mimeType;
/**提交的数据的长度*/
@property (nonatomic, assign) unsigned long long bodyContentLength;
@property (nonatomic, assign) NSError* __autoreleasing*error;
@end

@interface RequestParam : NSObject{
    /**请求id*/
    NSString*_requestId;
    /**请求地址*/
    NSString*_url;
    /**请求头*/
    NSMutableDictionary*_heasers;
    /**请求体*/
    NSMutableDictionary*_bodys;
    /**请求头*/
    NSMutableDictionary*_files;
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

/**重置请求id*/
-(void)setRequestId:(NSString*)requestId;

/**的到当前请求的唯一标识*/
-(NSString*)getUniqueId;

/**得到url连接*/
-(NSString*)url;

/**获取请求头*/
-(NSDictionary*)headers;

/**
 * 设置单个请求头(会替换对应的key)
 * @param values values
 * @param key key
 */
-(void)setHeader:(NSString*)values withKey:(NSString*)key;

/**
 * 设置请求头，此方法会替换之前设置的所有请求头
 * @param headers 请求头列表
 *
 */
-(void)setHeaders:(NSDictionary*)headers;

/**获取要提交的表单*/
-(NSDictionary*)files;

/**
 * 添加要上传的文件
 * @param name 名称
 * @param fileInfor 文件信息
 */
-(void)addFile:(NSString*)name fileInfor:(FileInfor*)fileInfor;

/***
 * 添加要上传的文件
 * @param name 名称
 * @param fileName 文件名
 * @mimeType 文件类型
 * @param body 上传的文件实体
 * @param length 长度
 * @error 添加上传文件错误信息
 */
-(void)addFile:(NSString*)name
      fileName:(NSString*)fileName
      mimeType:(NSString*)mimeType
          body:(id)body
        length:(unsigned long long)length
         error:(NSError* __autoreleasing)error;

/***
 * 添加要上传的文件
 *
 * @param files 文件列表
 */
-(void)addFiles:(NSDictionary*)files;

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
 * @param values values
 * @param key key
 */
-(void)addBody:(NSString*)values withKey:(NSString*)key;

/**
 * 添加请求方式(字典方式)
 * @param bodys 请求参数
 */
-(void)addBodys:(NSDictionary*)bodys;

/**
 * 添加请求方式(普通对象方式)
 *
 */
-(void)addBodyOfObject:(id)bodys;
@end
