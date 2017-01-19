//
//  QQXiongJIResponseModel.h
//  LazyNetForIOS
//
//  Created by 江钰锋 on 2017/1/19.
//  Copyright © 2017年 jiangyufeng. All rights reserved.
//

#import "BaseResponseModel.h"
#import "QQXiongJIDataModel.h"

@interface QQXiongJIResponseModel : BaseResponseModel
@property (nonatomic,strong) QQXiongJIDataModel *result;
@end
