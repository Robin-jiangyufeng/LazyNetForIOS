//
//  GetViewController.h
//  LazyNetDemo
//
//  Created by 江钰锋 on 2017/1/18.
//  Copyright © 2017年 jiangyufeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GetViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *buttom;
@property (weak, nonatomic) IBOutlet UITextField *phoneText;
@property (weak, nonatomic) IBOutlet UILabel *lable;
- (IBAction)buttonPress:(id)sender;
- (IBAction)close;
@end
