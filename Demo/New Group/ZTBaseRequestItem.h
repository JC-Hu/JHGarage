//
//  Created by Jason Hu on 2018/8/14.
//

#import "JHGRequestItem.h"

#import "ZTBaseResponseModel.h"

@class ZTBaseRequestItem;

typedef void(^ZTRequestSuccessBlock)(NSDictionary *jsonDict, ZTBaseResponseModel *response, ZTBaseRequestItem *ztItem);

typedef void(^ZTRequestFailureBlock)(NSDictionary *jsonDict, NSError *error, ZTBaseRequestItem *ztItem);



@interface ZTBaseRequestItem : JHGRequestItem

@property (nonatomic, strong) ZTBaseResponseModel *responseModel;
@property (nonatomic, strong) NSURLSessionDataTask *task;

/**
 生成item
 生成后调用sendRequest:方法发送请求
 
 @param url 完整url会自动拼接
 @param params 入参，统一添加token和credit
 @param success 请求成功回调，数据是否正确使用response.isOK判断
 @param failure 请求失败回调
 */
+ (instancetype)itemWithUrl:(NSString *)url
                     params:(NSDictionary *)params
                    success:(ZTRequestSuccessBlock)success
                    failure:(ZTRequestFailureBlock)failure;
// 可指定域名的方法
+ (instancetype)itemWithUrl:(NSString *)url
              specifyDomain:(NSString *)domainName
                     params:(NSDictionary *)params
                    success:(ZTRequestSuccessBlock)success
                    failure:(ZTRequestFailureBlock)failure;

// 不自动拼接token，发送请求前调用
- (ZTBaseRequestItem *)setNoToken;

// 发送请求
- (NSURLSessionDataTask *)sendRequest;



// upload
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *filesArray;
// TODO:JHHttpEngine+Upload

@end
