//
//  JSONResponseProcess.m
//  LazyNetLibrary
//  把返回的json类型数据直接加工成对象
//  Created by 江钰锋 on 2017/1/11.
//  Copyright © 2017年 jiangyufeng. All rights reserved.
//

#import "JSONResponseProcess.h"
#import "JSONUtils.h"

@implementation JSONResponseProcess

-(instancetype)initWithClass:(Class)clazz{
    self=[super init];
    if(self){
        _clazz=clazz;
    }
    return self;
}

-(id)process:(id)response{
    if(_clazz){
       return [JSONUtils jsonToObject:response withClass:_clazz];
    }
    return [super process:response];
}
@end
