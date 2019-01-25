//
//  UIViewController+JHGBlankView.m
//  JHGarage
//
//  Created by Jason Hu on 2019/1/25.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import "UIViewController+JHGBlankView.h"

#import <objc/runtime.h>
#import "JHGSwizzle.h"

static NSString * const JHGarage_Key_BlankView;


@implementation UIViewController (JHGBlankView)

- (void)setupBlankView
{
    // blankView
    [self.view addSubview:self.jhg_blankView];
    [self.jhg_blankView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    self.jhg_blankView.hidden = YES;
}

#pragma mark - BlankView
- (void)showBlankViewForState:(JHBlankContentState)state
{
    self.jhg_blankView.hidden = NO;
    [self.view bringSubviewToFront:self.jhg_blankView];
    
    [self updateBlankViewWithState:state];
}

- (void)hideBlankView
{
    self.jhg_blankView.hidden = YES;
}

- (void)updateBlankViewWithState:(JHBlankContentState)state
{
    
}

- (void)blankViewRefreshAction:(id)sender
{
    
    
}

#pragma mark
- (void)setJhg_blankView:(JHGBlankView *)blankView
{
    objc_setAssociatedObject(self, &JHGarage_Key_BlankView, blankView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (JHGBlankView *)jhg_blankView
{
    JHGBlankView *_value = objc_getAssociatedObject(self, &JHGarage_Key_BlankView);
    if (!_value) {
        _value = [JHGBlankView new];
        self.jhg_blankView = _value;
        [_value.refreshButton addTarget:self action:@selector(blankViewRefreshAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _value;
}


@end
