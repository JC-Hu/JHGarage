

#import "JHGQRCodeUtil.h"

@implementation JHGQRCodeUtil


/**
 *  生成二维码
 *  @param string url
 *  @param size  图片宽度
 */
+ (UIImage *)createQRCodeImageWithString:(NSString *)string size:(CGFloat)size {
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    [filter setValue:data forKeyPath:@"inputMessage"];
    CIImage *image = [filter outputImage];
    UIImage *qrCodeImage = [self createNonInterpolatedUIImageFormCIImage:image withSize:size];
    return qrCodeImage;
}

/**
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    CGColorSpaceRelease(cs);
    return [UIImage imageWithCGImage:scaledImage];
}

/**
 *  生成带icon二维码
 *
 *  @param image 根据CIImage生成的UIImage
 *  @param icon  图片
 *  @param iconSize icon尺寸
 *  @param cornerRadius icon圆角
 *  @param lineWidth icon边宽度
 */
+ (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon andIconSize:(CGSize)iconSize cornerRadius:(CGFloat)cornerRadius lineWidth:(CGFloat)lineWidth {
    
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0);
//    UIGraphicsGetCurrentContext();
    
    CGFloat imageWidth = image.size.width;
    CGFloat imageHeight = image.size.height;
    CGFloat iconWidth = iconSize.width;
    CGFloat iconHeight = iconSize.height;
    
    [image drawInRect:CGRectMake(0, 0, imageWidth, imageHeight)];
    
    [[UIColor whiteColor] set];
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake((imageWidth-iconSize.width)/2.0, (imageHeight-iconSize.height)/2.0, iconSize.height, iconSize.height) cornerRadius:cornerRadius];
    path.lineWidth = lineWidth;
    [path stroke];
    [path addClip];
    
    [icon drawInRect:CGRectMake((imageWidth-iconWidth)/2.0, (imageHeight-iconHeight)/2.0, iconWidth, iconHeight)];
    UIImage *finalImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return finalImg;
}

/**
 *  生成指定颜色二维码
 *
 *  @param qrCodeImage 根据CIImage生成的UIImage
 *  @param red 红色
 *  @param green 绿色
 *  @param blue 蓝色
 */

+ (UIImage *)createQRCodeImage:(UIImage *)qrCodeImage WithRedColor:(CGFloat)red WithGreenColor:(CGFloat)green WithBlueColor:(CGFloat)blue {
    // 转成彩色
    qrCodeImage = [self imageBlackToTransparent:qrCodeImage withRed:red andGreen:green andBlue:blue];
    return qrCodeImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size){
    free((void*)data);}
// 输出彩色图片
+ (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900)    // 将白色变成透明
        {
            // 改成下面的代码，会将图片转成想要的颜色
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }
        else
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    // 输出图片
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,
                                        kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,
                                        NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    // 清理空间
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}
@end
