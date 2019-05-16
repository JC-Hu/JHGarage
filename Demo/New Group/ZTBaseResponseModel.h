//
//
//  Created by Jason Hu on 2018/8/18.
//

#import <Foundation/Foundation.h>

#import "JHGRequestItem.h"

@interface ZTBaseResponseModel : NSObject <JHGBaseResponseModelProtocol>

@property (nonatomic, strong) NSDictionary *originalData;
@property (nonatomic, assign) int code;  // 200成功, 401登录过期 - 清除token
@property (nonatomic, copy) NSString *msg;

- (instancetype)initWithDict:(NSDictionary *)dict;

- (BOOL)isOK;

@end
