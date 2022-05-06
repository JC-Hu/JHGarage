
//

#import "JHGAccessAuthorization.h"
#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
@implementation JHGAccessAuthorization

#pragma mark - 检查权限
+ (JHGAuthorizationStatus)checkAccessForLocationServices {
   NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
   NSString *alwaysUsage = [info objectForKey:@"NSLocationAlwaysUsageDescription"];
   NSString *whenInUseUsage = [info objectForKey:@"NSLocationWhenInUseUsageDescription"];
    if (alwaysUsage == nil && whenInUseUsage == nil) {
        return JHGAuthorizationStatus_NotInfoDesc;
    }
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return JHGAuthorizationStatus_NotSupport;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            return JHGAuthorizationStatus_NotDetermined;
        case kCLAuthorizationStatusRestricted:
            return JHGAuthorizationStatus_Restricted;
        case kCLAuthorizationStatusDenied:
            return JHGAuthorizationStatus_Denied;
        case kCLAuthorizationStatusAuthorizedAlways:
            return JHGAuthorizationLocaStatus_AlwaysUsage;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return JHGAuthorizationLocaStatus_WhenInUseUsage;
    }
}
+ (JHGAuthorizationStatus)checkAccessForContacts {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *desc = [info objectForKey:@"NSContactsUsageDescription"];
    if (desc == nil) {
         return JHGAuthorizationStatus_NotInfoDesc;
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        return (JHGAuthorizationStatus)status;
    }else {
         ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
         return (JHGAuthorizationStatus)status;
    }
}
+ (JHGAuthorizationStatus)checkAccessForPhotos {
     NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
     NSString *desc = [info objectForKey:@"NSPhotoLibraryUsageDescription"];
  //  NSString *desc = [info objectForKey:@"NSPhotoLibraryUsageDescription"];
    if (desc == nil) {
        return JHGAuthorizationStatus_NotInfoDesc;
    }
     if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
         return JHGAuthorizationStatus_NotSupport;
     }
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return (JHGAuthorizationStatus)status;
}
+ (JHGAuthorizationStatus)checkAccessForCamera:(BOOL)isRear {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *desc = [info objectForKey:@"NSCameraUsageDescription"];
    if (desc == nil) {
         return JHGAuthorizationStatus_NotInfoDesc;
    }
    
    if (![UIImagePickerController isCameraDeviceAvailable:isRear ? UIImagePickerControllerCameraDeviceRear : UIImagePickerControllerCameraDeviceFront]) {
        return JHGAuthorizationStatus_NotSupport;
    }
     AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
     return (JHGAuthorizationStatus)status;
}
+ (JHGAuthorizationStatus)checkAccessForMicrophone {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *desc = [info objectForKey:@"NSMicrophoneUsageDescription"];
    if (desc == nil) {
        return JHGAuthorizationStatus_NotInfoDesc;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return (JHGAuthorizationStatus)status;
}
#pragma mark - 检查并请求权限
+ (void)availableAccessForLocationServices:(UIViewController *)currentVC
                             jumpSettering:(BOOL)jumpSettering
                         alertNotAvailable:(BOOL)isAlert
                               resultBlock:(JHGAuthorizationBlock)resultBlock {
    JHGAuthorizationStatus status = [self checkAccessForLocationServices];
    BOOL isAvail = NO;
    if (status == JHGAuthorizationStatus_NotSupport) {
        if (isAlert) {
            NSString *title = @"打开定位开关";
            NSString *message = [NSString stringWithFormat:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许%@使用定位服务", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=LOCATION_SERVICES"];

        }
       
    }else if (status == JHGAuthorizationStatus_Denied || status == JHGAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"开启定位服务";
            NSString *message = [NSString stringWithFormat:@"定位服务受限，请进入App设置中允许%@使用定位服务", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=LOCATION_SERVICES"];

            }
    }else if (status == JHGAuthorizationStatus_NotInfoDesc){
        if (isAlert) {
            NSString *title = @"访问受限";
            NSString *message = @"请在配置文件中设置描述";

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];

        }
    } else {
        isAvail = YES;
    }
    if (resultBlock) {
        resultBlock(isAvail, status);
    }
}
+ (void)availablecheckAccessForContacts:(UIViewController *)currentVC
                          jumpSettering:(BOOL)jumpSettering
                      alertNotAvailable:(BOOL)isAlert
                            resultBlock:(JHGAuthorizationBlock)resultBlock; {
    JHGAuthorizationStatus status = [self checkAccessForContacts];
    BOOL isAvail = NO;
    if (status == JHGAuthorizationStatus_Denied || status == JHGAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"访问通讯录受限";
            NSString *message = [NSString stringWithFormat:@"通讯录访问受限，请进入App设置中允许%@访问你的通讯录", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=Contacts"];

        }
    }else if (status == JHGAuthorizationStatus_NotInfoDesc){
        NSString *title = @"访问受限";
        NSString *message = @"请在配置文件中设置描述";

        [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];
     
        
    } else if (status == JHGAuthorizationStatus_Authorized){
        
        isAvail = YES;
    }else{
        ABAddressBookRef bookRef = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
            if (granted)
            {
                if (resultBlock) {
                    resultBlock(YES, (JHGAuthorizationStatus)status);
                }
            }else{
                if (resultBlock) {
                    resultBlock(NO, (JHGAuthorizationStatus)status);
                }
            }
        });
        return;
    }
    if (resultBlock) {
        resultBlock(isAvail, status);
    }
}
+ (void)availablecheckAccessForPhotos:(UIViewController *)currentVC
                        jumpSettering:(BOOL)jumpSettering
                    alertNotAvailable:(BOOL)isAlert
                          resultBlock:(JHGAuthorizationBlock)resultBlock {
    JHGAuthorizationStatus status = [self checkAccessForPhotos];
    BOOL isAvail = NO;
    if (status == JHGAuthorizationStatus_NotSupport) {
        if (isAlert) {
            NSString *title = @"照片不可用";
            NSString *message = @"设备不支持照片，请更换设备后再试";

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];

        }
        
    }else if (status == JHGAuthorizationStatus_Denied || status == JHGAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"访问照片受限";
            NSString *message = [NSString stringWithFormat:@"照片访问受限，请进入App设置中允许%@访问照片", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=Photos"];

        }
    }else if (status == JHGAuthorizationStatus_NotInfoDesc){
        if (isAlert) {
            NSString *title = @"访问受限";
            NSString *message = @"请在配置文件中设置描述";

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];

        }
    } else if (status == JHGAuthorizationStatus_Authorized){
      
        isAvail = YES;
    }else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (status == PHAuthorizationStatusAuthorized) {
                    if (resultBlock) {
                        resultBlock(YES, (JHGAuthorizationStatus)status);
                    }
                }else{
                    if (resultBlock) {
                        resultBlock(NO, (JHGAuthorizationStatus)status);
                    }
                }
            });
        }];
        
        return;
    }
    if (resultBlock) {
        resultBlock(isAvail, status);
    }
}
+ (void)availablecheckAccessForCamera:(BOOL)isRear
                         presentingVC:(UIViewController *)currentVC
                        jumpSettering:(BOOL)jumpSettering
                    alertNotAvailable:(BOOL)isAlert
                          resultBlock:(JHGAuthorizationBlock)resultBlock {
    JHGAuthorizationStatus status = [self checkAccessForCamera:isRear];
    BOOL isAvail = NO;
    if (status == JHGAuthorizationStatus_NotSupport) {
        if (isAlert) {
            NSString *deviceName = isRear ? @"后置摄像头" : @"前置摄像头";
            NSString *title = [deviceName stringByAppendingString:@"不可用"];
            NSString *message = [deviceName stringByAppendingString:@"不支持，请更换设备后再试"];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];

        }
        
    }else if (status == JHGAuthorizationStatus_Denied || status == JHGAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"访问相机受限";
            NSString *message = [NSString stringWithFormat:@"相机访问受限，请进入App设置中允许%@访问相机", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=Camera"];

        }
    }else if (status == JHGAuthorizationStatus_NotInfoDesc){
        if (isAlert) {
            NSString *title = @"访问受限";
            NSString *message = @"请在配置文件中设置描述";

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];

        }
    } else if (status == JHGAuthorizationStatus_Authorized){
        isAvail = YES;
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    if (resultBlock) {
                        resultBlock(YES, (JHGAuthorizationStatus)status);
                    }
                }else{
                    if (resultBlock) {
                        resultBlock(NO, (JHGAuthorizationStatus)status);
                    }
                }
            });
        }];
        return;
    }
    if (resultBlock) {
        resultBlock(isAvail, status);
    }
}

+ (void)availablecheckAccessForMicrophone:(UIViewController * _Nullable)currentVC
                            jumpSettering:(BOOL)jumpSettering
                        alertNotAvailable:(BOOL)isAlert
                              resultBlock:(JHGAuthorizationBlock)resultBlock {
    JHGAuthorizationStatus status = [self checkAccessForMicrophone];
    BOOL isAvail = NO;
    if (status == JHGAuthorizationStatus_NotSupport) {
        if (isAlert) {
            NSString *title = @"麦克风不可用";
            NSString *message = @"设备不支持麦克风，请更换设备后再试";
            
            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];
            
        }
        
    }else if (status == JHGAuthorizationStatus_Denied || status == JHGAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"访问麦克风受限";
            NSString *message = [NSString stringWithFormat:@"麦克风访问受限，请进入App设置中允许%@访问麦克风", [self appName]];
            
            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=Photos"];
            
        }
    }else if (status == JHGAuthorizationStatus_NotInfoDesc){
        if (isAlert) {
            NSString *title = @"访问受限";
            NSString *message = @"请在配置文件中设置描述";
            
            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];
            
        }
    } else if (status == JHGAuthorizationStatus_Authorized){
        
        isAvail = YES;
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (resultBlock) {
                    if (granted) {
                        resultBlock(YES, (JHGAuthorizationStatus)status);
                    }else{
                        resultBlock(NO, (JHGAuthorizationStatus)status);
                    }
                }
            });
        }];
        
        return;
    }
    if (resultBlock) {
        resultBlock(isAvail, status);
    }
}
#pragma mark - Helper
+ (void)showAlertVCWithTitle:(NSString *)title
                     message:(NSString *)message
                   currentVC:(UIViewController *)currentVC
               jumpSettering:(BOOL)jumpSettering
            settingURLString:(NSString *)settingURLString {
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    if (currentVC == nil) {
        currentVC = [[[UIApplication sharedApplication].delegate window] rootViewController];
    }
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:cancel];

    if (jumpSettering && settingURLString && [self whetherCanJumpToSetting]) {

        UIAlertAction *jump = [UIAlertAction actionWithTitle:@"去开启" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self openURLString:settingURLString];
        }];
        [alertVC addAction:jump];
    }
    [currentVC presentViewController:alertVC animated:YES completion:nil];
}

+ (void)openURLString:(NSString *)string {
    
    NSURL * settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
        
        [[UIApplication sharedApplication] openURL:settingUrl options:@{} completionHandler:nil];
    }
}
+ (BOOL)whetherCanJumpToSetting {
    static BOOL canJump = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURL * settingUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:settingUrl]) {
            canJump = YES;
        }
    });
    return canJump;
}
+ (NSString *)appName{
    NSString *dispalyName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    if (dispalyName == nil) {
      dispalyName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
    }
    return dispalyName;
}

@end
