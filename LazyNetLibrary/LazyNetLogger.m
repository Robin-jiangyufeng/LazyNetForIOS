//
//  LazyNetLogger.m
//  TFPBusinessSDK
//  网络日志输出工具
//  Created by jiangyufeng on 2017/7/27.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import "LazyNetLogger.h"

@implementation LazyNetLogger
+ (void)log:(LazyNetLogLevel)level
     format:(NSString *)format, ...
{
    va_list args;
    if (format)
    {
        va_start(args, format);
        NSString *logMsg = [[NSString alloc] initWithFormat:format arguments:args];
        if(level==LazyNetLogError){
            NSLog(logMsg,nil);
        }else if(level==LazyNetLogWarning){
            NSLog(logMsg,nil);
        }else if(level==LazyNetLogInfo){
            NSLog(logMsg,nil);
        }else if(level==LazyNetLogDebug){
            NSLog(logMsg,nil);
        }else if(level==LazyNetLogVerbose){
            NSLog(logMsg,nil);
        }
        va_end(args);
    }
    
}
@end
