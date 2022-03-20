//
//  JHGUrlStringUtil.m
//  
//
//  Created by JasonHu on 2019/12/24.
//  Copyright © 2019 JasonHu. All rights reserved.
//

#import "JHGUrlStringUtil.h"

@implementation JHGUrlStringUtil

+ (NSDictionary<NSString *, NSString *> *)queryItemsWithUrl:(NSString *)url
{
    if (!url.length) {
        return nil;
    }
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithString:url];
    
    [urlComponents.queryItems enumerateObjectsUsingBlock:^(NSURLQueryItem * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.name) {
            [params setValue:obj.value ?: nil forKey:obj.name];
        }
    }];
    return [params copy];
}

+ (NSString *)appendedStringWithUrl:(NSString *)url paramDict:(NSDictionary *)params
{
    
    // 初始化参数变量
    NSString *str = @"?";
    
    // 快速遍历参数数组
    for(id key in params) {

        NSString *value = [NSString stringWithFormat:@"%@",[params objectForKey:key]];
        str = [str stringByAppendingString:key];
        str = [str stringByAppendingString:@"="];
        str = [str stringByAppendingString:value];
        str = [str stringByAppendingString:@"&"];
    }
    
    // 处理多余的&以及返回含参url
    if (str.length > 1) {
    
        // 去掉末尾的&
        str = [str substringToIndex:str.length - 1];
        
        // 返回含参url
        str = [str stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        return [url stringByAppendingString:str];
    }
    return url;
}

@end
