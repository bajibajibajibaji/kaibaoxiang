//
//  NSString+ZXAdd.h
//  ZXtouchView
//
//  Created by 朱志先 on 16/6/13.
//  Copyright © 2016年 朱志先. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSBundle+ZXAdd.h"
@import UIKit;
@interface NSString (ZXAdd)
- (NSString *)adaptiveImageName;
+ (NSString *)adaptiveImagePathWithFullImageName:(NSString*)fullImageName;
- (NSString *)adaptiveImagePath;
- (CGFloat)pathScale;
- (NSString *)stringByAppendingPathScale:(CGFloat)scale;
+ (NSString *)filePathWithfileName:(NSString*)fileName Type:(NSString *)type;
@end
