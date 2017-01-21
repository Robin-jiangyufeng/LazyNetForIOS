//
//  JSONResponseProcess.h
//  LazyNetLibrary
//  把返回的json类型数据直接加工成对象
//  Created by 江钰锋 on 2017/1/11.
//  Copyright © 2017年 jiangyufeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ResponseProcess.h"
#import "JSONResponseProcess.h"

@interface JSONResponseProcess : ResponseProcess{
    /**需要转换的类型*/
    Class _clazz;
}
/**json类型数据加工器初始化方法*/
-(instancetype)initWithClass:(Class)clazz;

@end
