//
//  JHHttpEngine.h
//
//  Created by Jason Hu on 2018/8/14.
//

#import <Foundation/Foundation.h>

#import "JHMarcoTools.h"
#import "JHGRequestItem.h"

@protocol JHGHttpEngineDelegate <NSObject>

@optional
- (void)willSendRequestItem:(JHGRequestItem *)item;
- (void)didSendRequestItem:(JHGRequestItem *)item;
- (void)didFinishRequestItem:(JHGRequestItem *)item;

@end

@class AFHTTPSessionManager;
@interface JHGHttpEngine : NSObject

MMSingletonInterface

@property (nonatomic, strong) AFHTTPSessionManager *manager;

@property (nonatomic, assign) BOOL disableLog;

@property (nonatomic, weak) id<JHGHttpEngineDelegate> delegate;


- (NSURLSessionDataTask *)sendAsynchronousWithRequestItem:(JHGRequestItem *)item;

// to rewrite
- (AFHTTPSessionManager *)createAFSessionManager;

@end

@interface JHGHttpEngineDefaultDelegate : NSObject <JHGHttpEngineDelegate>

MMSingletonInterface

@end
