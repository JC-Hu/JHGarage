//
//  Created by JasonHu on 2018/4/21.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JHCellConfig/JHCellConfig.h>
#import <Masonry/Masonry.h>
#import "UIView+JHGShortcut.h"

@interface JHGBaseCell : UITableViewCell <JHCellConfigProtocol>

@property (nonatomic, strong) JHCellConfig *cellConfig;

- (void)setupViews;
- (void)setupConstraints;


@end
