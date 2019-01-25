//
//  UIViewController+JHGBlankView.h
//  JHGarage
//
//  Created by Jason Hu on 2019/1/25.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIViewController+JHGarage.h"
#import "JHGBlankView.h"

typedef enum : NSUInteger {
    JHBlankContentEmpty,            // 无结果,无内容
    JHBlankContentLoading,           // 加载中
    JHBlankContentNetworkError,    // 无网络
    JHBlankContentCustom,           // 特殊12qq    JHBlankContentError              // 不需要具体【的错误
} JHBlankContentState;


@interface UIViewController (JHGBlankView)

#pragma mark - BlankView
@property (nonatomic, strong) JHGBlankView *jhg_blankView;
- (void)showBlankViewForState:(JHBlankContentState)state;
- (void)hideBlankView;

// to rewrite
- (void)updateBlankViewWithState:(JHBlankContentState)state;
- (void)blankViewRefreshAction:(id)sender;


@end


