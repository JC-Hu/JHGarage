//
//  JHRequestItem.h
//
//  Created by Jason Hu on 2018/8/14.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum HttpMethod
{
    JHGHTTPPOST,
    JHGHTTPGET,
    JHGHTTPPUT,
    JHGHTTPDELETE
}JHGHttpMethod;

typedef void(^JHGRequestSuccessBlock)(NSDictionary *responseData, NSURLSessionDataTask *task);

typedef void(^JHGRequestFailureBlock)(NSDictionary *responseData, NSError* error, NSURLSessionDataTask *task);


@class JHGRequestItem,JHGUploadFormModel;

// Auto HUD
@protocol JHGRequestItemHUDDelegate<NSObject>
@optional
- (void)requestItemHUDStateShouldChange:(JHGRequestItem *)item loading:(BOOL)loading;

@end

// Auto Blank
@protocol JHGRequestItemBlankDelegate<NSObject>
@optional
- (void)requestItemBlankStateShouldChange:(JHGRequestItem *)item loading:(BOOL)loading;

@end

// ResponseModel
@protocol JHGBaseResponseModelProtocol <NSObject>

@property (nonatomic, strong) NSDictionary *originalData; // 原始返回json
@property (nonatomic, assign) int code;  // 200成功
@property (nonatomic, copy) NSString *msg;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (BOOL)isOK; // 请求是否业务上正确

@end

@interface JHGRequestItem : NSObject

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) NSDictionary *paramsDic; // 业务请求入参
@property (nonatomic, strong) NSDictionary *finalParamDict; // 统一处理后的入参
@property (nonatomic, strong) NSDictionary *responseDict; // 处理后的返回dict
@property (nonatomic, strong) id <JHGBaseResponseModelProtocol> responseModel; // 解析辅助类
@property (nonatomic, strong) NSURLSessionDataTask *task; // 请求对应的task

@property (nonatomic, assign) JHGHttpMethod httpMethod;

@property (nonatomic, copy) JHGRequestSuccessBlock successBlock; // 请求成功回调
@property (nonatomic, copy) JHGRequestFailureBlock failureBlock; // 请求失败回调

// to rewrite
- (NSURLSessionDataTask *)sendRequest; // 发送请求

@property (nonatomic, strong) NSDictionary *customHeaderDict;

#pragma mark - Upload
@property (nonatomic, strong) NSArray < __kindof JHGUploadFormModel *>*uploadForms;
@property (nonatomic, copy) void(^progressBlock)(NSProgress *progress);

#pragma mark - AutoHUD AutoBlank
@property (nonatomic, weak) UIViewController <JHGRequestItemHUDDelegate,JHGRequestItemBlankDelegate>*vcRelated;

@property (nonatomic, assign) BOOL autoHUD; // auto show process & error HUD,default YES
@property (nonatomic, assign) BOOL onlyErrorHUD; // only show error HUD when autoHUD is on ,default NO

@property (nonatomic, assign) BOOL autoShowBlankContent; // if set YES, will show BlankContentView(if needBlankContent) when request fail or empty array, default NO.



@end
