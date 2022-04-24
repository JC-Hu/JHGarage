

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface JHGQRCodeUtil : NSObject

/**
 *  生成二维码
 *  @param string url
 *  @param size  图片宽度
 */
+ (UIImage *)createQRCodeImageWithString:(NSString *)string size:(CGFloat)size;

/**
 *  生成带icon二维码
 *
 *  @param image 根据CIImage生成的UIImage
 *  @param icon  图片
 *  @param iconSize icon尺寸
 *  @param cornerRadius icon圆角
 *  @param lineWidth icon边宽度
 */
+ (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon andIconSize:(CGSize)iconSize cornerRadius:(CGFloat)cornerRadius lineWidth:(CGFloat)lineWidth;

/**
 *  生成指定颜色二维码
 *
 *  @param qrCodeImage 根据CIImage生成的UIImage
 *  @param red 红色
 *  @param green 绿色
 *  @param blue 蓝色
 */

+ (UIImage *)createQRCodeImage:(UIImage *)qrCodeImage WithRedColor:(CGFloat)red WithGreenColor:(CGFloat)green WithBlueColor:(CGFloat)blue;
@end

NS_ASSUME_NONNULL_END
