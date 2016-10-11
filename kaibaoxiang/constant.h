//
//  constant.h
//  fenbeiqidong
//
//  Created by cc on 16/6/28.
//  Copyright © 2016年 toyscloud. All rights reserved.
//

#ifndef constant_h
#define constant_h

#import <Masonry.h>
#import "UICountingLabel.h"

#import "NSBundle+ZXAdd.h"
#import "NSString+ZXAdd.h"


#define imageViewOfAutoScaleImage(imageName) [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:[NSString adaptiveImagePathWithFullImageName:imageName]]]
#define imageOfAutoScaleImage(imageName) [UIImage imageWithContentsOfFile:[NSString adaptiveImagePathWithFullImageName:imageName]]

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define IS_IPHONE  (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPHONE_4_OR_LESS  (IS_IPHONE && SCREEN_HEIGHT <  568.0)
#define IS_IPHONE_5          (IS_IPHONE && SCREEN_HEIGHT == 568.0)
#define IS_IPHONE_6          (IS_IPHONE && SCREEN_HEIGHT == 667.0)
#define IS_IPHONE_6P         (IS_IPHONE && SCREEN_HEIGHT == 736.0)

#define RATIO (SCREEN_WIDTH / 414.0)
#define RATIO_V (SCREEN_HEIGHT / 736.0)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//#define GOLDNUM_WORDSIZE (IS_IPHONE_6P)


#endif /* constant_h */
