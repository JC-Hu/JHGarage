//
//  ZTBaseResponseModel.h
//  ZTStore
//
//  Created by Jason Hu on 2018/8/18.
//  Copyright © 2018年 ZhengTian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZTBaseResponseModel : NSObject

@property (nonatomic, strong) NSDictionary *originalData;
@property (nonatomic, assign) int code;  // 200成功, 401登录过期 - 清除token
@property (nonatomic, copy) NSString *msg;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (BOOL)isOK;

@end
