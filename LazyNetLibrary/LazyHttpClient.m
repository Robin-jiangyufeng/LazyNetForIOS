//
//  LazyHttpClient.m
//  WeiJiFIN
//
//  Created by 江钰锋 on 2017/1/11.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "LazyHttpClient.h"
@interface LazyHttpClient (){
}
/**所有的viewController请求任务*/
@property(nonatomic,strong)NSMutableDictionary*viewControllerTasks;
@end
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
        [self setRequestSerializer:[AFJSONRequestSerializer serializer]];
        [self setResponseSerializer:[AFJSONResponseSerializer serializer]];
    }
    return self;
}

-(LazyBURLSessionTask *)GET_JSON:(NSString*)VCId
          param:(RequestParam*)param
  responseProcess:(JSONResponseProcess*)responseProcess
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
      loadCache:(RequestLoadCacheBlock)loadCache
        success:(RequestSuccessBlock)success
           fail:(RequestFailBlock)fail
{
    LazyBURLSessionTask*task=[self doGet:param
                         responseProcess:responseProcess
                         loadingDelegate:loadingDelegate
                               loadCache:loadCache
                                 success:success
                                    fail:fail];
    if(task){
        [self addViewControllerTask:VCId withRequestId:[param requestId]];
    }
    return task;
}

-(LazyBURLSessionTask *)GET_JSON:(NSString*)VCId
          param:(RequestParam*)param
  responseProcess:(JSONResponseProcess*)responseProcess
loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<ResponseCallbackDelegate>)delegate
{
    LazyBURLSessionTask*task=[self doGet:param
                         responseProcess:responseProcess
                         loadingDelegate:loadingDelegate
                        callbackdelegate:delegate];
    if(task){
        [self addViewControllerTask:VCId withRequestId:[param requestId]];
    }
    return task;
}

-(LazyBURLSessionTask *)POST_JSON:(NSString*)VCId
           param:(RequestParam*)param
   responseProcess:(JSONResponseProcess*)responseProcess
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<ResponseCallbackDelegate>)delegate
{
    LazyBURLSessionTask*task=[self doPost:param
                          responseProcess:responseProcess
                          loadingDelegate:loadingDelegate
                         callbackdelegate:delegate];
    if(task){
        [self addViewControllerTask:VCId withRequestId:[param requestId]];
    }
    return task;
}

-(LazyBURLSessionTask *)POST_JSON:(NSString*)VCId
           param:(RequestParam*)param
   responseProcess:(JSONResponseProcess*)responseProcess
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
       loadCache:(RequestLoadCacheBlock)loadCache
         success:(RequestSuccessBlock)success
            fail:(RequestFailBlock)fail
{
    LazyBURLSessionTask*task=[self doPost:param
                          responseProcess:responseProcess
                          loadingDelegate:loadingDelegate
                                loadCache:loadCache
                                  success:success
                                     fail:fail];
    if(task){
        [self addViewControllerTask:VCId withRequestId:[param requestId]];
    }
    return task;
}

-(LazyBURLSessionTask *)POST_FORM:(NSString *)VCId
           param:(RequestParam *)param
 responseProcess:(JSONResponseProcess*)responseProcess
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate{
    LazyBURLSessionTask*task=[self doFormPost:param
                              responseProcess:responseProcess
                              loadingDelegate:loadingDelegate
                             callbackdelegate:delegate];
    if(task){
        [self addViewControllerTask:VCId withRequestId:[param requestId]];
    }
    return task;
}

-(LazyBURLSessionTask *)POST_FORM:(NSString *)VCId
           param:(RequestParam *)param
 responseProcess:(JSONResponseProcess*)responseProcess
 loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
        progress:(RequestProgressBlock)progress
       loadCache:(RequestLoadCacheBlock)loadCache
         success:(RequestSuccessBlock)success
            fail:(RequestFailBlock)fail{
    LazyBURLSessionTask*task=[self doFormPost:param
                              responseProcess:responseProcess
                              loadingDelegate:loadingDelegate
                                     progress:progress
                                    loadCache:loadCache
                                      success:success fail:fail];
    if(task){
        [self addViewControllerTask:VCId withRequestId:[param requestId]];
    }
    return task;
}

/**
 * 把一个添加成功的请求添加到对应的UIViewController队列中
 *
 * @param VCId view控制器唯一id
 * @param requestId      报文id
 */
-(void)addViewControllerTask:(NSString*)VCId
               withRequestId:(NSString*)requestId {
    if (!VCId||!requestId) return;
    if (self.viewControllerTasks) {
        if ([[self.viewControllerTasks allKeys] containsObject:VCId]) {
            NSMutableArray*array = [self.viewControllerTasks objectForKey:VCId];
            if (array) {
                [array addObject:requestId];
            } else {
                array = [[NSMutableArray alloc]init];
                [array addObject:requestId];
            }
        } else {
            NSMutableArray* array = [[NSMutableArray alloc]init];
            [array addObject:requestId];
            [self.viewControllerTasks setObject:array forKey:VCId];
        }
    }
}

/**
 * 删除ViewController请求队列中的请求
 *
 * @param requestId 请求id
 */
-(void)removeViewControllerTask:(NSString*) requestId {
    [self.viewControllerTasks enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSMutableArray*  _Nonnull obj, BOOL * _Nonnull stop) {
        if(obj){
            if([obj containsObject:requestId]){
                [obj removeObject:requestId];
            }
        }
        if(!obj||obj.count<=0){
            [self.viewControllerTasks removeObjectForKey:key];
        }
    }];
}

/**
 * 取消与对应ViewController相关的所有请求
 *
 * @param VCId viewController的id
 */
-(void)cancelViewControllerTask:(NSString*)VCId {
    if (!VCId) return;
    if(self.viewControllerTasks&&[[self.viewControllerTasks allKeys] containsObject:VCId]){
        NSMutableArray* array = [self.viewControllerTasks objectForKey:VCId];
        if(array){
            [array enumerateObjectsUsingBlock:^(NSString* _Nonnull requestId, NSUInteger idx, BOOL * _Nonnull stop) {
                [self cancelRequestWithId:requestId];
            }];
            [array removeAllObjects];
        }
        [self.viewControllerTasks removeObjectForKey:VCId];
    }
}

-(void)removeTaskWithRequestId:(NSString *)requestId{
    [super removeTaskWithRequestId:requestId];
    [self removeViewControllerTask:requestId];
}

-(NSMutableDictionary*)viewControllerTasks{
    if(!_viewControllerTasks){
        _viewControllerTasks=[[NSMutableDictionary alloc]init];
    }
    return _viewControllerTasks;
}
@end
