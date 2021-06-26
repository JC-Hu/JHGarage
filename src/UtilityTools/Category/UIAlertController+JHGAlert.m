//
//  UIAlertController+JHGAlert.m
//
//  Created by Jason Hu on 2020/10/27.
//

#import "UIAlertController+JHGAlert.h"

@implementation UIAlertController (JHGAlert)


+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                        vc:(UIViewController *)vc
           lastDestructive:(BOOL)lastDestructive
              buttonTitle1:(NSString *)buttonTitle1
              buttonTitle2:(NSString *)buttonTitle2
              buttonBlock1:(void (^)(void))buttonBlock1
              buttonBlock2:(void (^)(void))buttonBlock2
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    if (buttonTitle1) {
        [alert addAction:[UIAlertAction actionWithTitle:buttonTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (buttonBlock1) {
                buttonBlock1();
            }
        }]];
    }
    
    if (buttonTitle2) {
        [alert addAction:[UIAlertAction actionWithTitle:buttonTitle2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (buttonBlock2) {
                buttonBlock2();
            }
        }]];
    }
    [vc?:UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                              vc:(UIViewController *)vc
                 lastDestructive:(BOOL)lastDestructive
                    buttonTitle1:(NSString *)buttonTitle1
                    buttonTitle2:(NSString *)buttonTitle2
                    buttonBlock1:(void (^)(void))buttonBlock1
                    buttonBlock2:(void (^)(void))buttonBlock2
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (buttonTitle1) {
        [alert addAction:[UIAlertAction actionWithTitle:buttonTitle1 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (buttonBlock1) {
                buttonBlock1();
            }
        }]];
    }
    
    if (buttonTitle2) {
        [alert addAction:[UIAlertAction actionWithTitle:buttonTitle2 style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (buttonBlock2) {
                buttonBlock2();
            }
        }]];
    }
    [vc?:UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}

+ (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                              vc:(UIViewController *)vc
                 lastDestructive:(BOOL)lastDestructive
                    buttonTitles:(NSArray <NSString *>*)buttonTitles
                    buttonBlock:(void (^)(NSInteger index, NSString *buttonTitle))buttonBlock
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < buttonTitles.count; i++) {
        NSString *buttonTitle = buttonTitles[i];
        if (buttonTitle.length) {
            UIAlertActionStyle style = lastDestructive&&(i==buttonTitles.count-1)?UIAlertActionStyleDestructive: UIAlertActionStyleDefault;
            
            [alert addAction:[UIAlertAction actionWithTitle:buttonTitle style:style handler:^(UIAlertAction * _Nonnull action) {
                if (buttonBlock) {
                    buttonBlock(i, buttonTitle);
                }
            }]];
        }
    }
    [vc?:UIApplication.sharedApplication.keyWindow.rootViewController presentViewController:alert animated:YES completion:nil];
}



@end
