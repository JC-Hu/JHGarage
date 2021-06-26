//  扩大按钮点击区域
//  UIButton+AreaExpansion.h
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (AreaExpansion)

/// 扩充区域 eg.UIEdgeInsetsMake(-5, -5, -5, -5)
@property(nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;

@end

NS_ASSUME_NONNULL_END
