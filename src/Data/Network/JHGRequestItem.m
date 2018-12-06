//
//  JHRequestItem.m
//  ZTStore
//
//  Created by Jason Hu on 2018/8/14.
//  Copyright © 2018年 ZhengTian. All rights reserved.
//

#import "JHGRequestItem.h"

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
@end
