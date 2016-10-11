//
//  NSBundle+ZXAdd.m
//  ZXtouchView
//
//  Created by 朱志先 on 16/6/13.
//  Copyright © 2016年 朱志先. All rights reserved.
//

#import "NSBundle+ZXAdd.h"
@implementation NSBundle (ZXAdd)
+ (NSArray *)preferredScales {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}



@end
