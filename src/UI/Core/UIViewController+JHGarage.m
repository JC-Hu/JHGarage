//
//  UIViewController+JHGarage.m
//  JHGarage
//
//  Created by Jason Hu on 2018/12/13.
//  Copyright © 2018 Jason Hu. All rights reserved.
//

#import "UIViewController+JHGarage.h"
#import "JHGRequestItem.h"
#import "Toast.h"

#import <objc/runtime.h>
#import "JHGSwizzle.h"

static NSString * const JHGarage_Key_BlackView;


@interface UIViewController () <JHGRequestItemHUDDelegate, JHGRequestItemBlankDelegate>

@end

@implementation UIViewController (JHGarage)

+ (void)load
{
    [self jhg_swizzleMethod:@selector(viewDidLoad) withMethod:@selector(jhg_viewDidLoad) error:nil];
    [self jhg_swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(jhg_viewWillAppear:) error:nil];
    [self jhg_swizzleMethod:@selector(viewWillDisappear:) withMethod:@selector(jhg_viewWillDisappear:) error:nil];
    [self jhg_swizzleMethod:@selector(viewDidAppear:) withMethod:@selector(jhg_viewDidAppear:) error:nil];
    [self jhg_swizzleMethod:NSSelectorFromString(@"dealloc") withMethod:@selector(jhg_dealloc) error:nil];
}

- (void)jhg_viewDidLoad {
    
    
    if (self.navigationController && self.navigationController.viewControllers.firstObject != self) {
        [self setHidesBottomBarWhenPushed:YES];
    }

    // blankView
    [self.view addSubview:self.blankView];
    self.blankView.hidden = YES;
    
    [self jhg_viewDidLoad];

}

- (void)jhg_viewWillAppear:(BOOL)animated
{
    [self jhg_viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear", NSStringFromClass(self.class));
}

- (void)jhg_viewWillDisappear:(BOOL)animated
{
    [self jhg_viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear", NSStringFromClass(self.class));
}

- (void)jhg_viewDidAppear:(BOOL)animated {
    [self jhg_viewDidAppear:animated];
}

- (void)jhg_dealloc
{
    NSString *str = NSStringFromClass(self.class);
    [self jhg_dealloc];
    NSLog(@"%@ dealloc", str);
}

#pragma mark -

#pragma mark - HUD

#pragma mark - Toast
- (void)showToast:(NSString *)str
{
    [self.view makeToast:str duration:2 position:CSToastPositionCenter];
}

- (void)showToastInNCView:(NSString *)str
{
    [self.navigationController.view makeToast:str duration:2 position:CSToastPositionCenter];
}

- (void)showToastNetworkError
{
    [self showToast:@"请求错误，请检查网络。"];
}

- (void)showToastInNCViewNetworkError
{
    [self showToastInNCView:@"请求错误，请检查网络。"];
}



#pragma - HTTP
- (void)requestWithItem:(JHGRequestItem *)item
{
    item.vcRelated = self;
    
    [item sendRequest];
}

- (void)requestWithItemNoHUD:(JHGRequestItem *)item
{
    item.autoHUD = NO;
    [self requestWithItem:item];
}

- (void)requestWithItemOnlyError:(JHGRequestItem *)item
{
    item.autoHUD = YES;
    item.onlyErrorHUD = YES;
    [self requestWithItem:item];
}

- (void)requestWithMainItem:(JHGRequestItem *)item
{
    item.autoHUD = YES;
    item.autoShowBlankContent = YES;
    [self requestWithItem:item];
}



// Auto HUD
- (void)requestItemHUDStateShouldChange:(JHGRequestItem *)item loading:(BOOL)loading
{
    if (!item.autoHUD) {
        return;
    }
    if (loading) {
        // 开始请求，加载转圈提示
        if (!item.onlyErrorHUD) {
            [self showLoadingHUD];
        }
    } else {
        // 请求完成
        if (!item.onlyErrorHUD) {
            [self hideHUD];
        }
        
        if (item.responseDict) {
            if (item.responseModel.isOK) {
                // 请求成功且数据正确
            } else {
                // 请求成功但数据异常
                [self showToast:item.responseModel.msg];
            }
        } else {
            // 请求失败
            [self showToastNetworkError];
        }
    }
}

// Auto Blank
- (void)requestItemBlankStateShouldChange:(JHGRequestItem *)item loading:(BOOL)loading
{
    // TODO : Auto Blank Function
}

#pragma mark - HUD
- (void)showLoadingHUD
{
    [self.view makeToastActivity:CSToastPositionCenter];
}

- (void)hideHUD
{
    [self.view hideToastActivity];
}

#pragma mark - BlankView
- (void)showBlankViewForState:(JHBlankContentState)state
{
    self.blankView.hidden = NO;
    [self.view bringSubviewToFront:self.blankView];
    
    [self updateBlankViewWithState:state];
}

- (void)hideBlankView
{
    self.blankView.hidden = YES;
}

- (void)updateBlankViewWithState:(JHBlankContentState)state
{
    
}

#pragma mark
- (void)setBlankView:(UIView *)blankView
{
    objc_setAssociatedObject(self, &JHGarage_Key_BlackView, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIView *)blankView
{
    UIView *_value = objc_getAssociatedObject(self, &JHGarage_Key_BlackView);
    if (!_value) {
        _value = [UIView new];
        self.blankView = _value;
    }
    return _value;
}


@end
