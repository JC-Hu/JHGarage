//
//  Created by JasonHu on 2018/12/6.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//

#import "JHGBaseViewController.h"

#import "JHGRequestItem.h"

#import "Toast.h"

@interface JHGBaseViewController () <JHGRequestItemHUDDelegate, JHGRequestItemBlankDelegate>
@end

@implementation JHGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    if (self.navigationController && self.navigationController.viewControllers.firstObject != self) {
        [self setHidesBottomBarWhenPushed:YES];
    }
    
    // blankView
    [self.view addSubview:self.blankView];
    self.blankView.hidden = YES;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"%@ viewWillAppear", NSStringFromClass(self.class));
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    NSLog(@"%@ viewWillDisappear", NSStringFromClass(self.class));
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass(self.class));
}

#pragma mark -

#pragma mark - HUD

#pragma mark - Toast
- (void)showToast:(NSString *)str
{
    [self.view makeToast:str duration:2 position:CSToastPositionCenter];
//    [[ErrorToastViewController shareInstance] showToastWithErrorMsg:str];
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

//    [item sendRequest];
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
//            if (item.responseModel.isOK) {
//                // 请求成功且数据正确
//            } else {
//                // 请求成功但数据异常
//                [self showToast:item.responseModel.msg];
//            }
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
    // TODO: new HUD management system
    
}

- (void)hideHUD
{
   
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

- (UIView *)blankView
{
    if (!_blankView) {
        _blankView = [UIView new];
    }
    return _blankView;
}

@end
