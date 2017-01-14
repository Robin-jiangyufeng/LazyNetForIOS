//
//  LazyHttpClient.h
//  WeiJiFIN
//
//  Created by 江钰锋 on 2017/1/11.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpClient.h"

@interface LazyHttpClient : HttpClient{
    /**所有的viewController请求任务*/
    NSMutableDictionary*_viewControllerTasks;
}
/**获取默认的请求单例*/
+ (instancetype)getInstance;

/**
 * json格式的post请求方法
 * @param VCId ViewController唯一id
 * @param param 请求参数
 * @param clazz response对象的类型
 * @param loadingDelegate 上传进度反馈
 * @param loadCache 加载缓存的反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
-(void)GET_JSON:(NSString*)VCId
          param:(RequestParam*)param
  responseClazz:(Class)clazz
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
      loadCache:(RequestLoadCacheBlock)loadCache
        success:(RequestSuccessBlock)success
           fail:(RequestFailBlock)fail;

/**
 * json格式的get请求方法
 * @param VCId ViewController唯一id
 * @param param 请求参数
 * @param clazz response对象的类型
 * @param loadingDelegate 上传进度反馈
 * @param delegate 请求反馈处理的代理
 */
-(void)GET_JSON:(NSString*)VCId
          param:(RequestParam*)param
  responseClazz:(Class)clazz
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<ResponseCallbackDelegate>)delegate;

/**
 * json格式的post请求方法
 * @param VCId ViewController唯一id
 * @param param 请求参数
 * @param clazz response对象的类型
 * @param loadingDelegate 上传进度反馈
 * @param delegate 请求反馈处理的代理
 */
-(void)POST_JSON:(NSString*)VCId
           param:(RequestParam*)param
   responseClazz:(Class)clazz
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<ResponseCallbackDelegate>)delegate;

/**
 * json格式的get请求方法
 * @param VCId ViewController唯一id
 * @param param 请求参数
 * @param clazz response对象的类型
 * @param loadingDelegate 上传进度反馈
 * @param loadCache 加载缓存的反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
-(void)POST_JSON:(NSString*)VCId
           param:(RequestParam*)param
   responseClazz:(Class)clazz
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
       loadCache:(RequestLoadCacheBlock)loadCache
         success:(RequestSuccessBlock)success
            fail:(RequestFailBlock)fail;

/**
 * 把一个添加成功的请求添加到对应的UIViewController队列中
 *
 * @param VCId view控制器唯一id
 * @param requestId      报文id
 * @throws
 * @see [类、类#方法、类#成员]
 */
-(void)addViewControllerTask:(NSString*)VCId
               withRequestId:(NSString*)requestId;

/**
 * 取消与对应ViewController相关的所有请求
 *
 * @param VC
 */
-(void)cancelViewControllerTask:(NSString*)VCId;
@end
