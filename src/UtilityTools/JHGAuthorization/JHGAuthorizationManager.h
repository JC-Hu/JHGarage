

#import <Foundation/Foundation.h>
/// 权限类型
typedef NS_ENUM (NSUInteger, JHGAuthorizationType) {
    /// IDFA权限
    JHGAuthorizationATTracking,
    /// 相机权限
    JHGAuthorizationCamera,
    /// 相册权限
    JHGAuthorizationPhotoAlbum,
    /// 麦克风权限
    JHGAuthorizationMicrophone,
    /// 通讯录权限
    JHGAuthorizationAddressBook,
};

NS_ASSUME_NONNULL_BEGIN

@interface JHGAuthorizationManager : NSObject
/// 权限操作
/// @param type 权限类型
/// @param result 认证结果
+ (void)requestAuthorizationWithType:(JHGAuthorizationType)type andResult:(void (^)(BOOL))result;
@end

NS_ASSUME_NONNULL_END
