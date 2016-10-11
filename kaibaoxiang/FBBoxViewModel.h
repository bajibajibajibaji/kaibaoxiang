//
//  FBBoxViewModel.h
//  kaibaoxiang
//
//  Created by cc on 16/7/8.
//  Copyright © 2016年 toyscloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "constant.h"

@interface FBBoxViewModel : NSObject

@property (copy, nonatomic) NSString *boxType;
@property (strong, nonatomic) UIImage *toyImage;
@property (assign, nonatomic) BOOL isGold;

@end
