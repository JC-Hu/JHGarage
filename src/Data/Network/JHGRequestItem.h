//
//  JHRequestItem.h
//  ZTStore
//
//  Created by Jason Hu on 2018/8/14.
//  Copyright © 2018年 ZhengTian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum HttpMethod
{
    HTTPPOST,
    HTTPGET,
    JHGHTTPPUT,
    JHGHTTPDELETE
}JHGHttpMethod;

typedef void(^JHGRequestSuccessBlock)(NSDictionary *responseData, NSURLSessionDataTask *task);

typedef void(^JHGRequestFailureBlock)(NSDictionary *responseData, NSError* error, NSURLSessionDataTask *task); // 包括请求后，服务器返回报错的情况

@class JHGRequestItem;
@protocol JHGRequestItemHUDDelegate<NSObject>
@optional
- (void)requestItemHUDStateShouldChange:(JHGRequestItem *)item loading:(BOOL)loading;

@end

@protocol JHGRequestItemBlankDelegate<NSObject>
@optional
- (void)requestItemBlankStateShouldChange:(JHGRequestItem *)item loading:(BOOL)loading;

@end

@interface JHGRequestItem : NSObject

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, strong) NSDictionary *paramsDic;
@property (nonatomic, strong) NSDictionary *finalParamDict;
@property (nonatomic, strong) NSDictionary *responseDict;

@property (nonatomic,assign) JHGHttpMethod httpMethod;

@property (nonatomic, copy) JHGRequestSuccessBlock successBlock;
@property (nonatomic, copy) JHGRequestFailureBlock failureBlock;

@end

@interface JHGRequestItem (AutoHUD)

@property (nonatomic, weak) UIViewController <JHGRequestItemHUDDelegate,JHGRequestItemBlankDelegate>*vcRelated;

@property (nonatomic, assign) BOOL autoHUD; // auto show process & error HUD,default YES
@property (nonatomic, assign) BOOL onlyErrorHUD; // only show error HUD when autoHUD is on ,default NO

@property (nonatomic, assign) BOOL autoShowBlankContent; // if set YES, will show BlankContentView(if needBlankContent) when request fail or empty array, default NO.

@end
