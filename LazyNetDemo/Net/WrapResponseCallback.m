//
//  WrapResponseCallback.m
//  WeiJiFIN
//
//  Created by 江钰锋 on 2017/1/12.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "WrapResponseCallback.h"

@implementation WrapResponseCallback

-(instancetype)init:(UIViewController*)VC
       withDelegate:(id<WJResponseCallbackDelegate>)delegate{
    self=[super init];
    if(self){
        _viewController=VC;
        _callbackDelegate=delegate;
    }
    return self;
}

-(instancetype)init:(UIViewController*)VC
          withCache:(WJRequestLoadCacheBlock)loadCacheBolock success:(WJRequestSuccessBlock)success fail:(WJRequestFailBlock)fail{
    self=[super init];
    if(self){
        _viewController=VC;
        _loadCacheBlock=loadCacheBolock;
        _successBlock=success;
        _failBlock=fail;
    }
    return self;
}

-(RequestLoadCacheBlock)loadCacheBlock{
    RequestLoadCacheBlock block=^(NSString*requestId,id response){
        [self onLoadCache:requestId withResponse:response];
    };
    return block;
}

-(RequestSuccessBlock)successBlock{
    RequestSuccessBlock block=^(NSString*requestId,id response){
        [self onSuccess:requestId withResponse:response];
    };
    return block;
}

-(RequestFailBlock)failBlock{
    RequestFailBlock block=^(NSString*requestId,NSInteger errorCode,NSString*errorMsaaege){
        [self onFail:requestId withCode:errorCode withMessage:errorMsaaege];
    };
    return block;
}

-(void)onLoadCache:(NSString *)requestId withResponse:(id)response{
    if (_callbackDelegate||_loadCacheBlock) {
        if (response) {
            if ([response isKindOfClass:[BaseResponseModel class]]) {
                BaseResponseModel* model = (BaseResponseModel*)response;
                if ((model.resultcode&&[model.resultcode isEqualToString:@"200"])||[model.error_code isEqualToString:@"0"]) {
                    if (![model isEmpty]) {//如果数据不是空的
                        if(_callbackDelegate){
                            [_callbackDelegate onLoadCache:requestId withResponse:response];
                        }
                    }
                }
            }
        }
    }
}
-(void)onSuccess:(NSString *)requestId withResponse:(id)response{
    if (_callbackDelegate||(_successBlock&&_failBlock)) {
        if (response) {
            if ([response isKindOfClass: [BaseResponseModel class]]) {
                BaseResponseModel*model = (BaseResponseModel*)response;
                if ((model.resultcode&&[model.resultcode isEqualToString:@"200"])||[model.error_code isEqualToString:@"0"]) {
                    if ([model isEmpty ]) {//如果数据是空的
                        if(_callbackDelegate){
                          [_callbackDelegate onFail:requestId withCode:ERROR_EMPTY_DATA withMessage:@"后台返回的数据为空"];
                        }
                        if(_failBlock){
                          _failBlock(requestId,ERROR_EMPTY_DATA,@"后台返回的数据为空");
                        }
                    } else {
                        if(_callbackDelegate){
                          [_callbackDelegate onSuccess:requestId withResponse:response];
                        }
                        if(_successBlock){
                            _successBlock(requestId,response);
                        }
                    }
                } else {
                    [self onSuccessErrorManage:requestId code:model.resultcode error:model.reason];
                }
            } else {
                if(_callbackDelegate){
                    [_callbackDelegate onFail:requestId
                                     withCode:ERROR_DIFFER_DATA withMessage:@"返回数据与app端定义数据不一致"];
                }
                if(_failBlock){
                    _failBlock(requestId,ERROR_DIFFER_DATA,@"返回数据与app端定义数据不一致");
                }
            }
        } else {
            if(_callbackDelegate){
                [_callbackDelegate onFail:requestId withCode:ERROR_EMPTY_DATA withMessage:@"后台返回的数据为空"];
            }
            if(_failBlock){
                _failBlock(requestId,ERROR_EMPTY_DATA,@"后台返回的数据为空");
            }
        }
    }
}

-(void)onFail:(NSString *)requestId withCode:(NSInteger)errorCode withMessage:(NSString *)errorMsaaege{
    NSString*error=[WJHttpErrorCodeParseHelps getMessageByStatusCode:errorCode];
    if(!error||error.length<=0){
        error=errorMsaaege;
    }
    if(_callbackDelegate){
        [_callbackDelegate onFail:requestId withCode:[NSString stringWithFormat:@"%d", (int)errorCode] withMessage:error];
    }
    if(_failBlock){
        _failBlock(requestId,[NSString stringWithFormat:@"%d", (int)errorCode],error);
    }
}

/**
 * 获取到数据后错误的处理
 *
 * @param requestId
 * @param statusCode
 * @param error
 */
-(void)onSuccessErrorManage:(NSString*)requestId code:(NSString*)statusCode error:(NSString*) error{
    if(_callbackDelegate){
        [_callbackDelegate onFail:requestId withCode:statusCode withMessage:error];
    }
    if(_failBlock){
        _failBlock(requestId,statusCode,error);
    }
}
@end
