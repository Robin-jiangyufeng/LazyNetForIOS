//
//  LazyHttpClient+LazySynchro.m
//  TFPBusinessSDK
//
//  Created by jiangyufeng on 2017/9/6.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "LazyHttpClient+LazySynchro.h"

@implementation LazyHttpClient (LazySynchro)

-(SyncResponse*)SYNC_GET_JSON:(NSString *)VCId param:(RequestParam *)param responseProcess:(JSONResponseProcess *)responseProcess{
    SyncResponse*response=[self doSyncGet:param responseProcess:responseProcess ];
    if(response&&response.task){
        [self addViewControllerTask:VCId withRequestId:[param requestId]];
    }
    return response;
}

-(SyncResponse *)SYNC_POST_JSON:(NSString *)VCId param:(RequestParam *)param responseProcess:(JSONResponseProcess *)responseProcess{
    SyncResponse*response=[self doSyncPost:param responseProcess:responseProcess ];
    if(response&&response.task){
        [self addViewControllerTask:VCId withRequestId:[param requestId]];
    }
    return response;
}
@end
