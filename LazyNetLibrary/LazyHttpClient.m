//
//  LazyHttpClient.m
//  WeiJiFIN
//
//  Created by 江钰锋 on 2017/1/11.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "LazyHttpClient.h"
#import "JSONResponseProcess.h"

@implementation LazyHttpClient

+ (instancetype)getInstance
{
    static id httpClient;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        httpClient = [[self alloc] init];
    });
    
    return httpClient;
}

-(instancetype)init{
    self=[super init];
    if (self) {
        _viewControllerTasks=[[NSMutableDictionary alloc]init];
        [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return self;
}

-(void)GET_JSON:(NSString*)VCId
           param:(RequestParam*)param
   responseClazz:(Class)clazz
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
       loadCache:(RequestLoadCacheBlock)loadCache
         success:(RequestSuccessBlock)success
            fail:(RequestFailBlock)fail
{
    [self doGet:param
 responseProcess:[[JSONResponseProcess alloc] initWithClass:clazz]loadingDelegate:loadingDelegate
       loadCache:loadCache
         success:success
            fail:fail];
    [self addViewControllerTask:VCId withRequestId:[param requestId]];
}

-(void)GET_JSON:(NSString*)VCId
           param:(RequestParam*)param
   responseClazz:(Class)clazz
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<ResponseCallbackDelegate>)delegate
{
    [self doGet:param
 responseProcess:[[JSONResponseProcess alloc] initWithClass:clazz]loadingDelegate:loadingDelegate callbackdelegate:delegate];
    [self addViewControllerTask:VCId withRequestId:[param requestId]];
}

-(void)POST_JSON:(NSString*)VCId
           param:(RequestParam*)param
   responseClazz:(Class)clazz
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<ResponseCallbackDelegate>)delegate
{
    [self doPost:param
 responseProcess:[[JSONResponseProcess alloc] initWithClass:clazz]loadingDelegate:loadingDelegate callbackdelegate:delegate];
    [self addViewControllerTask:VCId withRequestId:[param requestId]];
}

-(void)POST_JSON:(NSString*)VCId
           param:(RequestParam*)param
   responseClazz:(Class)clazz
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
       loadCache:(RequestLoadCacheBlock)loadCache
         success:(RequestSuccessBlock)success
            fail:(RequestFailBlock)fail
{
    [self doPost:param
 responseProcess:[[JSONResponseProcess alloc] initWithClass:clazz]loadingDelegate:loadingDelegate
       loadCache:loadCache
         success:success
            fail:fail];
    [self addViewControllerTask:VCId withRequestId:[param requestId]];
}

/**
 * 把一个添加成功的请求添加到对应的UIViewController队列中
 *
 * @param VCId view控制器唯一id
 * @param requestId      报文id
 * @throws
 * @see [类、类#方法、类#成员]
 */
-(void)addViewControllerTask:(NSString*)VCId
               withRequestId:(NSString*)requestId {
    if (!VCId||!requestId) return;
    if (_viewControllerTasks) {
        if ([[_viewControllerTasks allKeys] containsObject:VCId]) {
            NSMutableArray*array = [_viewControllerTasks objectForKey:VCId];
            if (array) {
                [array addObject:requestId];
            } else {
                array = [[NSMutableArray alloc]init];
                [array addObject:requestId];
            }
        } else {
            NSMutableArray* array = [[NSMutableArray alloc]init];
            [array addObject:requestId];
            [_viewControllerTasks setObject:array forKey:VCId];
        }
    }
}

/**
 * 删除ViewController请求队列中的请求
 *
 * @param requestId 请求id
 */
-(void)removeViewControllerTask:(NSString*) requestId {
    [_viewControllerTasks enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSMutableArray*  _Nonnull obj, BOOL * _Nonnull stop) {
        if(obj){
            if([obj containsObject:requestId]){
                [obj removeObject:requestId];
            }
        }
        if(!obj||obj.count<=0){
            [_viewControllerTasks removeObjectForKey:key];
        }
    }];
}

/**
 * 取消与对应ViewController相关的所有请求
 *
 * @param VC
 */
-(void)cancelViewControllerTask:(NSString*)VCId {
    if (!VCId) return;
    if(_viewControllerTasks&&[[_viewControllerTasks allKeys] containsObject:VCId]){
        NSMutableArray* array = [_viewControllerTasks objectForKey:VCId];
        if(array){
            [array enumerateObjectsUsingBlock:^(NSString* _Nonnull requestId, NSUInteger idx, BOOL * _Nonnull stop) {
                [self cancelRequestWithId:requestId];
            }];
            [array removeAllObjects];
        }
        [_viewControllerTasks removeObjectForKey:VCId];
    }
}

-(void)removeTaskWithRequestId:(NSString *)requestId{
    [super removeTaskWithRequestId:requestId];
    [self removeViewControllerTask:requestId];
}
@end
