//
//  WrapResponseCallback.h
//  LazyNetForIOS
//
//  Created by 江钰锋 on 2017/1/12.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseCallback.h"
#import "BaseResponseModel.h"
#import "WJHttpErrorCodeParseHelps.h"
/***
 * 加载缓存的block
 * @param requestId 对应的请求id
 * @param response 返回数据
 */
typedef void (^WJRequestLoadCacheBlock)(NSString*requestId,id response);

/***
 * 请求成功反馈的block
 * @param requestId 对应的请求id
 * @param response 返回数据
 */
typedef void (^WJRequestSuccessBlock)(NSString*requestId,id response);
/**
 * 请求失败反馈的方法
 * @param requestId 对应的请求id
 * @param errorCode 返回错误码
 * @param errorMsaaege 返回的错误信息
 */
typedef void (^WJRequestFailBlock)(NSString*requestId,NSString* errorCode,NSString*errorMsaaege);

@protocol WJResponseCallbackDelegate<NSObject>

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
- (void)onFail:(NSString*)requestId withCode:(NSString*)errorCode withMessage:(NSString*)errorMsaaege;

@end
@interface WrapResponseCallback :NSObject<ResponseCallbackDelegate>{
    UIViewController*_viewController;
    /**自定义的回调代理*/
    id<WJResponseCallbackDelegate> _callbackDelegate;
    /**自定义的加载缓存回调*/
    WJRequestLoadCacheBlock _loadCacheBlock;
    /**自定义的成功回调*/
    WJRequestSuccessBlock _successBlock;
    /**自定义的失败回调*/
    WJRequestFailBlock _failBlock;
}
-(instancetype)init:(UIViewController*)VC withDelegate:(id<WJResponseCallbackDelegate>)delegate;

-(instancetype)init:(UIViewController*)VC
              withCache:(WJRequestLoadCacheBlock)loadCacheBolock
                     success:(WJRequestSuccessBlock)success
                        fail:(WJRequestFailBlock)fail;

-(RequestLoadCacheBlock)loadCacheBlock;
-(RequestSuccessBlock)successBlock;
-(RequestFailBlock)failBlock;
@end
