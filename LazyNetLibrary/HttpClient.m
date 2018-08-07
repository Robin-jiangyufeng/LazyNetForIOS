//
//  HttpClient.m
//  WeiJiFIN
//
//  Created by 江钰锋 on 2017/1/9.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "HttpClient.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "PINCache.h"
#import "JSONUtils.h"
#import "NSString+Coding.h"
#import "LazyNetLogger.h"

int const DEFAULT_OPERATION_QUEUE_SIZE=3;
NSString* const HTTPCacheSaveName = @"HttpCache";
@implementation HttpClient

-(instancetype)init{
    return [self initWithBaseUrl:nil];;
}

- (instancetype)initWithBaseUrl:(NSString *)baseUrl{
    return [self initWithBaseUrl:baseUrl withCacheName:nil];
}

-(instancetype)initWithBaseUrl:(NSString *)baseUrl withCacheName:(NSString *)cacheName{
    return [self initWithBaseUrl:baseUrl withCacheName:cacheName withCahePath:nil];
}

-(instancetype)initWithBaseUrl:(NSString *)baseUrl withCacheName:(NSString *)cacheName withCahePath:(NSString *)cachePath{
    self=[super init];
    if(self){
        [AFNetworkActivityIndicatorManager sharedManager].enabled=YES;
        [self initCacheWithCacheName:cacheName withCahePath:cachePath ];
        [self initSessionManagerWithBaseUrl:baseUrl];
        _tasks=[[NSMutableDictionary alloc]init];
    }
    return self;
}

/**
 * 初始化http请求管理工具
 *
 */
-(void)initSessionManagerWithBaseUrl:(NSString *)baseUrl{
    _baseUrl=baseUrl;
    _httpSessionManager=[[AFHTTPSessionManager alloc]initWithSessionConfiguration:[self loadURLSessionConfiguration]];
    _httpSessionManager.requestSerializer=[AFHTTPRequestSerializer serializer];
    _httpSessionManager.responseSerializer=[AFHTTPResponseSerializer serializer];
    _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                          @"text/html",
                                                                                          @"text/json",
                                                                                          @"text/plain",
                                                                                          @"text/javascript",
                                                                                          @"text/xml",
                                                                                          @"image/*"]];
    _httpSessionManager.operationQueue.maxConcurrentOperationCount=DEFAULT_OPERATION_QUEUE_SIZE;//最大并发数
}

-(NSURLSessionConfiguration*)loadURLSessionConfiguration{
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    return config;
}

/**
 * 初始化缓存管理工具
 *
 */
-(void)initCacheWithCacheName:(NSString *)cacheName withCahePath:(NSString *)cachePath{
    if(cacheName&&cachePath){
        _cacheManager=[[PINCache alloc]initWithName:cacheName rootPath:cachePath];
    }else if(cacheName&&!cachePath){
        _cacheManager=[[PINCache alloc]initWithName:cacheName rootPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    }else{
        _cacheManager=[[PINCache alloc]initWithName:HTTPCacheSaveName rootPath:[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]];
    }
}

-(void)setMaxOperationQueueSize:(int)size{
    if(size>0){
        _httpSessionManager.operationQueue.maxConcurrentOperationCount=size;
    }
}

-(void)setSecurityPolicy:(AFSecurityPolicy *)securityPolicy{
    _httpSessionManager.securityPolicy=securityPolicy;
}

-(AFHTTPRequestSerializer*)getRequestSerializer{
    return _httpSessionManager.requestSerializer;
}


-(AFHTTPResponseSerializer*)getResponseSerializer{
    return _httpSessionManager.responseSerializer;
}

-(void)setRequestSerializer:(AFHTTPRequestSerializer*)requestSerializer{
    if(requestSerializer){
        if(!_httpSessionManager.requestSerializer||![_httpSessionManager.requestSerializer isKindOfClass:requestSerializer.class]){
            _httpSessionManager.requestSerializer=requestSerializer;
        }
    }
}

-(void)setResponseSerializer:(AFHTTPResponseSerializer*)responseSerializer{
    if(responseSerializer){
        if(!_httpSessionManager.responseSerializer||![_httpSessionManager.responseSerializer isKindOfClass:responseSerializer.class]){
            _httpSessionManager.responseSerializer=responseSerializer;
            _httpSessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                                                  @"text/html",
                                                                                                  @"text/json",
                                                                                                  @"text/plain",
                                                                                                  @"text/javascript",
                                                                                                  @"text/xml",
                                                                                                  @"image/*"]];
        }
    }
}

-(NSString *)baseUrl{
    return _baseUrl;
}

-(void)updateBaseUrl:(NSString *)baseUrl{
    _baseUrl=baseUrl;
}

-(LazyBURLSessionTask *)doGet:(RequestParam*)param
              responseProcess:(ResponseProcess*)responseProcess
              loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
                    loadCache:(RequestLoadCacheBlock)loadCache
                      success:(RequestSuccessBlock)success
                         fail:(RequestFailBlock)fail {
    return [self requestWithParam:param httpMedth:RequestModel_GET responseProcess:responseProcess loadingDelegate:loadingDelegate callbackdelegate:nil progress:nil loadCache:loadCache success:success fail:fail];
}

-(LazyBURLSessionTask *)doGet:(RequestParam*)param
              responseProcess:(ResponseProcess*)responseProcess
              loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
             callbackdelegate:(id<ResponseCallbackDelegate>)delegate{
    return [self requestWithParam:param httpMedth:RequestModel_GET responseProcess:responseProcess loadingDelegate:loadingDelegate callbackdelegate:delegate progress:nil loadCache:nil success:nil fail:nil];
}

-(LazyBURLSessionTask *)doPost:(RequestParam*)param
               responseProcess:(ResponseProcess*)responseProcess
               loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
                     loadCache:(RequestLoadCacheBlock)loadCache
                       success:(RequestSuccessBlock)success
                          fail:(RequestFailBlock)fail {
    return [self requestWithParam:param httpMedth:RequestModel_POST responseProcess:responseProcess loadingDelegate:loadingDelegate callbackdelegate:nil progress:nil loadCache:loadCache success:success fail:fail];
}

-(LazyBURLSessionTask *)doPost:(RequestParam*)param
               responseProcess:(ResponseProcess*)responseProcess
               loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
              callbackdelegate:(id<ResponseCallbackDelegate>)delegate{
    return [self requestWithParam:param httpMedth:RequestModel_POST  responseProcess:responseProcess loadingDelegate:loadingDelegate callbackdelegate:delegate progress:nil loadCache:nil success:nil fail:nil];
}


-(LazyBURLSessionTask *)doFormPost:(RequestParam *)param
                   responseProcess:(ResponseProcess *)responseProcess loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate{
    return [self requestWithParam:param httpMedth:RequestModel_POST_FORM responseProcess:responseProcess loadingDelegate:loadingDelegate callbackdelegate:delegate progress:nil loadCache:nil  success:nil fail:nil];
}

-(LazyBURLSessionTask *)doFormPost:(RequestParam *)param
                   responseProcess:(ResponseProcess *)responseProcess loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate progress:(RequestProgressBlock)progress
                         loadCache:(RequestLoadCacheBlock)loadCache
                           success:(RequestSuccessBlock)success
                              fail:(RequestFailBlock)fail{
    return [self requestWithParam:param httpMedth:RequestModel_POST_FORM responseProcess:responseProcess loadingDelegate:loadingDelegate callbackdelegate:nil progress:progress loadCache:loadCache  success:success fail:fail];
}


-(LazyBURLSessionTask *)requestWithParam:(RequestParam*)param
                            httpMedth:(HttpRequestModel)httpMethod
                      responseProcess:(ResponseProcess*)responseProcess
                      loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
                     callbackdelegate:(id<ResponseCallbackDelegate>)delegate
                             progress:(RequestProgressBlock)progress
                            loadCache:(RequestLoadCacheBlock)loadCache
                              success:(RequestSuccessBlock)success
                                 fail:(RequestFailBlock)fail {
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
    if(loadingDelegate){
        [loadingDelegate onStart:[param requestId]];
    }
    if(!responseProcess){//没有设置反馈数据加工器则设置默认的
        responseProcess=[[ResponseProcess alloc]init];
    }
    [_httpSessionManager.requestSerializer setTimeoutInterval:param.request_timeout];//设置超时
    [[param headers]enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //设置请求头
        [_httpSessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    [self loadCache:param.cacheLoadType withRequestParam:param
                               loadingDelegate:loadingDelegate withRequestLoadCacheBlock:loadCache withCallbackDelegate:delegate withResponseProcess:responseProcess];//处理缓存
    LazyBURLSessionTask *session = nil;
    switch (httpMethod) {
        case RequestModel_GET:{
            session = [_httpSessionManager GET:absoluteURL parameters:[param bodys] progress:^(NSProgress * _Nonnull downloadProgress) {
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //成功反馈
                [self requestSuccess:param
                                task:task
                            response:responseObject
                     responseProcess:responseProcess
                     loadingDelegate:loadingDelegate
                    callbackdelegate:delegate
                             success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //失败反馈
                [self requestFail:param
                             task:task
                            error:error
                  loadingDelegate:loadingDelegate
                 callbackdelegate:delegate
                             fail:fail];
            }];}
            break;
        case RequestModel_POST:{
            session = [_httpSessionManager POST:absoluteURL parameters:[param bodys] progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //成功反馈
                [self requestSuccess:param
                                task:task
                            response:responseObject
                     responseProcess:responseProcess
                     loadingDelegate:loadingDelegate
                    callbackdelegate:delegate
                             success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //失败反馈
                [self requestFail:param
                             task:task
                            error:error
                  loadingDelegate:loadingDelegate
                 callbackdelegate:delegate
                             fail:fail];
            }];}
            break;
        case RequestModel_POST_FORM:{
            session = [_httpSessionManager POST:absoluteURL parameters:[param bodys] constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {//添加表单数据
                if(param&&param.files&&param.files.count>0){
                    for(NSString *key in param.files){
                        FileInfor*fileInfor=param.files[key];
                        [self appendPartWithFileInfor:formData name:key fileInfor:fileInfor];
                    }
                }
            } progress:^(NSProgress * _Nonnull uploadProgress) {
                if(delegate&&[delegate respondsToSelector:@selector(onProgress:)]){
                    [self requestProgress:param progress:uploadProgress callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate progressBlock:nil];
                }else{
                    [self requestProgress:param progress:uploadProgress callbackdelegate:nil progressBlock:progress];
                }
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                [self requestSuccess:param
                                task:task
                            response:responseObject
                     responseProcess:responseProcess
                     loadingDelegate:loadingDelegate
                    callbackdelegate:delegate
                             success:success];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self requestFail:param
                             task:task
                            error:error
                  loadingDelegate:loadingDelegate
                 callbackdelegate:delegate
                             fail:fail];
            }];}
            break;
        default:
            break;
    }
    [self addTaskWithRequestId:[param requestId] task:session];
    return session;
}

/***
 * 添加上传表单信息
 * @param formData 要上传的表单信息
 * @param name 名字
 * @param fileInfor 表单信息
 */
-(void)appendPartWithFileInfor:(id<AFMultipartFormData>_Nonnull)formData
                          name:(NSString*)name
                     fileInfor:(FileInfor*_Nonnull)fileInfor{
    if(fileInfor){
        if([fileInfor.body isKindOfClass:[NSData class]]){
            [formData appendPartWithFileData:fileInfor.body name:name fileName:fileInfor.fileName mimeType:fileInfor.mimeType];
        }else if([fileInfor.body isKindOfClass:[NSInputStream class]]){
            [formData appendPartWithInputStream:fileInfor.body name:name fileName:fileInfor.fileName length:fileInfor.bodyContentLength mimeType:fileInfor.mimeType];
        }else if([fileInfor.body isKindOfClass:[NSURL class]]){
            [formData appendPartWithFileURL:fileInfor.body name:name fileName:fileInfor.fileName mimeType:fileInfor.mimeType error:fileInfor.error];
        }else{
            LazyNetLogWarn(@"\n");
            LazyNetLogWarn(@"添加表单数据的格式有误,表单中的body只能为(NSData,NSInputStream,NSURL)");
        }
    }
}

- (LazyBURLSessionTask *)doUpload:(RequestParam*)param
                             file:(NSString *)uploadFile
                 callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate{
    return [self doUpload:param file:uploadFile callbackdelegate:delegate progress:nil success:nil fail:nil];
}

- (LazyBURLSessionTask *)doUpload:(RequestParam*)param
                             file:(NSString *)uploadFile
                         progress:(RequestProgressBlock)progress
                          success:(RequestSuccessBlock)success
                             fail:(RequestFailBlock)fail{
    return [self doUpload:param file:uploadFile callbackdelegate:nil progress:progress success:success fail:fail];
}

/**
 * 单个文件上传
 * @param param 请求参数
 * @param uploadFile 要上传的文件
 * @param delegate 上传反馈代理
 * @param progress 上传进度反馈
 * @param success 上传成功反馈
 * @param fail 上传失败反馈
 */
- (LazyBURLSessionTask *)doUpload:(RequestParam*)param
                             file:(NSString *)uploadFile
                 callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate
                         progress:(RequestProgressBlock)progress
                          success:(RequestSuccessBlock)success
                             fail:(RequestFailBlock)fail {
    if([self isExistOfTask:[param requestId]]){
        LazyNetLogWarn(@"\n");
        LazyNetLogWarn(@"\n有一个相同的请求已存在,请等待其成功后在继续操作,请求Id: %@\n请求URL: %@\n请求params:%@\n\n",
                [param requestId],
                [param url],
                [JSONUtils dictionaryToJSONString:[param getBodys]]);
        return nil;
    }
    NSString *absoluteURL = [self absoluteURL:[param url]];
    if (absoluteURL == nil) {
        LazyNetLogWarn(@"URLString无效，无法生成URL。可能是URL中有中文，请尝试Encode URL");
        return nil;
    }
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:absoluteURL]];

    [_httpSessionManager.requestSerializer setTimeoutInterval:param.request_timeout];//设置超时
    [[param headers]enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //设置请求头
        [_httpSessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
        
    LazyBURLSessionTask *session = nil;
    session = [_httpSessionManager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        [self requestProgress:param progress:uploadProgress callbackdelegate:delegate progressBlock:progress];
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        [self removeTaskWithRequestId:[param requestId]];
        if(error){
            if(fail){
                fail([param requestId],error.code,error.localizedDescription);
            }
            if(delegate){
                [delegate onFail:[param requestId] withCode:error.code withMessage:error.localizedDescription];
            }
        }else{
            if(success){
                success([param requestId],response);
            }
            if(delegate){
                [delegate onSuccess:[param requestId] withResponse:response];
            }
        }
        
    }];
    [session resume];
    [self addTaskWithRequestId:[param requestId] task:session];
    return session;
}

- (LazyBURLSessionTask *)doDownload:(RequestParam*)param
                         saveToPath:(NSString *)saveToPath
                   callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate{
    return [self doDownload:param saveToPath:saveToPath callbackdelegate:delegate progress:nil success:nil fail:nil];
}

- (LazyBURLSessionTask *)doDownload:(RequestParam*)param
                         saveToPath:(NSString *)saveToPath
                           progress:(RequestProgressBlock)progressBlock
                            success:(RequestSuccessBlock)success
                               fail:(RequestFailBlock)fail {
    return  [self doDownload:param saveToPath:saveToPath callbackdelegate:nil progress:progressBlock success:success fail:fail];
}

/**
 * 下载方法
 * @param param 下载请求参数
 * @param saveToPath 下载文件保存路径
 * @param delegate 下载反馈的代理
 * @param progressBlock 下载进度反馈
 * @param success 下载成功反馈
 * @param fail 下载失败反馈
 */
- (LazyBURLSessionTask *)doDownload:(RequestParam*)param
                         saveToPath:(NSString *)saveToPath
                   callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate
                           progress:(RequestProgressBlock)progressBlock
                            success:(RequestSuccessBlock)success
                               fail:(RequestFailBlock)fail {
    if([self isExistOfTask:[param requestId]]){
        LazyNetLogWarn(@"\n");
        LazyNetLogWarn(@"\n有一个相同的请求已存在,请等待其成功后在继续操作,请求Id: %@\n请求URL: %@\n请求params:%@\n\n",
                [param requestId],
                [param url],
                [JSONUtils dictionaryToJSONString:[param getBodys]]);
        return nil;
    }
    NSURLRequest *downloadRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[param url]]];
    LazyBURLSessionTask *session = nil;
    session = [_httpSessionManager downloadTaskWithRequest:downloadRequest progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        [self requestProgress:param progress:downloadProgress callbackdelegate:delegate progressBlock:progressBlock];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:saveToPath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [self removeTaskWithRequestId:[param requestId]];
        if(error){
            if(fail){
                fail([param requestId],error.code,error.localizedDescription);
            }
            if(delegate){
                [delegate onFail:[param requestId] withCode:error.code withMessage:error.localizedDescription];
            }
        }else{
            if(success){
                success([param requestId],response);
            }
            if(delegate){
                [delegate onSuccess:[param requestId] withResponse:response];
            }
        }
    }];
    [session resume];//开始下载
    [self addTaskWithRequestId:[param requestId] task:session];
    return session;
}

/**请求进度反馈的处理*/
-(void)requestProgress:(RequestParam*)param
              progress:(NSProgress*)progress
      callbackdelegate:(id<ResponseCallbackProgressDelegate>)delegate
         progressBlock:(RequestProgressBlock)progressBlock
{
    if (progressBlock) {
        progressBlock([param requestId],progress.completedUnitCount, progress.totalUnitCount);
    }
    if(delegate){
        [delegate onProgress:[param requestId] withBytes:progress.completedUnitCount withTotalBytes:progress.totalUnitCount];
    }
}

/**请求成功的反馈处理*/
-(void)requestSuccess:(RequestParam*)param
                 task:(NSURLSessionDataTask *) task
             response:(id)responseObject
      responseProcess:(ResponseProcess*)responseProcess
      loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
           callbackdelegate:(id<ResponseCallbackDelegate>)delegate
                    success:(RequestSuccessBlock)success{
    [self removeTaskWithRequestId:[param requestId]];
    [self saveCache:param.cacheLoadType withRequestParam:param withResponse:responseObject withResponseProcess:responseProcess];
    LazyNetLogDebug(@"\n");
    LazyNetLogDebug(@"\n请求成功, 请求Id: %@\n请求URL: %@\n请求headers:%@\n请求params:%@\n返回response:%@\n\n",
              [param requestId],
              [[[task currentRequest] URL]absoluteString],
              [JSONUtils dictionaryToJSONString:[param headers]],
              [JSONUtils dictionaryToJSONString:[param getBodys]],
              [JSONUtils dictionaryToJSONString:responseObject]);
    id response=[responseProcess process:responseObject];
    if(loadingDelegate){
        [loadingDelegate onSuccess:[param requestId] withResponse:response];
    }
    if(success){
        success([param requestId],response);
    }
    if(delegate){
        [delegate onSuccess:[param requestId] withResponse:response];
    }
}

/**请求失败反馈的处理*/
-(void)requestFail:(RequestParam*)param
                 task:(NSURLSessionDataTask *) task
                error:(NSError*)error
      loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
     callbackdelegate:(id<ResponseCallbackDelegate>)delegate
                 fail:(RequestFailBlock)fail{
    [self removeTaskWithRequestId:[param requestId]];
    LazyNetLogWarn(@"\n");
    LazyNetLogWarn(@"\n请求失败, 请求Id: %@\n请求URL: %@\n请求headers:%@\n请求params:%@\n返回错误码:%@\n返回错误信息: %@\n",
            [param requestId],
            [[[task currentRequest] URL]absoluteString],
            [param headers],
            [param getBodys],
            [NSString stringWithFormat:@"%d",(int)error.code],
            error.localizedDescription);
    if(loadingDelegate){
        [loadingDelegate onFail:[param requestId] withCode:error.code withMessage:error.localizedDescription];
    }
    if(fail){
        fail([param requestId],error.code,error.localizedDescription);
    }
    if(delegate){
        [delegate onFail:[param requestId] withCode:error.code withMessage:error.localizedDescription];
    }
}

/**
 * 缓存加载方法
 * @param loadType 缓存加载类型
 * @param requestParam 请求参数
 * @param cacheBlock 加载缓存的block
 * @param delegate 加载缓存的代理(block和delegate一般只有一个存在)
 * @param responseProcess response加工工具
 */
-(void)loadCache:(HttpCacheLoadType)loadType
          withRequestParam:(RequestParam *)requestParam
            loadingDelegate:(id<LoadingViewDelegate>)loadingDelegate
  withRequestLoadCacheBlock:(RequestLoadCacheBlock)cacheBlock                      withCallbackDelegate:(id<ResponseCallbackDelegate>)delegate withResponseProcess:(ResponseProcess *)responseProcess{
    NSString*key=[[requestParam getUniqueId] toMD5];
    id response=nil;
    switch (loadType) {
        case NOT_USE_CACHE:
            break;
        case NOT_USE_CACHE_UPDATE_CACHE:
            break;
        case USE_CACHE_UPDATE_CACHE:
            response=[_cacheManager objectForKey:key];
            if(loadingDelegate){
                [loadingDelegate onLoadCache:[requestParam requestId] withResponse:[responseProcess process:response]];
            }
            if(cacheBlock){
                cacheBlock([requestParam requestId],[responseProcess process:response]);
            }
            if(delegate){
                [delegate onLoadCache:[requestParam requestId] withResponse:[responseProcess process:response]];
            }
            break;
        case USE_CACHE:
            response=[_cacheManager objectForKey:key];
            if(loadingDelegate){
                [loadingDelegate onLoadCache:[requestParam requestId] withResponse:[responseProcess process:response]];
            }
            if(cacheBlock){
                cacheBlock([requestParam requestId],[responseProcess process:response]);
            }
            if(delegate){
                [delegate onLoadCache:[requestParam requestId] withResponse:[responseProcess process:response]];
            }
            break;
        default:
            break;
    }
    //以下是日志打印的
    if(loadType==USE_CACHE||loadType==USE_CACHE_UPDATE_CACHE){
        LazyNetLogDebug(@"\n");
        LazyNetLogDebug(@"\n加载缓存成功, 请求Id: %@\n请求URL: %@\n请求headers:%@\n请求params:%@\n返回的缓存:%@\n\n",
                [requestParam requestId],
                [self absoluteURL:[requestParam url]],
                [requestParam headers],
                [requestParam getBodys],
                [JSONUtils dictionaryToJSONString:response]);
    }
}

/**
 * 保存htt请求缓存的方法
 * @param loadType 缓存加载类型
 * @param requestParam 请求参数
 * @param responseProcess response加工工具
 */
-(void)saveCache:(HttpCacheLoadType)loadType withRequestParam:(RequestParam*)requestParam withResponse:(id)response
      withResponseProcess:(ResponseProcess *)responseProcess{
    NSString*key=[[requestParam getUniqueId] toMD5];
    switch (loadType) {
        case NOT_USE_CACHE:
            break;
        case NOT_USE_CACHE_UPDATE_CACHE:
            [_cacheManager setObject:response forKey:key];
            break;
        case USE_CACHE_UPDATE_CACHE:
            [_cacheManager setObject:response forKey:key];
            break;
        case USE_CACHE:
            break;
        default:
            break;
    }
}

/**
 * 拼接地址得到全路径地址
 * @param url
 */
-(NSString*)absoluteURL:(nonnull NSString*)url{
    if(!_baseUrl||[_baseUrl isEqualToString:@""])return url;
    if([url isUrl])return url;
    return [[NSURL URLWithString:url relativeToURL:[NSURL URLWithString:_baseUrl]] absoluteString];
}

/***
 根据id判断任务是让已经存在
 */
-(BOOL)isExistOfTask:(NSString*)requestId{
    return [[_tasks allKeys]containsObject:requestId];
}

/**
 * 得到当前任务数量
 */
-(NSUInteger)taskCount{
    return [_tasks count];
}

/**
 * 添加任务
 * @param requestId 请求id
 * @param task 请求任务
 */
-(void)addTaskWithRequestId:(NSString*)requestId task:(LazyBURLSessionTask*)task{
    if(!task)return;
    [_tasks setObject:task forKey:requestId];
}

/**
 * 删除对应的任务
 *
 * @param requestId 请求id
 */
-(void)removeTaskWithRequestId:(NSString*)requestId {
    if(!requestId)return;
    @synchronized(self) {
        [_tasks removeObjectForKey:requestId];
    };
}

/**
 * 获取对应的任务
 * @param requestId 请求id
 */
-(LazyBURLSessionTask*)getTaskWithRequestId:(NSString*)requestId{
    return [_tasks objectForKey:requestId];
}

-(void)cancelRequestWithId:(NSString *)requestId{
    if(!requestId)return;
    @synchronized(self) {
        LazyBURLSessionTask*task=[_tasks objectForKey:requestId];
        [task cancel];
        [_tasks removeObjectForKey:requestId];
    };
}

-(void)cancelAllRequest{
    @synchronized(self) {
        [_tasks enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, LazyBURLSessionTask* _Nonnull task, BOOL * _Nonnull stop) {
            if ([task isKindOfClass:[LazyBURLSessionTask class]]) {
                [task cancel];
            }
        }];
        [_tasks removeAllObjects];
    };
}

/***
 清理缓存
 */
-(void)clearCache{
    if(_cacheManager){
        [_cacheManager removeAllObjects];
    }
}

@end
