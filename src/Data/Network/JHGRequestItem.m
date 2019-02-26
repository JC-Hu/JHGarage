//
//  JHRequestItem.m
//
//  Created by Jason Hu on 2018/8/14.
//

#import "JHGRequestItem.h"

#import "JHGHttpEngine.h"

@implementation JHGRequestItem

- (instancetype)init
{
    if (self = [super init])
    {
        self.autoHUD = YES;
        self.onlyErrorHUD = NO;
        self.autoShowBlankContent = NO;
    }
    return self;
}

- (NSURLSessionDataTask *)sendRequest
{
    // 处理入参
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    if (self.paramsDic) {
        [dict setValuesForKeysWithDictionary:self.paramsDic];
    }
    
    // 继承后重写，可统一处理入参
    
    // --
    
    self.finalParamDict = dict;
    
    // 发起请求
    NSURLSessionDataTask *task = [[JHGHttpEngine sharedInstance] sendAsynchronousWithRequestItem:self];
    self.task = task;
    return task;
}

@end
