//
//  JSONResponseProcess.m
//  WeiJiFIN
//  把返回的json类型数据直接加工成对象
//  Created by 江钰锋 on 2017/1/11.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "JSONResponseProcess.h"
#import "JSONUtils.h"

@implementation JSONResponseProcess

-(instancetype)initWithSuccessClass:(Class)successClazz{
    self=[super init];
    if(self){
        _successClazz=successClazz;
    }
    return self;
}

-(id)process:(id)response{
    if(_successClazz){
       return [JSONUtils jsonToObject:response withClass:_successClazz];
    }
    return [super process:response];
}
@end
