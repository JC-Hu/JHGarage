//
//  Created by JasonHu on 2018/12/6.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"

@class ZTBaseRequestItem;

typedef NS_ENUM(NSInteger, SortImgType) {
    Type_Base = 0,
    Type_Asc,
    Type_Desc
};

typedef NS_ENUM(NSInteger, NavigationBarStyle) {
    STYLE_BLUE = 0,
    STYLE_WHITE
};

typedef NS_ENUM(NSInteger,OrderType) {
    TYPE_ALL = 0,
    TYPE_WAIT,
    TYPE_GOODS,
    TYPE_COMPLETE,
    TYPE_CANCLE,
    
};

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
- (void)requestWithItem:(ZTBaseRequestItem *)item;
- (void)requestWithItemNoHUD:(ZTBaseRequestItem *)item;
- (void)requestWithItemOnlyError:(ZTBaseRequestItem *)item;

#pragma mark - HUD
- (void)showLoadingHUD;
- (void)hideHUD;


#pragma mark - BlankView
@property (nonatomic, strong) UIView *blankView;

@end

