//
//  ResponseCallback.h
//  WeiJiFIN
//
//  Created by 江钰锋 on 2017/1/12.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>

/***
 * 上传或者下载进度回调的block
 * @param requestId 对应的请求id
 * @param bytes 当前上传或者下载的字节数
 * @param totalBytes 总的上传或下载字节数
 *
 */
typedef void (^RequestProgressBlock)(NSString*requestId,int64_t bytes,int64_t totalBytes);

/***
 * 加载缓存的block
 * @param requestId 对应的请求id
 * @param response 返回数据
 */
typedef void (^RequestLoadCacheBlock)(NSString*requestId,id response);

/***
 * 请求成功反馈的block
 * @param requestId 对应的请求id
 * @param response 返回数据
 */
typedef void (^RequestSuccessBlock)(NSString*requestId,id response);
/**
 * 请求失败反馈的方法
 * @param requestId 对应的请求id
 * @param errorCode 返回错误码
 * @param errorMsaaege 返回的错误信息
 */
typedef void (^RequestFailBlock)(NSString*requestId,NSInteger errorCode,NSString*errorMsaaege);

@protocol ResponseCallbackDelegate<NSObject>

/***
 * 加载缓存
 * @param requestId 对应的请求id
 * @param response 返回数据
 */
@optional
- (void)onLoadCache:(NSString*)requestId withResponse:(id)response;

/***
 * 请求成功反馈的方法
 * @param requestId 对应的请求id
 * @param response 返回数据
 */
@required
- (void)onSuccess:(NSString*)requestId withResponse:(id)response;

/**
 * 请求失败反馈的方法
 * @param requestId 对应的请求id
 * @param errorCode 返回错误码
 * @param errorMsaaege 返回的错误信息
 */
@required
- (void)onFail:(NSString*)requestId withCode:(NSInteger)errorCode withMessage:(NSString*)errorMsaaege;

@end

@protocol ResponseCallbackProgressDelegate<ResponseCallbackDelegate>
/***
 * 上传或者下载进度回调方法
 * @param requestId 对应的请求id
 * @param bytes 当前上传或者下载的字节数
 * @param totalBytes 总的上传或下载字节数
 *
 */
-(void)onProgress:(NSString*)requestId withBytes:(int64_t)bytes
   withTotalBytes:(int64_t)totalBytes;
@end

//加载框代理(只争对普通的请求,不争对文件上传和下载)
@protocol LoadingViewDelegate <NSObject>

/***
 * 请求开始的处理
 * @param requestId 对应的请求id
 * @param response 返回数据
 */
@required
- (void)onStart:(NSString*)requestId;

/***
 * 加载缓存时候的处理
 * @param requestId 对应的请求id
 * @param response 返回数据
 */
@optional
- (void)onLoadCache:(NSString*)requestId withResponse:(id)response;

/***
 * 请求成功的处理
 * @param requestId 对应的请求id
 * @param response 返回数据
 */
@required
- (void)onSuccess:(NSString*)requestId withResponse:(id)response;

/**
 * 请求失败的处理
 * @param requestId 对应的请求id
 * @param errorCode 返回错误码
 * @param errorMsaaege 返回的错误信息
 */
@required
- (void)onFail:(NSString*)requestId withCode:(NSInteger)errorCode withMessage:(NSString*)errorMsaaege;

@end
