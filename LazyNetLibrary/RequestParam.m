//
//  RequestParam.m
//  WeiJiFIN
//  请求需要的相关参数
//  Created by 江钰锋 on 2017/1/9.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "RequestParam.h"
#import "JSONUtils.h"
@implementation FileInfor
@end
@interface RequestParam ()

@end
@implementation RequestParam

-(instancetype)initWithUrl:(nonnull NSString *)url{
    return [self initWithRequestId:nil withUrl:url];
}

-(instancetype)initWithRequestId:(NSString*)requestId
                         withUrl:(nonnull NSString*)url{
    self=[super init];
    if (self) {
        _url=url;
        if(requestId){
            _requestId=requestId;
        }else{
            _requestId=_url;
        }
        _heasers=[[NSMutableDictionary alloc]init];
        _bodys=[[NSMutableDictionary alloc]init];
        _files=[[NSMutableDictionary alloc]init];
        _request_timeout=15;
        _cacheLoadType=NOT_USE_CACHE;
    }
    return self;
}

-(NSString *)requestId{
    return _requestId;
}

-(void)setRequestId:(nonnull NSString*)requestId{
    _requestId=requestId;
}

-(NSString *)getUniqueId{
    return _requestId;
}

/**得到url连接*/
-(NSString*)url{
    return _url;
}

/**获取请求头*/
-(NSDictionary*)headers{
    return _heasers;
}

/**
 * 设置单个请求头(会替换对应的key)
 * @param values values
 * @param key key
 */
-(void)setHeader:(nonnull NSString*)values withKey:(nonnull NSString*)key{
    [_heasers setValue:values forKey:key];
}

/**
 * 设置请求头，此方法会替换之前设置的所有请求头
 * @param headers 请求头列表
 *
 */
-(void)setHeaders:(nonnull NSDictionary*)headers{
    [_heasers removeAllObjects];
    [_heasers setDictionary:headers];
}

-(NSDictionary *)files{
    return _files;
}

-(void)addFile:(nonnull NSString *)name fileInfor:(FileInfor *)fileInfor{
    if(_files){
        [_files setValue:fileInfor forKey:name];
    }
}

-(void)addFile:(NSString *)name
      fileName:(NSString *)fileName
      mimeType:(NSString *)mimeType
          body:(id)body
        length:(unsigned long long)length
         error:(NSError *__autoreleasing)error{
    if(_files){
        FileInfor*fileInfor=[[FileInfor alloc]init];
        fileInfor.fileName=fileName;
        fileInfor.mimeType=mimeType;
        fileInfor.body=body;
        fileInfor.bodyContentLength=length;
        fileInfor.error=&(error);
        [_files setValue:fileInfor forKey:name];
    }
}

-(void)addFiles:(nonnull NSDictionary *)files{
    if(_files){
        [_files setDictionary:files];
    }
}

-(NSDictionary*)getBodys{
    return _bodys;
}

/**获取请求体*/
-(id)bodys{
    return _bodys;
}

/**
 * 添加请求头(不会替换)
 * @param headers 请求头列表
 */
-(void)addHeaders:(nonnull NSDictionary*)headers{
    if(!headers)return;
    [_heasers addEntriesFromDictionary:headers];
}

/**
 * 添加请求参数(健值对方式)
 * @param value 请求的value
 * @param key 请求去参数的key
 */
-(void)addBody:(nonnull id)value withKey:(nonnull NSString*)key{
    [_bodys setValue:value forKey:key];
}

/**
 * 添加请求方式(字典方式)
 * @param bodys 请求bodys
 */
-(void)addBodys:(nonnull NSDictionary*)bodys{
    if(!bodys)return;
    [_bodys addEntriesFromDictionary:bodys];
}

/**
 * 添加请求方式(普通对象方式)
 *
 */
-(void)addBodyOfObject:(nonnull id)bodys{
    if(!bodys)return;
    [self addBodys:[JSONUtils objectToDictionary:bodys]];
}
@end
