//
//  ViewController.m
//  LazyNetDemo
//
//  Created by 江钰锋 on 2017/1/13.
//  Copyright © 2017年 jiangyufeng. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self loadLayout];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadLayout{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"GET请求" forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage dp_imageWithColor:UIColorFromRGB(0xec4c4d)] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(toHttpGet) forControlEvents:UIControlEventTouchUpInside];
    button.layer.cornerRadius = 5;
    button.layer.masksToBounds = YES;
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.top.equalTo(self.view).offset(50);
        make.width.equalTo(@(SCREEN_WIDTH - 50));
        make.height.equalTo(@44);
    }];
}

-(void)toHttpGet{
    
}
@end
