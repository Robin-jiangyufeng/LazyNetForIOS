//
//  LazyHttpClient+Custom.h
//  添加自定义的请求方法
//  Created by 江钰锋 on 2017/1/12.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WrapResponseCallback.h"
#import "RequestParam.h"
#import "LazyHttpClient.h"
@interface LazyHttpClient(WJCustom)

/**
 * 自定义的post请求方法
 * @param viewController
 * @param param 请求参数
 * @param clazz response对象的类型
 * @param loadingDelegate 上传进度反馈
 * @param delegate 请求反馈处理的代理
 */
-(void)wj_POST:(UIViewController*)viewController
           param:(RequestParam*)param
   responseClazz:(Class)clazz
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<WJResponseCallbackDelegate>)delegate;

/**
 * 自定义的post请求方法
 * @param viewController
 * @param param 请求参数
 * @param clazz response对象的类型
 * @param loadingDelegate 上传进度反馈
 * @param loadCache 加载缓存的反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
-(void)wj_POST:(UIViewController*)viewController
          param:(RequestParam*)param
  responseClazz:(Class)clazz
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
      loadCache:(WJRequestLoadCacheBlock)loadCache
        success:(WJRequestSuccessBlock)success
           fail:(WJRequestFailBlock)fail;

-(void)wj_GET:(UIViewController*)viewController
        param:(RequestParam*)param
responseClazz:(Class)clazz
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<WJResponseCallbackDelegate>)delegate;

-(void)wj_GET:(UIViewController*)viewController
        param:(RequestParam*)param
responseClazz:(Class)clazz
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
    loadCache:(WJRequestLoadCacheBlock)loadCache
      success:(WJRequestSuccessBlock)success
         fail:(WJRequestFailBlock)fail;
@end
