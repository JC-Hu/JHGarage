//
//  Created by JasonHu on 2018/12/6.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//


#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, JHGInReviewStatus) {
    JHGInReviewStatusNone,
    JHGInReviewStatusYES,
    JHGInReviewStatusNO
};


@interface JHGAppStoreTools : NSObject


@property (nonatomic, strong) NSString *storeVersion;

+ (instancetype)sharedInstance;

- (void)requestIfNeededIsInReviewWithAppID:(NSString *)appID block:(void (^)(BOOL inReview))block;

- (void)requestStoreVersionWithAppID:(NSString *)appID;

- (void)requestStoreVersionWithAppID:(NSString *)appID withBlock:(void (^)(BOOL success))block;

- (JHGInReviewStatus)isInReview;

@end


