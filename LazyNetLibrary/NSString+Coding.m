//
//  NSString+MD5.m
//  WeiJiFIN
//
//  Created by 江钰锋 on 2017/1/9.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "NSString+Coding.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString(Coding)

-(instancetype)toMD5{
    if (self == nil || [self length] == 0) {
        return nil;
    }
    unsigned char digest[CC_MD5_DIGEST_LENGTH], i;
    CC_MD5([self UTF8String], (int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding], digest);
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x", (int)(digest[i])];
    }
    return [ms copy];
}

- (BOOL)isUrl
{
    if(self == nil)
        return NO;
    NSString *url;
    if (self.length>4 && [[self substringToIndex:4] isEqualToString:@"www."]) {
        url = [NSString stringWithFormat:@"http://%@",self];
    }else{
        url = self;
    }
    if(url&& ([url hasPrefix:@"http"]||[url hasPrefix:@"https"])) {
        return YES;
    }
    return NO;
}

@end
