//
//  HttpClient.h
//  WeiJiFIN
//  http请求
//  Created by 江钰锋 on 2017/1/9.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "PINCache.h"
#import "RequestParam.h"
#import "ResponseProcess.h"
#import "ResponseCallback.h"

typedef NS_ENUM(NSUInteger, HttpRequestModel) {
    RequestModel_GET = 1, // get请求方式
    RequestModel_POST  = 2, // post请求方式
    RequestModel_POST_FORM = 3 // postForm表单提交
};

// 重命名NSURLSessionTask，减轻依赖
typedef NSURLSessionTask LazyBURLSessionTask;

@interface HttpClient : NSObject{
    /**base地址*/
    NSString*_baseUrl;
    /**缓存操作管理*/
    PINCache* _cacheManager;
    /**AFNetworking客户端*/
    AFHTTPSessionManager*_httpSessionManager;
    /**所有任务*/
    NSMutableDictionary*_tasks;
}
/**
 * 构造方法
 */
-(instancetype _Nonnull )initWithBaseUrl:(NSString*_Nullable)baseUrl;

/**
 * 构造方法
 */
-(instancetype _Nonnull )initWithBaseUrl:(NSString* _Nullable )baseUrl withCacheName:(NSString*_Nullable)cacheName;
/**
 * 构造方法
 */
-(instancetype _Nonnull)initWithBaseUrl:(NSString* _Nullable)baseUrl withCacheName:(NSString* _Nullable)cacheName withCahePath:(NSString* _Nullable)cachePath;

/***
 * 加载urlsession配置
 * (可以用于设置代理等等)
 */
-(NSURLSessionConfiguration*_Nullable)loadURLSessionConfiguration;

/**
 * 设置最大的并发请求数量
 *
 */
-(void)setMaxOperationQueueSize:(int)size;

/**
 * 设置信任的ssl安全证书
 *
 */
-(void)setSecurityPolicy:(AFSecurityPolicy*_Nullable)securityPolicy;

/***
 * 获取请求实际操作工具
 */
-(AFHTTPRequestSerializer*_Nonnull)getRequestSerializer;

/**
 * 获取请求反馈内容实际操作工具
 *
 */
-(AFHTTPResponseSerializer*_Nonnull)getResponseSerializer;

/***
 * 设置请求实际操作工具
 * @param requestSerializer 请求request
 */
-(void)setRequestSerializer:(AFHTTPRequestSerializer*_Nonnull)requestSerializer;

/**
 * 设置请求反馈内容实际操作工具
 *
 */
-(void)setResponseSerializer:(AFHTTPResponseSerializer*_Nonnull)responseSerializer;

/**
 * 更新请求的base地址
 */
- (void)updateBaseUrl:(NSString *_Nonnull)baseUrl;

/**
 * 获取请求的base地址
 */
- (NSString *_Nullable)baseUrl;

/**
 * get请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param loadCache 加载缓存的反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
-(LazyBURLSessionTask *_Nonnull)doGet:(RequestParam*_Nonnull)param
                      responseProcess:(ResponseProcess*_Nullable)responseProcess
                      loadingDelegate:(_Nullable id <LoadingViewDelegate>)loadingDelegate
                            loadCache:(RequestLoadCacheBlock _Nullable )loadCache
                              success:(RequestSuccessBlock _Nullable )success
                                 fail:(RequestFailBlock _Nullable )fail;

/**
 * get请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param delegate 请求反馈处理的代理
 */
-(LazyBURLSessionTask *_Nonnull)doGet:(RequestParam*_Nonnull)param
                      responseProcess:(ResponseProcess*_Nullable)responseProcess
              loadingDelegate:(_Nullable id<LoadingViewDelegate>)loadingDelegate
             callbackdelegate:(_Nullable id<ResponseCallbackDelegate>)delegate;

/**
 * post请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param loadCache 加载缓存的反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
-(LazyBURLSessionTask *_Nonnull)doPost:(RequestParam*_Nonnull)param
               responseProcess:(ResponseProcess*_Nullable)responseProcess
               loadingDelegate:(_Nullable id<LoadingViewDelegate>)loadingDelegate
                     loadCache:(_Nullable RequestLoadCacheBlock)loadCache
                       success:(_Nullable RequestSuccessBlock)success
                          fail:(_Nullable RequestFailBlock)fail;

/**
 * post请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param delegate 请求反馈处理的代理
 */
-(LazyBURLSessionTask *_Nonnull)doPost:(RequestParam*_Nonnull)param
               responseProcess:(ResponseProcess*_Nullable)responseProcess
               loadingDelegate:(_Nullable id<LoadingViewDelegate>)loadingDelegate
              callbackdelegate:(_Nullable id<ResponseCallbackDelegate>)delegate;

/**
 * post form表单请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param progress 进度反馈
 * @param loadCache 加载缓存的反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
-(LazyBURLSessionTask *_Nonnull)doFormPost:(RequestParam*_Nonnull)param
                   responseProcess:(ResponseProcess*_Nullable)responseProcess
                   loadingDelegate:(_Nullable id<LoadingViewDelegate>)loadingDelegate
                          progress:(_Nullable RequestProgressBlock)progress
                         loadCache:(_Nullable RequestLoadCacheBlock)loadCache
                           success:(_Nullable RequestSuccessBlock)success
                              fail:(_Nullable RequestFailBlock)fail;

/**
 * post form表单请求方法
 * @param param 请求参数
 * @param responseProcess response加工工具
 * @param loadingDelegate 上传进度反馈
 * @param delegate 上传反馈代理
 */
-(LazyBURLSessionTask *_Nonnull)doFormPost:(RequestParam*_Nonnull)param
                   responseProcess:(ResponseProcess*_Nullable)responseProcess
                   loadingDelegate:(_Nullable id<LoadingViewDelegate>)loadingDelegate
                  callbackdelegate:(_Nullable id<ResponseCallbackProgressDelegate>)delegate;

/**
 * 单个文件上传
 * @param param 请求参数
 * @param uploadFile 要上传的文件
 * @param delegate 上传反馈代理
 */
- (LazyBURLSessionTask *_Nonnull)doUpload:(RequestParam*_Nonnull)param
                             file:(NSString *_Nonnull)uploadFile
                 callbackdelegate:(_Nullable id<ResponseCallbackProgressDelegate>)delegate;

/**
 * 单个文件上传
 * @param param 请求参数
 * @param uploadFile 要上传的文件
 * @param progress 上传进度反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
- (LazyBURLSessionTask *_Nonnull)doUpload:(RequestParam*_Nonnull)param
                             file:(NSString *_Nonnull)uploadFile
                         progress:(_Nullable RequestProgressBlock)progress
                          success:(_Nullable RequestSuccessBlock)success
                             fail:(_Nullable RequestFailBlock)fail;

/**
 * 下载方法
 * @param param 下载请求参数
 * @param saveToPath 下载文件保存路径
 * @param delegate 下载反馈的代理
 */
- (LazyBURLSessionTask *_Nonnull)doDownload:(RequestParam*_Nonnull)param
                         saveToPath:(NSString *_Nonnull)saveToPath
                   callbackdelegate:(_Nullable id<ResponseCallbackProgressDelegate>)delegate;

/**
 * 下载方法
 * @param param 下载请求参数
 * @param saveToPath 下载文件保存路径
 * @param progressBlock 下载进度反馈
 * @param success 下载成功反馈
 * @param fail 下载失败反馈
 */
- (LazyBURLSessionTask *_Nonnull)doDownload:(RequestParam*_Nonnull)param
                         saveToPath:(NSString *_Nonnull)saveToPath
                           progress:(_Nullable RequestProgressBlock)progressBlock
                            success:(_Nullable RequestSuccessBlock)success
                               fail:(_Nullable RequestFailBlock)fail;
/**
 * 保存htt请求缓存的方法
 * @param loadType 缓存加载类型
 * @param requestParam 请求参数
 * @param responseProcess response加工工具
 */
-(void)saveCache:(HttpCacheLoadType)loadType
withRequestParam:(RequestParam*_Nonnull)requestParam
    withResponse:(_Nullable id)response
withResponseProcess:(ResponseProcess *_Nullable)responseProcess;

/**
 * 拼接地址得到全路径地址
 * @param url url地址
 */
-(NSString*_Nonnull)absoluteURL:(NSString*_Nonnull)url;

/***
 根据id判断任务是让已经存在
 */
-(BOOL)isExistOfTask:(NSString*_Nonnull)requestId;

/**
 * 得到当前任务数量
 */
-(NSUInteger)taskCount;

/**
 * 删除对应的任务
 *
 * @param requestId 请求id
 */
-(void)removeTaskWithRequestId:(NSString*_Nullable)requestId;

/**
 * 获取对应的任务
 * @param requestId 请求id
 */
-(LazyBURLSessionTask*_Nullable)getTaskWithRequestId:(NSString*_Nonnull)requestId;

/**
 *	取消所有请求
 */
- (void)cancelAllRequest;

/**
 *	根据对应的id取消某个请求
 *
 *	@param requestId 对应的请求的id
 */
- (void)cancelRequestWithId:(NSString *_Nullable)requestId;

/**清理缓存*/
-(void)clearCache;
@end
