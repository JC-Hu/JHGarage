

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, SSTAuthorizationStatus) {

    SSTAuthorizationStatus_NotDetermined  = 0, // 用户从未进行过授权等处理，首次访问相应内容会提示用户进行授权
    SSTAuthorizationStatus_Restricted     = 1, // 应用没有相关权限，且当前用户无法改变这个权限，比如:家长控制
   
    SSTAuthorizationStatus_Denied         = 2, // 拒绝
    SSTAuthorizationStatus_Authorized     = 3, // 已授权
    SSTAuthorizationStatus_NotSupport     = 4, // 硬件等不支持或服务未开启
    SSTAuthorizationStatus_NotInfoDesc = 5,   //文件描述
    SSTAuthorizationLocaStatus_AlwaysUsage      = 11, // 一直允许获取定位
    SSTAuthorizationLocaStatus_WhenInUseUsage      = 12, // 一直允许获取定位
};
typedef void (^SSTAuthorizationBlock)(BOOL isAvailable, SSTAuthorizationStatus status);

NS_ASSUME_NONNULL_BEGIN
@interface SSTAccessAuthorization : NSObject

#pragma mark - 检查权限
/** 定位权限检测 */
+ (SSTAuthorizationStatus)checkAccessForLocationServices;
/** 通讯录权限检测 */
+ (SSTAuthorizationStatus)checkAccessForContacts;
/** 图片权限检测 */
+ (SSTAuthorizationStatus)checkAccessForPhotos;
/** 麦克风权限检测 */
+ (SSTAuthorizationStatus)checkAccessForMicrophone;
/** 相机权限检测 */
+ (SSTAuthorizationStatus)checkAccessForCamera:(BOOL)isRear;
//+ (SSTAuthorizationStatus)checkAccessForMicrophone;
#pragma mark - 检查权限
/*
 * 定位权限是否可用
 * @param currentVC 用来present一个alert VC
 * @param jumpSettering 是否跳转到设置页面开启权限
 * @param isAlert 不支持、没有描述、权限受限是否弹出alert
 * @param resultBlock 结果回调 isAvailable:当status为SSTAuthorizationStatus_NotDetermined或SSTAuthorizationLocaStatus_AlwaysUsage或SSTAuthorizationLocaStatus_WhenInUseUsage时返回YES
 */
+ (void)availableAccessForLocationServices:(UIViewController * _Nullable)currentVC
                             jumpSettering:(BOOL)jumpSettering
                         alertNotAvailable:(BOOL)isAlert
                               resultBlock:(SSTAuthorizationBlock)resultBlock;
/*
 * 通讯录权限是否可用
 * @param currentVC 用来present一个alert VC
 * @param jumpSettering 是否跳转到设置页面开启权限
 * @param isAlert 不支持、没有描述、权限受限是否弹出alert
 * @param resultBlock 结果回调 isAvailable:当status为SSTAuthorizationStatus_NotDetermined或SSTAuthorizationStatus_Authorized时返回YES
 */
+ (void)availablecheckAccessForContacts:(UIViewController * _Nullable)currentVC
                          jumpSettering:(BOOL)jumpSettering
                      alertNotAvailable:(BOOL)isAlert
                            resultBlock:(SSTAuthorizationBlock)resultBlock;
/*
 * 照片权限是否可
 * @param currentVC 用来present一个alert VC
 * @param jumpSettering 是否跳转到设置页面开启权限
 * @param isAlert 不支持、没有描述、权限受限是否弹出alert
// （用户从未进行过授权）会自己进行权限申请
 * @param resultBlock 结果回调 isAvailable:当status为SSTAuthorizationStatus_NotDetermined或SSTAuthorizationStatus_Authorized时返回YES
 */
+ (void)availablecheckAccessForPhotos:(UIViewController * _Nullable)currentVC
                        jumpSettering:(BOOL)jumpSettering
                    alertNotAvailable:(BOOL)isAlert
                          resultBlock:(SSTAuthorizationBlock)resultBlock;
/*
* 相机权限是否可用
* @param isRear YES:后置摄像头 NO:前置摄像头
* @param currentVC 用来present一个alert VC
* @param jumpSettering 是否跳转到设置页面开启权限
* @param isAlert 不支持、没有描述、权限受限是否弹出alert
 // （用户从未进行过授权）会自己进行权限申请
* @param resultBlock 结果回调 isAvailable:当status为SSTAuthorizationStatus_NotDetermined或SSTAuthorizationStatus_Authorized时返回YES
*/
+ (void)availablecheckAccessForCamera:(BOOL)isRear
                         presentingVC:(UIViewController * _Nullable)currentVC
                        jumpSettering:(BOOL)jumpSettering
                    alertNotAvailable:(BOOL)isAlert
                          resultBlock:(SSTAuthorizationBlock)resultBlock;

/*
 * 麦克风权限是否可用
 * @param currentVC 用来present一个alert VC
 * @param jumpSettering 是否跳转到设置页面开启权限
 * @param isAlert 不支持、没有描述、权限受限是否弹出alert
 * @param resultBlock 结果回调 isAvailable:当status为SSTAuthorizationStatus_NotDetermined或SSTAuthorizationStatus_Authorized时返回YES
 */
+ (void)availablecheckAccessForMicrophone:(UIViewController * _Nullable)currentVC
                            jumpSettering:(BOOL)jumpSettering
                        alertNotAvailable:(BOOL)isAlert
                              resultBlock:(SSTAuthorizationBlock)resultBlock;

@end

NS_ASSUME_NONNULL_END
