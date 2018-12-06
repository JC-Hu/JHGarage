//
//  Created by JasonHu on 2018/4/21.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//

#import "JHGBaseCell.h"



@implementation JHGBaseCell


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style
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

- (void)setupViews
{
    
}

- (void)setupConstraints
{
    
}


- (void)updateContentWithCellConfig:(JHCellConfig *)cellConfig
{
    
}


@end
