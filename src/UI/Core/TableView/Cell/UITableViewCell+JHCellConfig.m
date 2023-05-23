//
//  UITableViewCell+JHCellConfig.m
//  JHGarage
//
//  Created by Jason Hu on 2019/1/4.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import "UITableViewCell+JHCellConfig.h"

#import <objc/runtime.h>


static NSString * const JHCellConfig_Key_CellConfig;

@implementation UITableViewCell (JHCellConfig)


- (void)updateContentWithCellConfig:(JHCellConfig *)cellConfig
{
    
}

+ (CGFloat)cellHeightWithCellConfig:(JHCellConfig *)cellConfig
{
    return 44;
}

#pragma mark
- (void)setJhg_cellConfig:(JHCellConfig *)cellConfig
{
    objc_setAssociatedObject(self, &JHCellConfig_Key_CellConfig, cellConfig, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (JHCellConfig *)jhg_cellConfig
{
    JHCellConfig *_value = objc_getAssociatedObject(self, &JHCellConfig_Key_CellConfig);
    return _value;
}

@end
