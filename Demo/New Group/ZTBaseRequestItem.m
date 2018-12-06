//
//  ZTBaseRequestItem.m
//  ZTStore
//
//  Created by Jason Hu on 2018/8/14.
//  Copyright © 2018年 ZhengTian. All rights reserved.
//

#import "ZTBaseRequestItem.h"
#import "JHGHttpEngine.h"


@interface ZTBaseRequestItem()

{
    BOOL _noToken;
}

@end


@implementation ZTBaseRequestItem
- (ZTBaseRequestItem *)setNoToken
{
    _noToken = YES;
    return self;
}

// 完整url会自动拼接
+ (instancetype)itemWithUrl:(NSString *)url
                     params:(NSDictionary *)params
                    success:(ZTRequestSuccessBlock)success
                    failure:(ZTRequestFailureBlock)failure
{
    return [self itemWithUrl:url specifyDomain:nil params:params success:success failure:failure];
}

// 可指定域名的方法
+ (instancetype)itemWithUrl:(NSString *)url
              specifyDomain:(NSString *)domainName
                     params:(NSDictionary *)params
                    success:(ZTRequestSuccessBlock)success
                    failure:(ZTRequestFailureBlock)failure
{
    ZTBaseRequestItem *item = [self new];
    
    // 统一处理
    // 域名
    if (!domainName.length) {
        domainName = [self getCurrentDomain];
    }
    
    // 拼接url
    item.urlString = [domainName stringByAppendingString:url];
    
    item.paramsDic = params;
    
    
    // 请求成功回调
    @weakify(item);
    item.successBlock = ^(NSDictionary *responseData, NSURLSessionDataTask *task) {
        @strongify(item);
        if (success) {
            ZTBaseResponseModel *responseModel = [[ZTBaseResponseModel alloc] initWithDict:responseData];
            item.responseModel = responseModel;
            NSDictionary *dict = [responseData objectForKey:@"data"];
            if (!dict) {
                dict = responseData;
            }
            success(dict, responseModel, item);
        }
    };
    
    // 请求失败回调
    item.failureBlock = ^(NSDictionary *responseData, NSError *error, NSURLSessionDataTask *task) {
        @strongify(item);
        if (failure) {
            failure(responseData, error, item);
        }
    };
    return item;
}

// 发送请求
- (NSURLSessionDataTask *)sendRequest
{
 
    // 处理入参
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.paramsDic) {
        [dict setValuesForKeysWithDictionary:self.paramsDic];
    }
//    [dict setObject:@"eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.W10.dF26uM2kVQadC0QYogwf_pX2qurUqdPQQecTFOV2HcY" forKey:@"credit"];
    
//    if (!_noToken) {
//        // 根据业务需求拼接token
//
//        LocalUserDefaults *userDefault = [LocalUserDefaults sharedManager];
//        if (userDefault.token.length) {
//            [dict setObject:userDefault.token forKey:@"token"];
//        } else {
//            // 未登录或登录失效
//            UIViewController *vc = self.vcRelated;
//            if (!vc) {
//                [[ViewControllerUtil new] getCurrentVC];
//            }
//            [ZTUserLoginHelper presentLoginVCWithCurrentVC:vc];
//
//
//            if (self.failureBlock) {
//                self.failureBlock(nil, nil, nil);
//            }
//        }
//    }
    
    self.finalParamDict = dict;
    
    // 发起请求
    NSURLSessionDataTask *task = [[JHGHttpEngine sharedInstance] sendAsynchronousWithRequestItem:self];
    return task;
}

+ (NSString *)getCurrentDomain
{
    // TODO: 域名切换管理
//    return BaseServiceURL;
    return nil;
}




@end
