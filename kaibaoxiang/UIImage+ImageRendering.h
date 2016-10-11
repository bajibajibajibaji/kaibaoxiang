//
//  UIImage+ImageRendering.h
//  QRCodeImageRender
//
//  Created by 朱志先 on 16/7/7.
//  Copyright © 2016年 朱志先. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageRendering)
+ (NSArray *) getRGBAsFromImage:(UIImage *)image atX:(int)x andY:(int)y count:(int)count;
+ (UIImage*) imageBlackToTransparent:(UIImage*) image;

+ (UIImage *) synthesisQRCodeImageWithQRCodeImage:(UIImage *)QRCodeImage backgroundImage:(UIImage *)backgroundImage;

+ (UIImage *)remixImageWidthFrontImage:(UIImage *)frontImage backgroundImage:(UIImage *)backgroundImage;
+ (UIImage *)generateQRCodeImageWithString:(NSString *)string withLengthOfSide:(CGFloat)length;
+ (UIImage *)generateQRCodeImageWithString:(NSString *) string andBackgroundImage:(UIImage *)backgroundImage;
- (UIImage *)imageWithRoundCornerAndSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius;
- (UIImage *)systhsisWithBorderImage:(UIImage *)borderImage andCornerRadius:(CGFloat)radius;
- (UIImage *)systhsisWithBorderImage:(UIImage *)borderImage  andSize:(CGSize)sizeToFit andCornerRadius:(CGFloat)radius;
@end
