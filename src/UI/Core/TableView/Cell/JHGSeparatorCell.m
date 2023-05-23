//
//  Created by JasonHu on 2018/4/21.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//
#import "JHGSeparatorCell.h"

@implementation JHGSeparatorCell

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
    [self.contentView addSubview:self.mainView];
}

// 布局
- (void)setupConstraints
{
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (void)updateContentWithCellConfig:(JHCellConfig *)cellConfig
{
    JHGSeparatorCellModel *model = self.jhg_cellConfig.dataModel;
    
    self.mainView.backgroundColor = model.color;
    
    [self.mainView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.left.mas_equalTo(model.leftInset);
        make.right.mas_equalTo(-model.rightInset);
        make.top.bottom.mas_equalTo(0);
    }];
}

+ (CGFloat)cellHeightWithCellConfig:(JHCellConfig *)cellConfig
{
    JHGSeparatorCellModel *model = cellConfig.dataModel;
    
    return model.height;
}

- (UIView *)mainView
{
    if (!_mainView) {
        _mainView = [UIView new];
    }
    return _mainView;
}

@end

@implementation JHGSeparatorCellModel


@end
