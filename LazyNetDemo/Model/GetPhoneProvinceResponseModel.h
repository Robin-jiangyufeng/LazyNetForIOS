//
//  GetPhoneProvinceResponseModel.h
//  LazyNetForIOS
//
//  Created by 江钰锋 on 2017/1/18.
//  Copyright © 2017年 jiangyufeng. All rights reserved.
//

#import "BaseResponseModel.h"
#import "PhoneProvinceModel.h"
@interface GetPhoneProvinceResponseModel : BaseResponseModel
@property (copy, nonatomic) PhoneProvinceModel *result;
@end
