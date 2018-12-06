//
//  JHRequestItem.m
//  ZTStore
//
//  Created by Jason Hu on 2018/8/14.
//  Copyright © 2018年 ZhengTian. All rights reserved.
//

#import "JHGRequestItem.h"

@interface JHGRequestItem ()

@property (nonatomic, weak) UIViewController <JHGRequestItemHUDDelegate,JHGRequestItemBlankDelegate>*vcRelated;

// - AutoHUD
@property (nonatomic, assign) BOOL autoHUD;
@property (nonatomic, assign) BOOL onlyErrorHUD;

// - AutoBlank
@property (nonatomic, assign) BOOL autoShowBlankContent;


@end

@implementation JHGRequestItem

- (instancetype)init
{
    if (self = [super init])
    {
        self.autoHUD = YES;
        self.onlyErrorHUD = NO;
    }
    return self;
}
@end
