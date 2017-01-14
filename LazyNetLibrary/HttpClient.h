//
//  HttpClient.h
//  WeiJiFIN
//  http请求
//  Created by 江钰锋 on 2017/1/9.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMCache.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"
#import "RequestParam.h"
#import "ResponseProcess.h"
#import "ResponseCallback.h"
// 项目打包上线都不会打印日志，因此可放心。
#ifdef DEBUG
#define LazyLog(s, ... ) NSLog( @"[%@ in line %d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__, [NSString stringWithFormat:(s), ##__VA_ARGS__] )
#else
#define LazyLog(s, ... )
#endif

typedef NS_ENUM(NSUInteger, HttpRequestModel) {
    RequestModel_GET = 1, // get请求方式
    RequestModel_POST  = 2 // post请求方式
};

// 重命名NSURLSessionTask，减轻依赖
typedef NSURLSessionTask LazyBURLSessionTask;

@interface HttpClient : NSObject{
    /**base地址*/
    NSString*_baseUrl;
    /**缓存操作管理*/
    TMCache* _cacheManager;
    /**AFNetworking客户端*/
    AFHTTPSessionManager*_httpSessionManager;
    /**所有任务*/
    NSMutableDictionary*_tasks;
}
/**
 * 构造方法
 */
-(instancetype)initWithBaseUrl:(NSString*)baseUrl;

/**
 * 构造方法
 */
-(instancetype)initWithBaseUrl:(NSString* )baseUrl withCacheName:(NSString*)cacheName;
/**
 * 构造方法
 */
-(instancetype)initWithBaseUrl:(NSString*)baseUrl withCacheName:(NSString*)cacheName withCahePath:(NSString*)cachePath;

/**
 * 设置最大的并发请求数量
 *
 */
-(void)setMaxOperationQueueSize:(int)size;

/**
 * 设置信任的ssl安全证书
 *
 */
-(void)setSecurityPolicy:(AFSecurityPolicy*)securityPolicy;

/***
 * 获取请求实际操作工具
 */
-(AFHTTPRequestSerializer*)getRequestSerializer;

/**
 * 获取请求反馈内容实际操作工具
 *
 */
-(AFHTTPResponseSerializer*)getResponseSerializer;

/***
 * 设置请求实际操作工具
 * @param requestSerializer
 */
-(void)setRequestSerializer:(AFHTTPRequestSerializer*)requestSerializer;

/**
 * 设置请求反馈内容实际操作工具
 *
 */
-(void)setResponseSerializer:(AFHTTPResponseSerializer*)responseSerializer;

/**
 * 更新请求的base地址
 */
- (void)updateBaseUrl:(NSString *)baseUrl;

/**
 * 获取请求的base地址
 */
- (NSString *)baseUrl;

/**
 * get请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param loadCache 加载缓存的反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
-(LazyBURLSessionTask *)doGet:(RequestParam*)param
              responseProcess:(ResponseProcess*)responseProcess
              loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
                    loadCache:(RequestLoadCacheBlock)loadCache
                      success:(RequestSuccessBlock)success
                         fail:(RequestFailBlock)fail;

/**
 * get请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param delegate 请求反馈处理的代理
 */
-(LazyBURLSessionTask *)doGet:(RequestParam*)param
              responseProcess:(ResponseProcess*)responseProcess
              loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
             callbackdelegate:(id<ResponseCallbackDelegate>)delegate;

/**
 * post请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param loadCache 加载缓存的反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
-(LazyBURLSessionTask *)doPost:(RequestParam*)param
               responseProcess:(ResponseProcess*)responseProcess
               loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
                     loadCache:(RequestLoadCacheBlock)loadCache
                       success:(RequestSuccessBlock)success
                          fail:(RequestFailBlock)fail;

/**
 * post请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param delegate 请求反馈处理的代理
 */
-(LazyBURLSessionTask *)doPost:(RequestParam*)param
               responseProcess:(ResponseProcess*)responseProcess
               loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
              callbackdelegate:(id<ResponseCallbackDelegate>)delegate;

/**
 * 单个文件上传
 * @param param 请求参数
 * @param uploadFile 要上传的文件
 * @param delegate 上传反馈代理
 */
- (LazyBURLSessionTask *)doUpload:(RequestParam*)param
                             file:(NSString *)uploadFile
                 callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate;

/**
 * 单个文件上传
 * @param param 请求参数
 * @param uploadFile 要上传的文件
 * @param progress 上传进度反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
- (LazyBURLSessionTask *)doUpload:(RequestParam*)param
                             file:(NSString *)uploadFile
                         progress:(RequestProgressBlock)progress
                          success:(RequestSuccessBlock)success
                             fail:(RequestFailBlock)fail;

/**
 * 下载方法
 * @param param 下载请求参数
 * @param saveToPath 下载文件保存路径
 * @param delegate 下载反馈的代理
 */
- (LazyBURLSessionTask *)doDownload:(RequestParam*)param
                         saveToPath:(NSString *)saveToPath
                   callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate;

/**
 * 下载方法
 * @param param 下载请求参数
 * @param saveToPath 下载文件保存路径
 * @param progressBlock 下载进度反馈
 * @param success 下载成功反馈
 * @param fail 下载失败反馈
 */
- (LazyBURLSessionTask *)doDownload:(RequestParam*)param
                         saveToPath:(NSString *)saveToPath
                           progress:(RequestProgressBlock)progressBlock
                            success:(RequestSuccessBlock)success
                               fail:(RequestFailBlock)fail;

/**
 * 得到当前任务数量
 */
-(NSUInteger)taskCount;

/**
 * 删除对应的任务
 *
 * @param requestId 请求id
 */
-(void)removeTaskWithRequestId:(NSString*)requestId;

/**
 * 获取对应的任务
 * @param requestId 请求id
 */
-(LazyBURLSessionTask*)getTaskWithRequestId:(NSString*)requestId;

/**
 *	取消所有请求
 */
- (void)cancelAllRequest;

/**
 *	根据对应的id取消某个请求
 *
 *	@param requestId 对应的请求的id
 */
- (void)cancelRequestWithId:(NSString *)requestId;
@end
