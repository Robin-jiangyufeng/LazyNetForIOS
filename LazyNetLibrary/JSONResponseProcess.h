//
//  JSONResponseProcess.h
//  WeiJiFIN
//  把返回的json类型数据直接加工成对象
//  Created by 江钰锋 on 2017/1/11.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "ResponseProcess.h"

@interface JSONResponseProcess : ResponseProcess{
    /**成功请求到服务器数据，且业务逻辑正确的情况*/
    Class _successClazz;
}
/**json类型数据加工器初始化方法*/
-(instancetype)initWithSuccessClass:(Class)successClazz;

@end
