//
//  UIAlertController+JHGAlert.h
//
//  Created by Jason Hu on 2020/10/27.
//

#import <UIKit/UIKit.h>


@interface UIAlertController (JHGAlert)

+ (void)showAlertWithTitle:(NSString *)title
                   message:(NSString *)message
                        vc:(UIViewController *)vc
           lastDestructive:(BOOL)lastDestructive
              buttonTitle1:(NSString *)buttonTitle1
              buttonTitle2:(NSString *)buttonTitle2
              buttonBlock1:(void (^)(void))buttonBlock1
              buttonBlock2:(void (^)(void))buttonBlock2;

+ (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                              vc:(UIViewController *)vc
                 lastDestructive:(BOOL)lastDestructive
                    buttonTitle1:(NSString *)buttonTitle1
                    buttonTitle2:(NSString *)buttonTitle2
                    buttonBlock1:(void (^)(void))buttonBlock1
                    buttonBlock2:(void (^)(void))buttonBlock2;

+ (void)showActionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                              vc:(UIViewController *)vc
                 lastDestructive:(BOOL)lastDestructive
                    buttonTitles:(NSArray <NSString *>*)buttonTitles
                     buttonBlock:(void (^)(NSInteger index, NSString *buttonTitle))buttonBlock;



@end

