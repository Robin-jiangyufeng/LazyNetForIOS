//
//  PostViewController.m
//  LazyNetDemo
//
//  Created by 江钰锋 on 2017/1/19.
//  Copyright © 2017年 jiangyufeng. All rights reserved.
//

#import "PostViewController.h"
#import "LazyHttpClient.h"
#import "LazyHttpClient+WJCustom.h"
#import "RequestParam.h"
#import "QQXiongJIResponseModel.h"
#import "JSONUtils.h"
NSString* const abUrl=@"http://japi.juhe.cn";
@interface PostViewController ()

@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[LazyHttpClient getInstance] updateBaseUrl:abUrl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)buttonPress:(id)sender{
    NSString*theUrl=@"/qqevaluate/qq?key=780e8bced58c6203140b858d7aa2644c&qq=";
    RequestParam* param=[[RequestParam alloc]initWithUrl:[NSString stringWithFormat:@"%@%@",theUrl, self.phoneText.text]];
//    [param addBody:self.phoneText.text withKey:@"qq"];
//    [param addBody:@"780e8bced58c6203140b858d7aa2644c" withKey:@"key"];
    [[LazyHttpClient getInstance]wj_POST:self param:param responseClazz:[QQXiongJIResponseModel class] loadingDelegate:nil loadCache:nil success:^(NSString *requestId, id response) {
        QQXiongJIResponseModel*model=response;
        self.lable.text=[JSONUtils objectToJSONString:model];
    } fail:^(NSString *requestId, NSString *errorCode, NSString *errorMsaaege) {
        self.lable.text=[NSString stringWithFormat:@"调用QQ测凶吉接口错误,错误原因:%@",errorMsaaege];
    }];
}

-(void)close{
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
