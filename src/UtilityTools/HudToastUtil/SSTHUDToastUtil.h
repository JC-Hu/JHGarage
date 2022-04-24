

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface SSTHUDToastUtil : NSObject

#pragma mark - Loading HUD
/**
 显示加载框（指定view）

 @param view 添加的view
 @param isAnimated 是否有动画
 */
+ (void)showProgressWithView:(UIView *)view animated:(BOOL)isAnimated;

/**
 显示加载框（Window）
 
 @param isAnimated 是否有动画
 */
+ (void)showProgressWithAnimated:(BOOL)isAnimated;

/// 无效果hud
+ (void)showNoneEffectProgressWithAnimated:(BOOL)isAnimated;

/// 指定文字加载框
+ (void)showProgressWithView:(UIView *)view Text:(NSString *)text animated:(BOOL)animated;

/**
 隐藏加载框（指定view）

 @param view 加载的view
 @param isAnimated 是否显示动画
 */
+ (void)hideProgressWithView:(UIView *)view animated:(BOOL)isAnimated;

/**
 隐藏加载框（Window）
 
 @param isAnimated 是否显示动画
 */
+ (void)hideProgressWithAnimated:(BOOL)isAnimated;

#pragma mark - Toast

/**
 默认Toast

 @param message 消息
 */
+ (void)showToast:(NSString *)message;

/**
 默认Toast，指定view

 @param message 消息
 @param view 指定view
 */
+ (void)showToast:(NSString *)message inView:(UIView *)view;

+ (void)showToast:(NSString *)message inView:(UIView *)view duration:(NSTimeInterval)duration position:(id)position;


#pragma mark - Custom HUD
+ (void)showCustomView:(UIView *)view withAnimated:(BOOL)isAnimated withAfterDelay:(NSTimeInterval)afterDelay;

+ (void)showCustomView:(UIView *)view toView:(UIView *)toView withAnimated:(BOOL)isAnimated withAfterDelay:(NSTimeInterval)afterDelay;

@end

