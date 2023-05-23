//
//  Created by JasonHu on 2018/4/21.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//

#import "UITableViewCell+JHCellConfig.h"

@interface JHGSeparatorCell : UITableViewCell

@property (nonatomic, strong) UIView *mainView;

@end

@interface JHGSeparatorCellModel : NSObject

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, strong) UIColor *color;

@property (nonatomic, assign) CGFloat leftInset;
@property (nonatomic, assign) CGFloat rightInset;

@end
