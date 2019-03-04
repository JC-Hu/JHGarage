//
//  JHGTouchButton.m
//  JHGarage
//
//  Created by Jason Hu on 2019/3/4.
//  Copyright © 2019 Jason Hu. All rights reserved.
//

#import "JHGTouchButton.h"

@implementation JHGTouchButton

- (CGSize)hotZone
{
    if (CGSizeEqualToSize(CGSizeZero, _hotZone)) {
        _hotZone = CGSizeMake(50, 50);
    }
    return _hotZone;
}


- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = MAX(self.hotZone.width - bounds.size.width, 0);
    CGFloat heightDelta = MAX(self.hotZone.height - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end
