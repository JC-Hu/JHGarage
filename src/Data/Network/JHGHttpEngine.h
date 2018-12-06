//
//  JHHttpEngine.h
//  ZTStore
//
//  Created by Jason Hu on 2018/8/14.
//  Copyright © 2018年 ZhengTian. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "JHMarcoTools.h"
#import "JHGRequestItem.h"

@protocol JHGHttpEngineDelegate <NSObject>

- (void)willSendRequestItem:(JHGRequestItem *)item;
- (void)didSendRequestItem:(JHGRequestItem *)item;
- (void)didFinishRequestItem:(JHGRequestItem *)item;

@end

@class AFHTTPSessionManager;
@interface JHGHttpEngine : NSObject

MMSingletonInterface

@property (nonatomic, assign) BOOL disableLog;

@property (nonatomic, assign) id<JHGHttpEngineDelegate> delegate;


- (NSURLSessionDataTask *)sendAsynchronousWithRequestItem:(JHGRequestItem *)item;

// to rewrite
- (AFHTTPSessionManager *)createAFSessionManager;

@end

@interface JHGHttpEngineDefaultDelegate : NSObject <JHGHttpEngineDelegate>

MMSingletonInterface

@end
