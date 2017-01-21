//
//  ReuqestParam.m
//  LazyNetLibrary
//  请求需要的相关参数
//  Created by 江钰锋 on 2017/1/9.
//  Copyright © 2017年 jiangyufeng. All rights reserved.
//

#import "RequestParam.h"
#import "JSONUtils.h"

@implementation RequestParam

-(instancetype)initWithUrl:(NSString *)url{
    return [self initWithRequestId:nil withUrl:url];
}

-(instancetype)initWithRequestId:(NSString*)requestId withUrl:(NSString*)url{
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
        _request_timeout=10;
        _cacheLoadType=NOT_USE_CACHE;
    }
    return self;
}

-(NSString *)requestId{
    return _requestId;
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
 * @param
 */
-(void)setHeader:(NSString*)values withKey:(NSString*)key{
    [_heasers setValue:values forKey:key];
}

/**
 * 设置请求头，此方法会替换之前设置的所有请求头
 * @param headers 请求头列表
 *
 */
-(void)setHeaders:(NSDictionary*)headers{
    [_heasers removeAllObjects];
    [_heasers setDictionary:headers];
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
-(void)addHeaders:(NSDictionary*)headers{
    if(!headers)return;
    [_heasers setDictionary:headers];
}

/**
 * 添加请求参数(健值对方式)
 * @param values
 * @param key
 */
-(void)addBody:(NSString*)values withKey:(NSString*)key{
    [_bodys setValue:values forKey:key];
}

/**
 * 添加请求方式(字典方式)
 * @param bodys
 */
-(void)addBodys:(NSDictionary*)bodys{
    if(!bodys)return;
    [_bodys setDictionary:bodys];
}

/**
 * 添加请求方式(普通对象方式)
 *
 */
-(void)addBodyOfObject:(id)bodys{
    if(!bodys)return;
    [self addBodys:[JSONUtils objectToDictionary:bodys]];
}
@end
