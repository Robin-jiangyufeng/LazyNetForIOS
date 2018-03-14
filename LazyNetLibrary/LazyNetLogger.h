//
//  LazyNetLogger.h
//  TFPBusinessSDK
//  网络日志输出工具
//  Created by jiangyufeng on 2017/7/27.
//  Copyright © 2017年 Transfar. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, LazyNetLogLevel){
    
    LazyNetLogError      = 0,
    
    LazyNetLogWarning    = 1,
    
    LazyNetLogInfo       = 2,
    
    LazyNetLogDebug      = 3,
    
    LazyNetLogVerbose    = 4
};

#define LAZY_LOG_MACRO(level, frmt, ...)              \
           [LazyNetLogger log:level                   \
                       format:(frmt), ##__VA_ARGS__]
#define Lazy_LOG_MAYBE(level,frmt,...) LAZY_LOG_MACRO(level,@"[%@][Method:%s][Line:%d] ===============>%@", [[NSString stringWithUTF8String:__FILE__] lastPathComponent], __FUNCTION__,__LINE__, [NSString stringWithFormat:(frmt), ##__VA_ARGS__])

#ifdef DEBUG
#define LazyNetLogError(frmt, ...)   Lazy_LOG_MAYBE( LazyNetLogError,frmt, ##__VA_ARGS__)
#define LazyNetLogWarn(frmt, ...)    Lazy_LOG_MAYBE( LazyNetLogWarning,frmt, ##__VA_ARGS__)
#define LazyNetLogInfo(frmt, ...)    Lazy_LOG_MAYBE( LazyNetLogInfo,frmt, ##__VA_ARGS__)
#define LazyNetLogDebug(frmt, ...)   Lazy_LOG_MAYBE( LazyNetLogDebug,frmt, ##__VA_ARGS__)
#define LazyNetLogVerbose(frmt, ...) Lazy_LOG_MAYBE( LazyNetLogVerbose,frmt, ##__VA_ARGS__)
#else
#define LazyNetLogError(frmt, ... )
#define LazyNetLogWarn(frmt, ... )
#define LazyNetLogInfo(frmt, ... )
#define LazyNetLogDebug(frmt, ... )
#define LazyNetLogVerbose(frmt, ... )
#endif

@interface LazyNetLogger : NSObject
/**日志输出*/
+ (void)log:(LazyNetLogLevel)level
     format:(NSString *)format,... __attribute__ ((format (__NSString__, 2, 3)));
@end
