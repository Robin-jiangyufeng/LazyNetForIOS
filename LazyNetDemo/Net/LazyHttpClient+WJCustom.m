//
//  LazyHttpClient+Custom.m
//
//  Created by 江钰锋 on 2017/1/12.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "LazyHttpClient+WJCustom.h"
#import "JSONResponseProcess.h"
#import "AFURLRequestSerialization.h"
#import "RequestParam.h"

@implementation LazyHttpClient(WJCustom)

-(void)wj_POST:(UIViewController*)viewController
         param:(RequestParam*)param
 responseClazz:(Class)clazz
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<WJResponseCallbackDelegate>)delegate{
    WrapResponseCallback* callback=[[WrapResponseCallback alloc]init:viewController withDelegate:delegate];
    [self POST_JSON:NSStringFromClass(viewController.class) param:param responseProcess:[[JSONResponseProcess alloc]initWithSuccessClass:clazz] loadingDelegate:loadingDelegate callbackdelegate:callback];
}

-(void)wj_POST:(UIViewController*)viewController
         param:(RequestParam*)param
 responseClazz:(Class)clazz
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
     loadCache:(WJRequestLoadCacheBlock)loadCache
       success:(WJRequestSuccessBlock)success
          fail:(WJRequestFailBlock)fail{
    WrapResponseCallback* callback=[[WrapResponseCallback alloc]init:viewController withCache:loadCache success:success fail:fail];
    [self POST_JSON:NSStringFromClass(viewController.class) param:param responseProcess:[[JSONResponseProcess alloc]initWithSuccessClass:clazz] loadingDelegate:loadingDelegate loadCache:[callback loadCacheBlock] success:[callback successBlock] fail:[callback failBlock]];
}

-(void)wj_GET:(UIViewController*)viewController
         param:(RequestParam*)param
 responseClazz:(Class)clazz
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<WJResponseCallbackDelegate>)delegate{
    WrapResponseCallback* callback=[[WrapResponseCallback alloc]init:viewController withDelegate:delegate];
    [self GET_JSON:NSStringFromClass(viewController.class) param:param responseProcess:[[JSONResponseProcess alloc]initWithSuccessClass:clazz] loadingDelegate:loadingDelegate callbackdelegate:callback];
}

-(void)wj_GET:(UIViewController*)viewController
         param:(RequestParam*)param
 responseClazz:(Class)clazz
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
     loadCache:(WJRequestLoadCacheBlock)loadCache
       success:(WJRequestSuccessBlock)success
          fail:(WJRequestFailBlock)fail{
    WrapResponseCallback* callback=[[WrapResponseCallback alloc]init:viewController withCache:loadCache success:success fail:fail];
    [self GET_JSON:NSStringFromClass(viewController.class) param:param responseProcess:[[JSONResponseProcess alloc]initWithSuccessClass:clazz] loadingDelegate:loadingDelegate loadCache:[callback loadCacheBlock] success:[callback successBlock] fail:[callback failBlock]];
}

@end
