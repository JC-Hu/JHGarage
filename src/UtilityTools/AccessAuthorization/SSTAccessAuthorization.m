
//

#import "SSTAccessAuthorization.h"
#import <CoreLocation/CoreLocation.h>
#import <Contacts/Contacts.h>
#import <AddressBook/AddressBook.h>

#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
@implementation SSTAccessAuthorization

#pragma mark - 检查权限
+ (SSTAuthorizationStatus)checkAccessForLocationServices {
   NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
   NSString *alwaysUsage = [info objectForKey:@"NSLocationAlwaysUsageDescription"];
   NSString *whenInUseUsage = [info objectForKey:@"NSLocationWhenInUseUsageDescription"];
    if (alwaysUsage == nil && whenInUseUsage == nil) {
        return SSTAuthorizationStatus_NotInfoDesc;
    }
    if ([CLLocationManager locationServicesEnabled] == NO) {
        return SSTAuthorizationStatus_NotSupport;
    }
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            return SSTAuthorizationStatus_NotDetermined;
        case kCLAuthorizationStatusRestricted:
            return SSTAuthorizationStatus_Restricted;
        case kCLAuthorizationStatusDenied:
            return SSTAuthorizationStatus_Denied;
        case kCLAuthorizationStatusAuthorizedAlways:
            return SSTAuthorizationLocaStatus_AlwaysUsage;
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            return SSTAuthorizationLocaStatus_WhenInUseUsage;
    }
}
+ (SSTAuthorizationStatus)checkAccessForContacts {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *desc = [info objectForKey:@"NSContactsUsageDescription"];
    if (desc == nil) {
         return SSTAuthorizationStatus_NotInfoDesc;
    }
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 9.0) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        return (SSTAuthorizationStatus)status;
    }else {
         ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
         return (SSTAuthorizationStatus)status;
    }
}
+ (SSTAuthorizationStatus)checkAccessForPhotos {
     NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
     NSString *desc = [info objectForKey:@"NSPhotoLibraryUsageDescription"];
  //  NSString *desc = [info objectForKey:@"NSPhotoLibraryUsageDescription"];
    if (desc == nil) {
        return SSTAuthorizationStatus_NotInfoDesc;
    }
     if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
         return SSTAuthorizationStatus_NotSupport;
     }
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    return (SSTAuthorizationStatus)status;
}
+ (SSTAuthorizationStatus)checkAccessForCamera:(BOOL)isRear {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *desc = [info objectForKey:@"NSCameraUsageDescription"];
    if (desc == nil) {
         return SSTAuthorizationStatus_NotInfoDesc;
    }
    
    if (![UIImagePickerController isCameraDeviceAvailable:isRear ? UIImagePickerControllerCameraDeviceRear : UIImagePickerControllerCameraDeviceFront]) {
        return SSTAuthorizationStatus_NotSupport;
    }
     AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
     return (SSTAuthorizationStatus)status;
}
+ (SSTAuthorizationStatus)checkAccessForMicrophone {
    NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
    NSString *desc = [info objectForKey:@"NSMicrophoneUsageDescription"];
    if (desc == nil) {
        return SSTAuthorizationStatus_NotInfoDesc;
    }
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    return (SSTAuthorizationStatus)status;
}
#pragma mark - 检查并请求权限
+ (void)availableAccessForLocationServices:(UIViewController *)currentVC
                             jumpSettering:(BOOL)jumpSettering
                         alertNotAvailable:(BOOL)isAlert
                               resultBlock:(SSTAuthorizationBlock)resultBlock {
    SSTAuthorizationStatus status = [self checkAccessForLocationServices];
    BOOL isAvail = NO;
    if (status == SSTAuthorizationStatus_NotSupport) {
        if (isAlert) {
            NSString *title = @"打开定位开关";
            NSString *message = [NSString stringWithFormat:@"定位服务未开启，请进入系统【设置】>【隐私】>【定位服务】中打开开关，并允许%@使用定位服务", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=LOCATION_SERVICES"];

        }
       
    }else if (status == SSTAuthorizationStatus_Denied || status == SSTAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"开启定位服务";
            NSString *message = [NSString stringWithFormat:@"定位服务受限，请进入系统【设置】>【隐私】>【定位服务】中允许%@使用定位服务", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=LOCATION_SERVICES"];

            }
    }else if (status == SSTAuthorizationStatus_NotInfoDesc){
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
                            resultBlock:(SSTAuthorizationBlock)resultBlock; {
    SSTAuthorizationStatus status = [self checkAccessForContacts];
    BOOL isAvail = NO;
    if (status == SSTAuthorizationStatus_Denied || status == SSTAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"访问通讯录受限";
            NSString *message = [NSString stringWithFormat:@"通讯录访问受限，请进入系统【设置】>【隐私】>【通讯录】中允许%@访问你的通讯录", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=Contacts"];

        }
    }else if (status == SSTAuthorizationStatus_NotInfoDesc){
        NSString *title = @"访问受限";
        NSString *message = @"请在配置文件中设置描述";

        [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];
     
        
    } else if (status == SSTAuthorizationStatus_Authorized){
        
        isAvail = YES;
    }else{
        ABAddressBookRef bookRef = ABAddressBookCreate();
        ABAddressBookRequestAccessWithCompletion(bookRef, ^(bool granted, CFErrorRef error) {
            if (granted)
            {
                if (resultBlock) {
                    resultBlock(YES, (SSTAuthorizationStatus)status);
                }
            }else{
                if (resultBlock) {
                    resultBlock(NO, (SSTAuthorizationStatus)status);
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
                          resultBlock:(SSTAuthorizationBlock)resultBlock {
    SSTAuthorizationStatus status = [self checkAccessForPhotos];
    BOOL isAvail = NO;
    if (status == SSTAuthorizationStatus_NotSupport) {
        if (isAlert) {
            NSString *title = @"照片不可用";
            NSString *message = @"设备不支持照片，请更换设备后再试";

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];

        }
        
    }else if (status == SSTAuthorizationStatus_Denied || status == SSTAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"访问照片受限";
            NSString *message = [NSString stringWithFormat:@"照片访问受限，请进入系统【设置】>【隐私】>【照片】中允许%@访问照片", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=Photos"];

        }
    }else if (status == SSTAuthorizationStatus_NotInfoDesc){
        if (isAlert) {
            NSString *title = @"访问受限";
            NSString *message = @"请在配置文件中设置描述";

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];

        }
    } else if (status == SSTAuthorizationStatus_Authorized){
      
        isAvail = YES;
    }else{
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                if (resultBlock) {
                    resultBlock(YES, (SSTAuthorizationStatus)status);
                }
            }else{
                if (resultBlock) {
                    resultBlock(NO, (SSTAuthorizationStatus)status);
                }
            }
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
                          resultBlock:(SSTAuthorizationBlock)resultBlock {
    SSTAuthorizationStatus status = [self checkAccessForCamera:isRear];
    BOOL isAvail = NO;
    if (status == SSTAuthorizationStatus_NotSupport) {
        if (isAlert) {
            NSString *deviceName = isRear ? @"后置摄像头" : @"前置摄像头";
            NSString *title = [deviceName stringByAppendingString:@"不可用"];
            NSString *message = [deviceName stringByAppendingString:@"不支持，请更换设备后再试"];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];

        }
        
    }else if (status == SSTAuthorizationStatus_Denied || status == SSTAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"访问相机受限";
            NSString *message = [NSString stringWithFormat:@"相机访问受限，请进入系统【设置】>【隐私】>【相机】中允许%@访问相机", [self appName]];

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=Camera"];

        }
    }else if (status == SSTAuthorizationStatus_NotInfoDesc){
        if (isAlert) {
            NSString *title = @"访问受限";
            NSString *message = @"请在配置文件中设置描述";

            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];

        }
    } else if (status == SSTAuthorizationStatus_Authorized){
        isAvail = YES;
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
            if (granted) {
                if (resultBlock) {
                    resultBlock(YES, (SSTAuthorizationStatus)status);
                }
            }else{
                if (resultBlock) {
                    resultBlock(NO, (SSTAuthorizationStatus)status);
                }
            }
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
                              resultBlock:(SSTAuthorizationBlock)resultBlock {
    SSTAuthorizationStatus status = [self checkAccessForMicrophone];
    BOOL isAvail = NO;
    if (status == SSTAuthorizationStatus_NotSupport) {
        if (isAlert) {
            NSString *title = @"麦克风不可用";
            NSString *message = @"设备不支持麦克风，请更换设备后再试";
            
            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];
            
        }
        
    }else if (status == SSTAuthorizationStatus_Denied || status == SSTAuthorizationStatus_Restricted) {
        if (isAlert) {
            NSString *title = @"访问麦克风受限";
            NSString *message = [NSString stringWithFormat:@"麦克风访问受限，请进入系统【设置】>【隐私】>【麦克风】中允许%@访问麦克风", [self appName]];
            
            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:@"root=Photos"];
            
        }
    }else if (status == SSTAuthorizationStatus_NotInfoDesc){
        if (isAlert) {
            NSString *title = @"访问受限";
            NSString *message = @"请在配置文件中设置描述";
            
            [self showAlertVCWithTitle:title message:message currentVC:currentVC jumpSettering:jumpSettering settingURLString:nil];
            
        }
    } else if (status == SSTAuthorizationStatus_Authorized){
        
        isAvail = YES;
    }else{
        [AVCaptureDevice requestAccessForMediaType:AVMediaTypeAudio completionHandler:^(BOOL granted) {
            if (resultBlock) {
                if (granted) {
                    resultBlock(YES, (SSTAuthorizationStatus)status);
                }else{
                    resultBlock(NO, (SSTAuthorizationStatus)status);
                }
            }
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
    if ([UIDevice currentDevice].systemVersion.floatValue >= 10.0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"App-Prefs:" stringByAppendingString:string]] options:@{} completionHandler:nil];
    }else{

        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[@"prefs:" stringByAppendingString:string]]];

    }
    
}
+ (BOOL)whetherCanJumpToSetting {
    static BOOL canJump = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *info = [[NSBundle mainBundle] infoDictionary];
        NSArray *URLTypes = [info objectForKey:@"CFBundleURLTypes"];
        for (NSDictionary *childURLs in URLTypes) {
            NSArray *URLScheme = [childURLs objectForKey:@"CFBundleURLSchemes"];
            if ([URLScheme isKindOfClass:[NSArray class]]  && URLScheme.count) {
                for (NSString *string in URLScheme) {
                    if ([string isKindOfClass:[NSString class]] && [string isEqualToString:@"prefs"]) {
                        canJump = YES;
                        break;
                    }
                }

            }
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
