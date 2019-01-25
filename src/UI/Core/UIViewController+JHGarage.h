//
//  UIViewController+JHGarage.h
//  JHGarage
//
//  Created by Jason Hu on 2018/12/13.
//  Copyright © 2018 Jason Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Masonry/Masonry.h>
#import <JHCellConfig/JHCellConfig.h>
#import "UIView+JHGShortcut.h"


@class JHGRequestItem;


@interface UIViewController (JHGarage) 

#pragma mark - Toast
- (void)showToast:(NSString *)str;
- (void)showToastInNCView:(NSString *)str;
- (void)showToastNetworkError;
- (void)showToastInNCViewNetworkError;

#pragma - HTTP
- (void)requestWithItem:(JHGRequestItem *)item;
- (void)requestWithItemNoHUD:(JHGRequestItem *)item;
- (void)requestWithItemOnlyError:(JHGRequestItem *)item;

#pragma mark - HUD
- (void)showLoadingHUD;
- (void)hideHUD;




@end

