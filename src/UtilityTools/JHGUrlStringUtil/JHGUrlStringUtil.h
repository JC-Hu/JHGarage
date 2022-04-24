//
//  JHGUrlStringUtil.h
//  
//
//  Created by JasonHu on 2019/12/24.
//  Copyright © 2019 JasonHu. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHGUrlStringUtil : NSObject

+ (NSDictionary<NSString *, NSString *> *)queryItemsWithUrl:(NSString *)url;

+ (NSString *)appendedStringWithUrl:(NSString *)url paramDict:(NSDictionary *)params;


@end

NS_ASSUME_NONNULL_END
