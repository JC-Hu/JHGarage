//
//  UITableViewCell+JHCellConfig.h
//  JHGarage
//
//  Created by Jason Hu on 2019/1/4.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <JHCellConfig/JHCellConfig.h>
#import <Masonry/Masonry.h>
#import <YYCategories/UIView+YYAdd.h>

@interface UITableViewCell (JHCellConfig) <JHCellConfigProtocol>

@property (nonatomic, strong) JHCellConfig *jhg_cellConfig;


@end

