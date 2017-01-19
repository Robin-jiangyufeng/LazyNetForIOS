//
//  WJHttpErrorCodeParseHelps.m
//  WeiJiFIN
//  http请求错误码解析器
//  Created by 江钰锋 on 2017/1/12.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "WJHttpErrorCodeParseHelps.h"

@implementation WJHttpErrorCodeParseHelps

+(NSString *)getMessageByStatusCode:(NSInteger)statusCode{
    switch (statusCode) {
        case NSURLErrorCancelled:
            return nil;
        case NSURLErrorTimedOut:
            return @"网络请求超时";
        case NSURLErrorNotConnectedToInternet:
            return @"网络不给力呀~";
        case NSURLErrorCannotConnectToHost:
            return @"网络不给力呀~";
        default:
            return nil;
    }
}
@end
