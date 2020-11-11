//
//  Created by JasonHu on 2018/12/6.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//



#import "JHGAppStoreTools.h"

#import <AFNetworking/AFHTTPSessionManager.h>

@interface  JHGAppStoreTools ()

@end

@implementation JHGAppStoreTools

+ (instancetype)sharedInstance {
    static dispatch_once_t once;
    static id __singleton__ = nil;
    dispatch_once(&once, ^{
        __singleton__ = [[self alloc] init];
    });
    return __singleton__;
}


- (void)requestIfNeededIsInReviewWithAppID:(NSString *)appID block:(void (^)(BOOL inReview))block
{
    // 是否绕过
    // 使用商店信息判断是否审核中
    __block BOOL inReview = NO; // 默认开启
    
    if ([self isInReview] == JHGInReviewStatusNone) {
        // 没有版本信息
        // 再次请求版本信息
        [[JHGAppStoreTools sharedInstance] requestStoreVersionWithAppID:appID withBlock:^(BOOL success) {
            if (success) {
                // 版本信息请求成功
                if ([[JHGAppStoreTools sharedInstance] isInReview] == JHGInReviewStatusYES) {
                    inReview = YES;
                }
            } else {
                // 版本信息请求失败
                
            }
            // 付款逻辑
            if (block) {
                block(inReview);
            }
        }];
    } else {
        // 已有版本信息
        if ([[JHGAppStoreTools sharedInstance] isInReview] == JHGInReviewStatusYES) {
            // 审核中
            inReview = YES;
        }
        // 付款逻辑
        if (block) {
            block(inReview);
        }
    }
}

- (void)requestStoreVersionWithAppID:(NSString *)appID
{
    [self requestStoreVersionWithAppID:appID withBlock:nil];
}

- (void)requestStoreVersionWithAppID:(NSString *)appID withBlock:(void (^)(BOOL success))block
{
    
    NSString *checkVersionURL = [NSString stringWithFormat:@"https://itunes.apple.com/lookup?id=%@", appID];
    
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    [mgr POST:checkVersionURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *recvDict = responseObject;
        NSArray *infoArray = [recvDict objectForKey:@"results"];
        if ([infoArray count]) {
            NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
            NSString *latestStoreVersion = [releaseInfo objectForKey:@"version"];
            NSLog(@"latestStoreVersion = %@", latestStoreVersion);
            
            self.storeVersion = latestStoreVersion;
            
            if (block) {
                block(YES);
            }
            
        } else {
            if (block) {
                block(NO);
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (block) {
            block(NO);
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(30 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self requestStoreVersionWithAppID:appID withBlock:block];
        });
        
    }];
    
}

- (JHGInReviewStatus)isInReview
{
    // 通过商店版本号判断
    NSString *storeVersion = self.storeVersion;
    
    if (storeVersion.length) {
        
        NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        
        if ([JHGAppStoreTools compareVersionString:currentVersion with:storeVersion] == NSOrderedDescending) {
            return JHGInReviewStatusYES;
        }
        return JHGInReviewStatusNO;
    }
    // 默认状态待确认
    return JHGInReviewStatusNone;
}



#pragma mark -

+ (NSString *)bundleID
{
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    
    NSString *bundleID = [info objectForKey:(__bridge id)kCFBundleIdentifierKey];
    
    return bundleID;
}


+ (NSComparisonResult)compareVersionString:(NSString *)versionA with:(NSString *)versionB
{
    NSComparisonResult result = NSOrderedSame;
    
    NSArray *arrayA = [versionA componentsSeparatedByString:@"."];
    NSArray *arrayB = [versionB componentsSeparatedByString:@"."];
    
    int i = 0;
    while (1) {
        
        if (arrayA.count - 1 < i) {
            
            if (arrayA.count == arrayB.count) {
                result = NSOrderedSame;
                break;
            }
            
            result = NSOrderedAscending;
            break;
        }
        
        if (arrayB.count - 1 < i) {
            
            result = NSOrderedDescending;
            break;
        }
        
        
        NSString *strA = arrayA[i];
        NSString *strB = arrayB[i];
        
        NSComparisonResult res = [@([strA integerValue]) compare:@([strB integerValue])];
        
        if (res == NSOrderedAscending) {
            
            result = res;
            break;
            
        } else if (res == NSOrderedDescending) {
            
            result = res;
            break;
            
        } else {
            
        }
        
        i++;
    }
    
    
    return result;
}

@end
