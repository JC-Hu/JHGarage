//
//  JHHttpEngine.m
//
//  Created by Jason Hu on 2018/8/14.
//

#import "JHGHttpEngine.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "JHGUploadFormModel.h"

#if defined(DEBUG) && DEBUG
#ifdef DEBUG
#define HttpRequestLog(...) printf("%f %s\n",[[NSDate date]timeIntervalSince1970],[[NSString stringWithFormat:__VA_ARGS__]UTF8String]);
#else
#define HttpRequestLog(...)
#endif


@implementation JHGHttpEngine

+ (instancetype)sharedInstance {
    Class selfClass = [self class];
    // 从类中获取对象
    id instance = objc_getAssociatedObject(selfClass, @"sharedInstance");
    @synchronized (self) {
        if (!instance) {
            // 不存在，创建对象
            instance = [[super allocWithZone:NULL] init];
            // 给类绑定对象
            objc_setAssociatedObject(selfClass, @"sharedInstance", instance, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    return instance;
}

- (AFHTTPSessionManager *)createAFSessionManager
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.securityPolicy.allowInvalidCertificates = YES;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 8;
    
    return manager;
}

- (NSDictionary *)requestHeaderDict
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    return dict;
}

- (void)updateRequestHeader
{
    for (NSString *httpHeaderField in self.requestHeaderDict.allKeys) {
        NSString *value = self.requestHeaderDict[httpHeaderField];
        [self.manager.requestSerializer setValue:value forHTTPHeaderField:httpHeaderField];
    }
}

- (AFHTTPSessionManager *)manager
{
    if (!_manager) {
        _manager = [self createAFSessionManager];
    }
    return _manager;
}

- (NSURLSessionDataTask *)sendAsynchronousWithRequestItem:(JHGRequestItem *)item
{
    if (!item.urlString || item.urlString.length <= 0){
        NSLog (@"HTTPEngine urlString = null");
        return nil;
    }
    [self updateRequestHeader];
    
    AFHTTPSessionManager *manager = [self manager];
    
    if (!item.finalParamDict) {
        item.finalParamDict = item.paramsDic;
    }
    NSDictionary *paramDict = item.finalParamDict;
    
    // 请求发起前
    [self willSendRequestItem:item];
    
    NSURLSessionDataTask *sessionTask;
    switch (item.httpMethod){
        case JHGHTTPGET:
        {
            sessionTask = [manager GET:item.urlString parameters:paramDict headers:item.customHeaderDict progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                  [self successRequestProcessWith:task responseObject:responseObject item:item];
            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failureRequestProcessWith:task error:error item:item];
            }];
        }
            break;
        case JHGHTTPPOST:
        {
            if (item.uploadForms.count) {
                // 上传
                sessionTask = [manager POST:item.urlString parameters:paramDict headers:item.customHeaderDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
                    
                    for (JHGUploadFormModel *formModel in item.uploadForms) {
                        [formData appendPartWithFileData:formModel.fileData name:formModel.name fileName:formModel.fileName mimeType:formModel.mimeType];
                    }
                    
                }  progress:^(NSProgress * _Nonnull uploadProgress) {
                    // item回调
                    if (item.progressBlock) {
                        item.progressBlock(uploadProgress);
                    }
                } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                    [self successRequestProcessWith:task responseObject:responseObject item:item];
                }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self failureRequestProcessWith:task error:error item:item];
                }];
            } else {
                sessionTask = [manager POST:item.urlString parameters:paramDict headers:item.customHeaderDict progress:^(NSProgress * _Nonnull downloadProgress) {
                    
                } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                    [self successRequestProcessWith:task responseObject:responseObject item:item];
                }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [self failureRequestProcessWith:task error:error item:item];
                }];
            }
        }
            break;
        case JHGHTTPPUT:
        {
            sessionTask = [manager PUT:item.urlString parameters:paramDict headers:item.customHeaderDict success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                [self successRequestProcessWith:task responseObject:responseObject item:item];
            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failureRequestProcessWith:task error:error item:item];
            }];
            
        }
            break;
        case JHGHTTPDELETE:
        {
            sessionTask = [manager DELETE:item.urlString parameters:paramDict headers:item.customHeaderDict success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
                [self successRequestProcessWith:task responseObject:responseObject item:item];
            }failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                [self failureRequestProcessWith:task error:error item:item];
            }];
        }
            break;
        default:
            break;
    }
    
    // 请求发起后
    [self didSendRequestItem:item];
    
    [self logDebugInfoWithRequest:sessionTask.currentRequest requestParams:paramDict];
    
    return sessionTask;
}

#pragma mark - Reuse Method
// 请求成功回调
- (void)successRequestProcessWith:(NSURLSessionDataTask *)task  responseObject:(NSDictionary *)responseObject item:(JHGRequestItem *)item
{
    
    NSDictionary *responseDictionary = responseObject;
    item.responseDict = responseDictionary;
    
    // Log
    NSData *data = [NSJSONSerialization dataWithJSONObject:responseDictionary options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self logDebugInfoWithResponse:task.response resposeString:jsonString request:task.currentRequest error:nil];
    
    // item回调
    if (item.successBlock) {
        item.successBlock(responseDictionary, task);
    }
    // 代理回调
    [self didFinishRequestItem:item];
}

// 请求失败回调
- (void)failureRequestProcessWith:(NSURLSessionDataTask *)task  error:(NSError *)error item:(JHGRequestItem *)item
{
    // Log
    [self logDebugInfoWithResponse:task.response resposeString:nil request:task.currentRequest error:error];
    
    // item回调
    if (item.failureBlock) {
        item.failureBlock(nil, error, task);
    }
    // 代理回调
    [self didFinishRequestItem:item];
}

// 
- (void)willSendRequestItem:(JHGRequestItem *)item
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willSendRequestItem:)]) {
        [self.delegate willSendRequestItem:item];
    }
}

- (void)didSendRequestItem:(JHGRequestItem *)item
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSendRequestItem:)]) {
        [self.delegate didSendRequestItem:item];
    }
}

- (void)didFinishRequestItem:(JHGRequestItem *)item
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(willSendRequestItem:)]) {
        [self.delegate didFinishRequestItem:item];
    }
}





///// 判断code
//- (BOOL)isCorrectResponseDict:(NSDictionary *)dict withItem:(BaseItem *)item
//{
//
//
//    NSString *errorString = dict[@"message"]?: LocalizedStirngForkey(@"未知错误");
//
//
//    if([dict objectForKey:@"code"]){
//        int code = [[dict objectForKey:@"code"] intValue];
//
//        if (code == SYS_OK_CODE) {
//            return YES;
//        }
//
//        errorString = [TubbanHelper errorStringWithCode:code]?:errorString;
//
//    }
//    //    errorString = [NSString stringWithFormat:@"%@(%@)", errorString, [dict objectForKey:@"code"]];
//
//    NSLog(@"%@", errorString);
//
//    if (item.autoHUD && item.vcRelated) {
//        // error HUD
//        [[HUDHelper shareInstance] showText:errorString inView:item.vcRelated.view type:HUDTypeError];
//
//    }
//
//
//    return NO;
//
//}


// - log
- (void)logDebugInfoWithRequest:(NSURLRequest *)request
                  requestParams:(id)requestParams
{
    if (self.disableLog) {
        return;
    }
    
    NSMutableString *formatString =
    [NSMutableString stringWithString:@"\n============================================="
     @"==============================================="];
    [formatString appendFormat:@"\n----JHGHttpEngine Log-----"];
    [formatString appendFormat:@"\n----HttpUrl = %@",request.URL.absoluteString];
    [formatString appendFormat:@"\n----HTTP send %@",request.HTTPMethod];
    [formatString appendFormat:@"\n----HeaderFields = %@",request.allHTTPHeaderFields];
    [formatString appendFormat:@"\n----formated args = %@", requestParams];
    
    if ([request.HTTPMethod isEqualToString:@"POST"]) {
        NSString *bodyString = [NSString
                                stringWithFormat:@"\nbody = %@ ,",
                                [[NSString alloc] initWithData:request.HTTPBody
                                                      encoding:NSUTF8StringEncoding]];
        [formatString appendString:bodyString];
    }
    HttpRequestLog(@"%@", formatString);
}


- (void)logDebugInfoWithResponse:(NSURLResponse *)response resposeString:(NSString *)responseString request:(NSURLRequest *)request error:(NSError *)error
{
    if (self.disableLog) {
        return;
    }
    NSMutableString *formatString =
    [NSMutableString stringWithString:@"\n============================================="
     @"==============================================="];
    [formatString appendFormat:@"\n---- JHGHttpEngine Log -----"];
    [formatString appendFormat:@"\n---- requestUrl = %@", request.URL];
    if (response) {
        [formatString appendFormat:@"\n---- Response: (status %zd) (JSON) =", ((NSHTTPURLResponse *)response).statusCode];
        [formatString appendFormat:@"\n%@", responseString];
        
    }
    if (error) {
        [formatString appendFormat:@"\n---Error - code: %@", @(error.code)];
        [formatString appendFormat:@"\n%@", error.localizedDescription];
    }
    
    [formatString appendString:@"\n============================================="
     @"==============================================="@"\n\n"];

    HttpRequestLog(@"%@", formatString);
}


- (id<JHGHttpEngineDelegate>)delegate
{
    if (!_delegate) {
        _delegate = [JHGHttpEngineDefaultDelegate sharedInstance];
    }
    return _delegate;
}

@end


@implementation JHGHttpEngineDefaultDelegate

MMSingletonImplementation

- (void)willSendRequestItem:(JHGRequestItem *)item
{
    // -- HUD
    if (item.vcRelated && [item.vcRelated respondsToSelector:@selector(requestItemHUDStateShouldChange:loading:)]) {
        [item.vcRelated requestItemHUDStateShouldChange:item loading:YES];
    }
    
    // -- Blank
    if (item.vcRelated && [item.vcRelated respondsToSelector:@selector(requestItemBlankStateShouldChange:loading:)]) {
        [item.vcRelated requestItemBlankStateShouldChange:item loading:YES];
    }
}
- (void)didSendRequestItem:(JHGRequestItem *)item
{
    
}
- (void)didFinishRequestItem:(JHGRequestItem *)item
{
    // -- HUD
    if (item.vcRelated && [item.vcRelated respondsToSelector:@selector(requestItemHUDStateShouldChange:loading:)]) {
        [item.vcRelated requestItemHUDStateShouldChange:item loading:NO];
    }
    
    // -- Blank
    if (item.vcRelated && [item.vcRelated respondsToSelector:@selector(requestItemBlankStateShouldChange:loading:)]) {
        [item.vcRelated requestItemBlankStateShouldChange:item loading:NO];
    }
}

@end
