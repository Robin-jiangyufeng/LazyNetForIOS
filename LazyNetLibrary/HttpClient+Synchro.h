//
//  HttpClient+Synchro.h
//  TFPBusinessSDK
//  同步的http请求
//  Created by jiangyufeng on 2017/9/6.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "HttpClient.h"
@interface SyncResponse : NSObject
@property(strong,nonatomic)NSURLSessionDataTask*task;
/**请求id*/
@property(copy,nonatomic)NSString*requestId;
@property (strong, nonatomic) id responseModel;
@property (copy, nonatomic) NSError *error;
@end
@interface HttpClient (Synchro)
/***
 同步的get请求
 @param 请求参数
 @responseProcess 请求反馈信息加工器
 */
-(SyncResponse*)doSyncGet:(RequestParam*)param
          responseProcess:(ResponseProcess*)responseProcess;

/***
 同步的post请求
 @param 请求参数
 @responseProcess 请求反馈信息加工器
 */
-(SyncResponse*)doSyncPost:(RequestParam*)param
          responseProcess:(ResponseProcess*)responseProcess;

@end
