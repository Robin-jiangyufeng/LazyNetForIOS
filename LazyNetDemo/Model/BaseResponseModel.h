//
//  BaseResponseModel.h
//  LazyNetDemo
//
//  Created by 江钰锋 on 2016/10/18.
//  Copyright © 2016年 jiangyufeng. All rights reserved.
//

@interface BaseResponseModel : NSObject
/**返回码(200表示成功其余均表示失败)*/
@property (copy, nonatomic) NSString *resultcode;
/**返回码描述信息*/
@property (copy, nonatomic) NSString *reason;
/**0为成功*/
@property (copy, nonatomic) NSString *error_code;
/**判断返回数据是否为空*/
-(BOOL)isEmpty;
@end
