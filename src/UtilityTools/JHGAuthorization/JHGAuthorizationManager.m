

#import "JHGAuthorizationManager.h"
#import <AVKit/AVKit.h>
#import <Photos/Photos.h>
#import <Contacts/CNContactStore.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <AdSupport/ASIdentifierManager.h>

@implementation JHGAuthorizationManager
/// 权限操作
/// @param type 权限类型
/// @param result 认证结果
+ (void)requestAuthorizationWithType:(JHGAuthorizationType)type andResult:(void (^)(BOOL))result {
    switch (type) {
        case JHGAuthorizationATTracking:
        {
            if (@available(iOS 14, *)) {
                    // iOS14及以上版本需要先请求权限
                    [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
                        result(status);
                    }];
                } else {
                    // iOS14以下版本依然使用老方法
                    // 判断在设置-隐私里用户是否打开了广告跟踪
                    if ([[ASIdentifierManager sharedManager] isAdvertisingTrackingEnabled]) {
                        result(YES);
                    } else {
                        result(NO);
                    }
                }
        }
            break;
        case JHGAuthorizationCamera:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                
                if (result) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        result(granted);
                    });
                }
            }];
        }
            break;
        case JHGAuthorizationPhotoAlbum:
        {
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                
                if (result) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        result(status == PHAuthorizationStatusAuthorized);
                    });
                }
            }];
        }
            break;
        case JHGAuthorizationMicrophone:
        {
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
                
                if (result) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        result(granted);
                    });
                }
            }];
        }
            break;
        case JHGAuthorizationAddressBook:
        {
            [[CNContactStore new] requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                
                if (result) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        result(granted);
                    });
                }
            }];
        }
            break;
            
        default:
            break;
    }
}
@end
