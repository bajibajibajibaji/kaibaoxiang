//
//  FBMyBoxViewController.h
//  kaibaoxiang
//
//  Created by cc on 16/7/4.
//  Copyright © 2016年 toyscloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FBMyBoxViewController : UIViewController

- (CGPoint)boatPosition;
- (CGRect)goldNumFrame;
- (void)goldNumChange:(NSInteger)num;
- (void)boatShake;

@end
