//
//  Created by Jason Hu on 2018/12/28.
//

#import "JHGBlankView.h"
#import "Masonry.h"
#import "JHFontMacro.h"

@implementation JHGBlankView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        [self setupContraints];
    }
    return self;
}

- (void)setupViews
{
    self.backgroundColor = [UIColor whiteColor];

    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    [self addSubview:self.hintLabel];
    [self addSubview:self.refreshButton];
}

- (void)setupContraints
{
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.bottom.mas_equalTo(self.titleLabel.mas_top).offset(-15);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(30);
    }];
    
    [self.hintLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.refreshButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(88);
        make.height.mas_equalTo(28);
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).offset(12);
    }];
    
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [UIImageView new];
    }
    return _imageView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        _titleLabel.font = Font_16;
        _titleLabel.textColor = UIColor.grayColor;
    }
    return _titleLabel;
}

- (UILabel *)hintLabel
{
    if (!_hintLabel) {
        _hintLabel = [UILabel new];
        _hintLabel.font = Font_14;
        _hintLabel.textColor = UIColor.lightGrayColor;
    }
    return _hintLabel;
}

- (UIButton *)refreshButton
{
    if (!_refreshButton) {
        _refreshButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [_refreshButton setTitle:@"重新加载" forState:UIControlStateNormal];
        [_refreshButton setTitleColor:UIColor.grayColor forState:UIControlStateNormal];
        _refreshButton.layer.cornerRadius = 4;
        _refreshButton.layer.borderColor = UIColor.lightGrayColor.CGColor;
        _refreshButton.layer.borderWidth = 1;
        
    }
    return _refreshButton;
}


@end
