//
//  Created by JasonHu on 2018/12/6.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Masonry/Masonry.h>
#import <JHCellConfig/JHCellConfig.h>
#import "UIView+JHGShortcut.h"

@class JHGRequestItem;

typedef enum : NSUInteger {
    JHBlankContentEmpty,            // 无结果,无内容
    JHBlankContentLoading,           // 加载中
    JHBlankContentNetworkError,    // 无网络
    JHBlankContentCustom,           // 特殊
    JHBlankContentError              // 不需要具体说明的错误
} JHBlankContentState;

@interface JHGBaseViewController : UIViewController 

#pragma mark - Toast
- (void)showToast:(NSString *)str;
- (void)showToastInNCView:(NSString *)str;
- (void)showToastNetworkError;
- (void)showToastInNCViewNetworkError;

#pragma - HTTP
- (void)requestWithItem:(JHGRequestItem *)item;
- (void)requestWithItemNoHUD:(JHGRequestItem *)item;
- (void)requestWithItemOnlyError:(JHGRequestItem *)item;

#pragma mark - HUD
- (void)showLoadingHUD;
- (void)hideHUD;


#pragma mark - BlankView
@property (nonatomic, strong) UIView *blankView;

@end

