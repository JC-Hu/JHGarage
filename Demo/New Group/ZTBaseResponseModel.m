
//
//  Created by Jason Hu on 2018/8/18.
//

#import "ZTBaseResponseModel.h"

@implementation ZTBaseResponseModel

- (instancetype)initWithDict:(NSDictionary *)dict
{
    if (self = [super init]) {
        self.originalData = dict;
        self.code = [dict[@"error_code"] intValue];
        self.msg = dict[@"error_msg"];
    }
    return self;
}

- (BOOL)isOK
{
    return self.code == 200;
}

@end
