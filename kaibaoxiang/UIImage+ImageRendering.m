//
//  UIImage+ImageRendering.m
//  QRCodeImageRender
//
//  Created by 朱志先 on 16/7/7.
//  Copyright © 2016年 朱志先. All rights reserved.
//

#import "UIImage+ImageRendering.h"

@implementation UIImage (ImageRendering)
+ (NSArray *)getRGBAsFromImage:(UIImage *)image atX:(int)x andY:(int)y count:(int)count
{
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
    
    CGImageRef imageRef = [image CGImage];
    NSUInteger width = CGImageGetWidth(imageRef);
    NSUInteger height = CGImageGetHeight(imageRef);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    unsigned char *rawData = (unsigned char*) calloc(height * width * 4, sizeof(unsigned char));
    NSUInteger bytesPerPixel = 4;
    NSUInteger bytesPerRow = bytesPerPixel * width;
    NSUInteger bitsPerComponent = 8;
    CGContextRef context = CGBitmapContextCreate(rawData, width, height, bitsPerComponent, bytesPerRow, colorSpace, kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big);
    CGColorSpaceRelease(colorSpace);
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), imageRef);
    CGContextRelease(context);
    
    NSUInteger byteIndex = (bytesPerRow * y) + x * bytesPerPixel;
    for (int i = 0; i < count; ++i) {
        CGFloat alpha = ((CGFloat) rawData[byteIndex + 3] / 255.0f);
        CGFloat red = ((CGFloat) rawData[byteIndex] /255.0f);
        CGFloat green = ((CGFloat)  rawData[byteIndex + 1] / 255.0f);
        CGFloat blue = ((CGFloat) rawData[byteIndex +2] / 255.0f);
        
        byteIndex += bytesPerPixel;
        
        UIColor *acolor = [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
        [result addObject:acolor];
    }
    free(rawData);
    return result;
    
}


+ (UIImage*) imageBlackToTransparent:(UIImage*) image
{
    // 分配内存
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++)
    {
        if ((*pCurPtr & 0xFFFFFF00) == 0)    // 将黑色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            
            ptr[0] = 0;
            ptr[1] = 0;
            ptr[2] = 0;
            ptr[3] = 0;
        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    return resultUIImage;
}

void ProviderReleaseData (void *info, const void *data, size_t size)
{
    free((void*)data);
}

+ (UIImage *)synthesisQRCodeImageWithQRCodeImage:(UIImage *)QRCodeImage backgroundImage:(UIImage *)backgroundImage
{
    
    // 分配内存
    const int imageWidth = QRCodeImage.size.width;
    const int imageHeight = QRCodeImage.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    uint32_t* rgbBackgroundImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), QRCodeImage.CGImage);
    
    //创建背景context
    CGColorSpaceRef backgroundColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef backgroundContext = CGBitmapContextCreate(rgbBackgroundImageBuf, imageWidth, imageHeight, 8, bytesPerRow, backgroundColorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(backgroundContext, CGRectMake(0, 0, imageWidth, imageHeight), backgroundImage.CGImage);
    
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    uint32_t* backgroundPCUrPtr = rgbBackgroundImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++, backgroundPCUrPtr++)
    {
        uint8_t* ptr = (uint8_t*)pCurPtr;
        
        if (ptr[1] <240 || ptr[2]< 240 || ptr[3] < 240)    // 将黑色变成透明
        {
            uint8_t* ptr = (uint8_t*)pCurPtr;
            uint8_t* backgroundPtr = (uint8_t*)backgroundPCUrPtr;
            
            ptr[0] = backgroundPtr[0];
            ptr[1] = backgroundPtr[1];
            ptr[2] = backgroundPtr[2];
            ptr[3] = backgroundPtr[3];
        }
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGColorSpaceRelease(backgroundColorSpace);
    CGContextRelease(backgroundContext);
    
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    return resultUIImage;
    
    
}


+ (UIImage *)remixImageWidthFrontImage:(UIImage *)frontImage backgroundImage:(UIImage *)backgroundImage
{
    
    // 分配内存
    const int imageWidth = frontImage.size.width;
    const int imageHeight = frontImage.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    uint32_t* rgbBackgroundImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    
    // 创建context
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace,kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), frontImage.CGImage);
    
    //创建背景context
    CGColorSpaceRef backgroundColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef backgroundContext = CGBitmapContextCreate(rgbBackgroundImageBuf, imageWidth, imageHeight, 8, bytesPerRow, backgroundColorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(backgroundContext, CGRectMake(0, 0, imageWidth, imageHeight), backgroundImage.CGImage);
    
    
    // 遍历像素
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    uint32_t* backgroundPCUrPtr = rgbBackgroundImageBuf;
    
    for (int i = 0; i < pixelNum; i++, pCurPtr++, backgroundPCUrPtr++)
    {
        
        uint8_t* ptr = (uint8_t*)pCurPtr;
        uint8_t* backgroundPtr = (uint8_t*)backgroundPCUrPtr;
        
        ptr[0] = (backgroundPtr[0] + ptr[0])/2;
        ptr[1] = (backgroundPtr[1] + ptr[1])/2;
        ptr[2] = (backgroundPtr[2] + ptr[2])/2;
        ptr[3] = (backgroundPtr[3] + ptr[3])/2;
    }
    
    // 将内存转成image
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight,ProviderReleaseData);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace,kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider,NULL, true, kCGRenderingIntentDefault);
    
    CGDataProviderRelease(dataProvider);
    
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    // 释放
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGColorSpaceRelease(backgroundColorSpace);
    CGContextRelease(backgroundContext);
    
    // free(rgbImageBuf) 创建dataProvider时已提供释放函数，这里不用free
    return resultUIImage;
    
    
}


+ (UIImage *)generateQRCodeImageWithString:(NSString *) string withLengthOfSide:(CGFloat)length
{
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setValue:data forKey:@"inputMessage"];
    CIImage *image = filter.outputImage;
    return [self createNonInterpolatedUIImageFormCIImage:image withSize:length];
}


+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat)size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}



+ (UIImage *)generateQRCodeImageWithString:(NSString *)string andBackgroundImage:(UIImage *)backgroundImage
{
    CGFloat LengthOfSide = backgroundImage.size.width;
    UIImage *qrCode = [self generateQRCodeImageWithString:string withLengthOfSide:LengthOfSide];
    UIImage *finalImage = [UIImage synthesisQRCodeImageWithQRCodeImage:qrCode backgroundImage:backgroundImage];
    return finalImage;
}

- (UIImage *)imageWithRoundCornerAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius
{
    CGRect rect = (CGRect) {0.f, 0.f, sizeToFit};
    UIGraphicsBeginImageContextWithOptions(sizeToFit, NO, [UIScreen mainScreen].scale);
    CGContextAddPath(UIGraphicsGetCurrentContext(), [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius].CGPath);
    CGContextClip(UIGraphicsGetCurrentContext());
    [self drawInRect:rect];
    UIImage *output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return output;
}

- (UIImage *)systhsisWithBorderImage:(UIImage *)borderImage andCornerRadius:(CGFloat)radius
{

    return [self systhsisWithBorderImage:borderImage andSize:self.size andCornerRadius:radius];
}

-(UIImage *)systhsisWithBorderImage:(UIImage *)borderImage andSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius
{
    CGSize size = CGSizeMake(sizeToFit.width, sizeToFit.height);
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    imageView.image = self;
    UIImageView *borderView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    borderView.layer.contentsCenter = CGRectMake(0.45, 0.45, 0.1, 0.1);
    borderView.image = borderImage;
    [view addSubview:imageView];
    [view addSubview:borderView];
    UIImage *image = [[self imageWithUIView:view] imageWithRoundCornerAndSize:sizeToFit andCornerRadius:radius];
    
    return image;
}


- (UIImage*)imageWithUIView:(UIView*)view
{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, NO, [UIScreen mainScreen].scale);
    CGContextRef currnetContext = UIGraphicsGetCurrentContext();
    [view.layer renderInContext:currnetContext];
    // 从当前context中创建一个改变大小后的图片
    UIImage* image = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    return image;
}
@end
