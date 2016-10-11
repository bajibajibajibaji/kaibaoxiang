//
//  NSBundle+ZXAdd.h
//  ZXtouchView
//
//  Created by 朱志先 on 16/6/13.
//  Copyright © 2016年 朱志先. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;
@interface NSBundle (ZXAdd)
/**
 An array of NSNumber objects, shows the best order for path scale search.
 e.g. iPhone3GS:@[@1,@2,@3] iPhone5:@[@2,@3,@1]  iPhone6 Plus:@[@3,@2,@1]
 */
+ (NSArray<NSNumber *> *)preferredScales;

@end
