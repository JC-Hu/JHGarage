//
//  Created by JasonHu on 2018/12/6.
//  Copyright © 2018年 Jingchen Hu. All rights reserved.
//


#import <UIKit/UIKit.h>

@interface UIImage (JHGColor)
+ (UIImage *)imageWithColor:(UIColor *)color;
//more accurate method ,colorAtPixel 1x1 pixel
- (UIColor *)colorAtPixel:(CGPoint)point;
//返回该图片是否有透明度通道
- (BOOL)hasAlphaChannel;


@end
