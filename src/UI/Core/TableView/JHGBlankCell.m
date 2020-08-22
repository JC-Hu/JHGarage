//
//  Created by JasonHu on 2018/4/21.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//
#import "JHGBlankCell.h"

@implementation JHGBlankCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [self setupViews];
        [self setupConstraints];
    }
    return self;
}

// 添加视图
- (void)setupViews
{
    
}

// 布局
- (void)setupConstraints
{
    
}

- (void)updateContentWithCellConfig:(JHCellConfig *)cellConfig
{
    JHGBlankCellModel *model = self.cellConfig.dataModel;
    
    self.contentView.backgroundColor = model.color;
    self.backgroundColor = model.color;
}

+ (CGFloat)cellHeightWithCellConfig:(JHCellConfig *)cellConfig
{
    JHGBlankCellModel *model = cellConfig.dataModel;
    
    return model.height;
}

@end

@implementation JHGBlankCellModel


@end
