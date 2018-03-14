//
//  HttpClient+Synchro.m
//  TFPBusinessSDK
//  同步的http请求
//  Created by jiangyufeng on 2017/9/6.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "HttpClient+Synchro.h"
#import "JSONUtils.h"
#import "LazyNetLogger.h"
@implementation SyncResponse

@end

@interface AFHTTPSessionManager (Private)
- (NSURLSessionDataTask *)dataTaskWithHTTPMethod:(NSString *)method
                                       URLString:(NSString *)URLString
                                      parameters:(id)parameters
                                  uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                         success:(void (^)(NSURLSessionDataTask *, id))success
                                         failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end

@implementation HttpClient (Synchro)

-(SyncResponse *)doSyncGet:(RequestParam *)param responseProcess:(ResponseProcess *)responseProcess{
    return [self syncRequestWithParam:param httpMedth:RequestModel_GET responseProcess:responseProcess];
}

-(SyncResponse *)doSyncPost:(RequestParam *)param responseProcess:(ResponseProcess *)responseProcess{
    return [self syncRequestWithParam:param httpMedth:RequestModel_POST responseProcess:responseProcess];
}

-(SyncResponse*)syncRequestWithParam:(RequestParam *)param httpMedth:(HttpRequestModel)httpMethod responseProcess:(ResponseProcess *)responseProcess{
    if([self isExistOfTask:[param requestId]]){
        LazyNetLogWarn(@"\n");
        LazyNetLogWarn(@"\n有一个相同的请求已存在,请等待其成功后在继续操作,请求Id: %@\n请求URL: %@\n请求params:%@\n\n",
                       [param requestId],
                       [self absoluteURL:[param url]],
                       [JSONUtils dictionaryToJSONString:[param getBodys]]);
        return nil;
    }
    NSString *absoluteURL = [self absoluteURL:[param url]];
    if (absoluteURL == nil) {
        LazyNetLogWarn(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
        return nil;
    }
    [_httpSessionManager.requestSerializer setTimeoutInterval:param.request_timeout];//设置超时
    [[param headers]enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //设置请求头
        [_httpSessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    if ([NSThread isMainThread]) {
        if (_httpSessionManager.completionQueue == nil || _httpSessionManager.completionQueue == dispatch_get_main_queue()) {
            @throw
            [NSException exceptionWithName:NSInvalidArgumentException
                                    reason:@"Can't make a synchronous request on the same queue as the completion handler"
                                  userInfo:nil];
        }
    }
    __block id responseObject = nil;
    __block NSError *error = nil;
    
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSString*method=@"POST";
    if(httpMethod==RequestModel_GET){
        method=@"GET";
    }else if(httpMethod==RequestModel_POST){
        method=@"POST";
    }
    NSURLSessionDataTask *task =
    [_httpSessionManager dataTaskWithHTTPMethod:method
                       URLString:absoluteURL
                      parameters:[param bodys]
                  uploadProgress:nil
                downloadProgress:nil
                         success:
     ^(NSURLSessionDataTask *unusedTask, id resp) {
         responseObject = resp;
         dispatch_semaphore_signal(semaphore);
     }
                         failure:
     ^(NSURLSessionDataTask *unusedTask, NSError *err) {
         error = err;
         dispatch_semaphore_signal(semaphore);
     }];
    [task resume];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    SyncResponse*response=[[SyncResponse alloc]init];
    response.requestId=[param requestId];
    response.task=task;
    response.error=error;
    response.responseModel=[responseProcess process:responseObject];
    [self logCat:param response:response];
    return response;
}

-(void)logCat:(RequestParam *)param response:(SyncResponse*)response{
    if(response.error){
        LazyNetLogWarn(@"\n");
        LazyNetLogWarn(@"\n请求失败, 请求Id: %@\n请求URL: %@\n请求headers:%@\n请求params:%@\n返回错误码:%@\n返回错误信息: %@\n",
                       [param requestId],
                       [[[response.task currentRequest] URL]absoluteString],
                       [param headers],
                       [param getBodys],
                       [NSString stringWithFormat:@"%d",(int)response.error.code],
                       response.error.localizedDescription);
    }else{
        LazyNetLogDebug(@"\n");
        LazyNetLogDebug(@"\n请求成功, 请求Id: %@\n请求URL: %@\n请求headers:%@\n请求params:%@\n返回response:%@\n\n",
                        [param requestId],
                        [[[response.task currentRequest] URL]absoluteString],
                        [JSONUtils dictionaryToJSONString:[param headers]],
                        [JSONUtils dictionaryToJSONString:[param getBodys]],
                        [JSONUtils objectToJSONString:response.responseModel]);
    }
}
@end
