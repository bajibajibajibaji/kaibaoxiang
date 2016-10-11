//
//  FBOpenBoxView.h
//  kaibaoxiang
//
//  Created by cc on 16/7/7.
//  Copyright © 2016年 toyscloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FBOpenBoxView;
@class FBMyBoxViewController;

typedef NS_OPTIONS(NSUInteger, FBOpenBoxType) {
    FBWoodenBox = 0,
    FBArgentBox,
    FBGoldenBox,
    FBDiamondBox
};

@protocol FBOpenBoxViewDelegate <NSObject>

// “打开宝箱”按钮
- (BOOL)openButtonWillBePressedInOpenBoxView:(FBOpenBoxView *)openBoxView;
- (void)openButtonBeingPressedInOpenBoxView:(FBOpenBoxView *)openBoxView; // 网络获取宝箱奖励
- (void)openButtonBePressedInOpenBoxView:(FBOpenBoxView *)openBoxView;

// “查看详情”按钮
- (void)showDetailOfToyInOpenBoxView:(FBOpenBoxView *)openBoxView;

// “放进仓库”按钮
- (void)saveToyInOpenBoxView:(FBOpenBoxView *)openBoxView;
@end

@interface FBOpenBoxView : UIView

@property (assign, nonatomic) FBOpenBoxType boxType;

// 箱子的数量
@property (assign, nonatomic) NSInteger totalBoxNum;

@property (weak, nonatomic) id<FBOpenBoxViewDelegate> delegate;


// 传值用
@property (weak, nonatomic) FBMyBoxViewController *mbVC;


// 开出的金币数量
@property (assign, nonatomic) NSInteger toyGoldNum;


- (void)closeBox;
- (void)setToys:(NSArray<UIView *> *)views isGold:(NSDictionary *)isGold goldNum:(NSDictionary *)goldNum;
@end
