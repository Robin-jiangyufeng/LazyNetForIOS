//
//  LazyHttpClient+LazySynchro.h
//  TFPBusinessSDK
//
//  Created by jiangyufeng on 2017/9/6.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "LazyHttpClient.h"
#import "HttpClient+Synchro.h"
@interface LazyHttpClient (LazySynchro)
/**
 * 同步的json格式的get请求方法
 * @param VCId ViewController唯一id
 * @param param 请求参数
 * @param responseProcess 反馈加工处理器
 */
-(SyncResponse*)SYNC_GET_JSON:(NSString*)VCId
               param:(RequestParam*)param
     responseProcess:(JSONResponseProcess*)responseProcess;

/**
 * 同步的json格式的post请求方法
 * @param VCId ViewController唯一id
 * @param param 请求参数
 * @param responseProcess 反馈加工处理器
 */
-(SyncResponse*)SYNC_POST_JSON:(NSString*)VCId
                param:(RequestParam*)param
      responseProcess:(JSONResponseProcess*)responseProcess;
@end
