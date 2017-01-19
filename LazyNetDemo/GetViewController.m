//
//  GetViewController.m
//  LazyNetForIOS
//
//  Created by 江钰锋 on 2017/1/18.
//  Copyright © 2017年 jiangyufeng. All rights reserved.
//

#import "GetViewController.h"
#import "LazyHttpClient.h"
#import "LazyHttpClient+WJCustom.h"
#import "RequestParam.h"
#import "GetPhoneProvinceResponseModel.h"
NSString* const url=@"http://apis.juhe.cn";
@interface GetViewController ()

@end

@implementation GetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LazyHttpClient getInstance] updateBaseUrl:url];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)buttonPress:(id)sender{
    RequestParam* param=[[RequestParam alloc]initWithUrl:@"/mobile/get"];
    [param addBody:self.phoneText.text withKey:@"phone"];
    [[LazyHttpClient getInstance]wj_GET:self param:param responseClazz:[GetPhoneProvinceResponseModel class] loadingDelegate:nil loadCache:nil success:^(NSString *requestId, id response) {
        GetPhoneProvinceResponseModel*model=response;
        self.lable.text=model.description;
    } fail:^(NSString *requestId, NSString *errorCode, NSString *errorMsaaege) {
        self.lable.text=[NSString stringWithFormat:@"获取手机号归属地错误,错误原因:%@",errorMsaaege];
    }];
}


@end
