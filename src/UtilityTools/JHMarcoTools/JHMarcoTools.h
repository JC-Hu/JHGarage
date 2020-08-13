//
//  Created by JasonHu on 2018/12/6.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//



#ifndef JHMarcoTools_h
#define JHMarcoTools_h

#import "JHEXTScope.h"

// 定义枚举标识符和其对应的值的宏
#define ENUM_VALUE(name,assign) name assign,
// 将枚举标识符转换成字符串的宏
#define ENUM_CASE(name,assign) case name: return @#name;
// 将字符串转换为枚举标识符的宏
#define ENUM_STRCMP(name,assign) if ([string isEqualToString:@#name]) return name;
/// 声明函数 及 定义枚举
#define DECLARE_ENUM(EnumType,ENUM_DEF) \
typedef NS_ENUM(NSUInteger, EnumType) { \
ENUM_DEF(ENUM_VALUE) \
};  \
static NSString *stringFrom##EnumType(EnumType value) __attribute__((unused)); \
static EnumType EnumType##FromString(NSString *string) __attribute__((unused)); \
static NSString *stringFrom##EnumType(EnumType value) { \
switch(value) { \
ENUM_DEF(ENUM_CASE) \
default: return @""; \
} \
} \
\
static EnumType EnumType##FromString(NSString *string) { \
ENUM_DEF(ENUM_STRCMP) \
return (EnumType)0; \
}

/*
 使用
 #define WorkStatus(XX) \
 XX(WorkStatusUnKnown,) \
 XX(WorkStatusWorking,) \
 XX(WorkStatusSleeping,=50)
 // 生成定义的枚举 与 转换方法.
 DECLARE_ENUM(WorkStatus,WorkStatus)
 
 WorkStatus testWorkStatus = WorkStatusUnKnown;
 NSLog(@"workstatus is: %@", stringFromWorkStatus(testWorkStatus));
 WorkStatusFromString(@"WorkStatusUnKnown")
 */




// singleton

#undef MMSingletonInterface
#define MMSingletonInterface +(instancetype)sharedInstance;

#undef MMSingletonImplementation
#define MMSingletonImplementation                                       \
+(instancetype)sharedInstance {                                         \
static dispatch_once_t once;                                            \
static id __singleton__ = nil;                                          \
dispatch_once(&once, ^{                                                 \
__singleton__ = [[self alloc] init];                                    \
});                                                                     \
return __singleton__;                                                   \
}


// weak / strong
#define JHWeakSelf @weakify(self);
#define JHStrongSelf @strongify(self);

// SafeArea底部缩进
#define kSafeAreaInsetsBottom ({\
double tmp = 0.0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom > 0) {\
tmp = [UIApplication sharedApplication].delegate.window.safeAreaInsets.bottom;\
}else{\
tmp = 0.0;\
}\
}else{\
tmp = 0.0;\
}\
tmp;\
})

//系统控件默认高度
#define kStatusBarHeight ([UIApplication sharedApplication].statusBarFrame.size.height)
#define kNavBarHeight (44.f)
#define kTabBarHeight (kSafeAreaInsetsBottom + 49.f)
#define kSafeAreaTopHeight       (kStatusBarHeight + kNavBarHeight)

// iPhoneX系列
#define kDevice_X \
({ BOOL x = NO; \
    if (@available(iOS 11.0, *)) { \
        x = [[UIApplication sharedApplication] delegate].window.safeAreaInsets.bottom > 0.0; \
    } \
x; \
})


// 屏幕宽高
#define kJHScreenWidth     ([UIScreen mainScreen].bounds.size.width)
#define kJHScreenHeight    ([UIScreen mainScreen].bounds.size.height)


// HEX
#define HEX_COlOR_A(HexValue,Alpha) [UIColor colorWithRed:((float)((HexValue & 0xFF0000) >> 16))/255.0 green:((float)((HexValue & 0xFF00) >> 8))/255.0 blue:((float)(HexValue & 0xFF))/255.0 alpha:Alpha]
#define HEX_COlOR(HexValue) COLOR_HEX_A(HexValue,1)

//DEBUG模式下,打印日志(包括函数名、行号)
#ifdef DEBUG
# define DLog(fmt, ...) NSLog((@"%s [Line %d] \n" fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
# define DLog(...)
#endif

typedef void(^JHSingleSelectionBlock)(id model);

#endif /* JHMarcoTools_h */
