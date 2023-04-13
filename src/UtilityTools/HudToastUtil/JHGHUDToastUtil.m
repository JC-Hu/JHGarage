
#import "JHGHUDToastUtil.h"
#import <MBProgressHUD/MBProgressHUD.h>
#import <Toast/Toast.h>

@implementation JHGHUDToastUtil

#pragma mark - Loading HUD
/**
 显示加载框（指定view）

 @param view 添加的view
 @param isAnimated 是否有动画
 */
+ (void)showProgressWithView:(UIView *)view animated:(BOOL)isAnimated {
    [self hideProgressWithView:view animated:false];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:view animated:isAnimated];
        [self setDefaultHUD:loading];
        loading.mode = MBProgressHUDModeIndeterminate;
    });
    
}

/**
 显示加载框（Window）
 
 @param isAnimated 是否有动画
 */
+ (void)showProgressWithAnimated:(BOOL)isAnimated {
    [self hideProgressWithAnimated:isAnimated];
    
    [self showProgressWithView:[UIApplication sharedApplication].keyWindow animated:isAnimated];
}

/// 无效果hud
+ (void)showNoneEffectProgressWithAnimated:(BOOL)isAnimated {
    [self hideProgressWithAnimated:isAnimated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:isAnimated];
        loading.mode = MBProgressHUDModeCustomView;
        loading.customView = [UIView new];
        loading.customView.backgroundColor = [UIColor clearColor];
        loading.bezelView.hidden = YES;
        loading.backgroundView.hidden= YES;
    });
}

/// 指定文字加载框
+ (void)showProgressWithView:(UIView *)view Text:(NSString *)text animated:(BOOL)animated {
    [self hideProgressWithView:view animated:animated];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:view animated:animated];
        [self setDefaultHUD:loading];
        loading.label.text = text;
        loading.mode = MBProgressHUDModeIndeterminate;
    });
}

/**
 隐藏加载框（指定view）

 @param view 加载的view
 @param isAnimated 是否显示动画
 */
+ (void)hideProgressWithView:(UIView *)view animated:(BOOL)isAnimated
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:view animated:isAnimated];
    });
}

/**
 隐藏加载框（Window）
 
 @param isAnimated 是否显示动画
 */
+ (void)hideProgressWithAnimated:(BOOL)isAnimated {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:isAnimated];
    });
}

+ (void)setDefaultHUD:(MBProgressHUD *)hub{
    hub.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hub.contentColor = [UIColor whiteColor];
    hub.bezelView.backgroundColor = [UIColor colorWithRed:0/255 green:0/255 blue:0/255 alpha:0.8];
    hub.removeFromSuperViewOnHide = YES;
    //设置菊花框为白色
    [UIActivityIndicatorView appearanceWhenContainedInInstancesOfClasses:@[[MBProgressHUD class]]].color = [UIColor whiteColor];
}

#pragma mark - Toast
/**
 默认Toast

 @param message 消息
 */
+ (void)showToast:(NSString *)message {
    [self showToast:message inView:[UIApplication sharedApplication].keyWindow];
}

/**
 默认Toast，指定view

 @param message 消息
 @param view 指定view
 */
+ (void)showToast:(NSString *)message inView:(UIView *)view
{
    
    [self showToast:message inView:view duration:2 position:CSToastPositionCenter];
}

+ (void)showToast:(NSString *)message inView:(UIView *)view duration:(NSTimeInterval)duration position:(id)position
{
    [view makeToast:message duration:duration position:position];
}


#pragma mark - Custom HUD

/**
 显示自定义View样式
 @param view 自定义view
 @param isAnimated 是否显示动画
 @param afterDelay 显示时长
 */

+ (void)showCustomView:(UIView *)view withAnimated:(BOOL)isAnimated withAfterDelay:(NSTimeInterval)afterDelay {

    [self showCustomView:view toView:[UIApplication sharedApplication].keyWindow withAnimated:isAnimated withAfterDelay:afterDelay];
}

+ (void)showCustomView:(UIView *)view toView:(UIView *)toView withAnimated:(BOOL)isAnimated withAfterDelay:(NSTimeInterval)afterDelay
{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        MBProgressHUD *loading = [MBProgressHUD showHUDAddedTo:toView animated:isAnimated];
        loading.mode = MBProgressHUDModeCustomView;
        loading.customView = view;
        loading.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        loading.bezelView.backgroundColor = UIColor.clearColor;
        [loading hideAnimated:YES afterDelay:afterDelay];
    });
}

@end
