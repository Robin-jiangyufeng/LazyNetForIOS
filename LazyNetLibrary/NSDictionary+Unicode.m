//
//  NSDictionary+Unicode.m
//  WeiJiFIN
//
//  Created by 江钰锋 on 2017/1/13.
//  Copyright © 2017年 WeiJi. All rights reserved.
//

#import "NSDictionary+Unicode.h"

@implementation NSDictionary(Unicode)
- (NSString*)my_description {
    NSString *desc = [self my_description];
    desc = [NSString stringWithCString:[desc cStringUsingEncoding:NSUTF8StringEncoding] encoding:NSNonLossyASCIIStringEncoding];
    return desc;
}
@end
