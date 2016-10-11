//
//  FBOpenBoxView.m
//  kaibaoxiang
//
//  Created by cc on 16/7/7.
//  Copyright © 2016年 toyscloud. All rights reserved.
//

#import "FBOpenBoxView.h"
#import "FBMyBoxViewController.h"
#import "FBCoupon.h"
#import "constant.h"


@interface FBOpenBoxView ()

// “打开宝箱”按钮
@property (strong, nonatomic) UIButton *openBoxButton;

// 箱子
@property (strong, nonatomic) UIImageView *closeBoxImageView; // 关闭状态
@property (strong, nonatomic) UIImageView *openBoxImageView;  // 打开状态
@property (strong, nonatomic) UIImageView *boxShineImageView; // 光

// 开出的玩具
@property (strong, nonatomic) UIView *toyView;

// 玩具下面的按钮
@property (strong, nonatomic) UIButton *showToyDetailButton;
@property (strong, nonatomic) UIButton *saveToyButton;


@property (strong, nonatomic) NSArray<UIView *> *toyViews; //宝箱中的所有玩具图片
@property (strong, nonatomic) NSDictionary *toysIsGold; // 记录宝箱中每个奖励是否是金币
@property (strong, nonatomic) NSDictionary *toysGoldNum; // 记录宝箱中每个金币的数目

@property (assign, nonatomic) NSInteger currentIndex; //记录已开的宝箱
@property (assign, atomic) BOOL currToyIsGold; // 当前玩具是否是金币
@property (assign, atomic) NSInteger currToyGoldNum; // 当前玩具金币数目
@property (assign, nonatomic) NSInteger currentToyIndex; //记录宝箱中已开的奖励

@property (strong, nonatomic) UIImageView *coinImageView;
@property (strong, nonatomic) UIImageView *coinImageView2;
@property (strong, nonatomic) UIImageView *coinImageView3;
@property (strong, nonatomic) UIImageView *coinImageView4;
@property (strong, nonatomic) UIImageView *coinImageView5;

@property (assign, nonatomic) BOOL isAnimStop;

@end

@implementation FBOpenBoxView

- (instancetype)initWithFrame:(CGRect)frame
{
    WS(ws);
    if (self = [super initWithFrame:frame]) {
        self.currentIndex = 0;
        self.currentToyIndex = 0;
        
        // 背景
        UIView *paperView = imageViewOfAutoScaleImage(@"paper2.png");
        [self addSubview:paperView];
        [paperView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(ws);
            make.left.mas_equalTo(ws);
            make.bottom.mas_equalTo(ws);
            make.right.mas_equalTo(ws);
        }];
        
        // “打开宝箱”按钮
        self.openBoxButton = [[UIButton alloc] init];
        [self.openBoxButton setImage:imageOfAutoScaleImage(@"open box1.png") forState:UIControlStateNormal];
        [self.openBoxButton setImage:imageOfAutoScaleImage(@"open box2.png") forState:UIControlStateDisabled];
        [self.openBoxButton setImage:imageOfAutoScaleImage(@"open box2.png") forState:UIControlStateHighlighted];
        self.openBoxButton.enabled = NO;
        [self.openBoxButton addTarget:self action:@selector(openBoxButtonPress:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.openBoxButton];
        [self.openBoxButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(180*RATIO, 40*RATIO));
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.bottom.mas_equalTo(@(-40 * RATIO));
        }];
    }
    
    return self;
}

/*
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS
 */

- (void)setBoxType:(FBOpenBoxType)boxType
{
    WS(ws);
    
    _boxType = boxType;
    
    if (boxType == FBWoodenBox) {
        UILabel *woodenBoxLabel = [[UILabel alloc] init];
        woodenBoxLabel.text = @"我的木宝箱";
        woodenBoxLabel.font = [UIFont systemFontOfSize:16.0 * RATIO weight:UIFontWeightBold];
        woodenBoxLabel.textColor = [UIColor colorWithRed:100/255.0f green:10/255.0f blue:10/255.0f alpha:1.0f];
        woodenBoxLabel.numberOfLines = 1;
        [self addSubview:woodenBoxLabel];
        [woodenBoxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(40 * RATIO));
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.top.mas_equalTo(ws).offset(10 * RATIO);
        }];
        
        UIImageView *woodenBoxShadowImageView = imageViewOfAutoScaleImage(@"woodbox shadow.png");
        [self addSubview:woodenBoxShadowImageView];
        [woodenBoxShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(230*RATIO, 200*RATIO));
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.bottom.mas_equalTo(ws.openBoxButton.mas_top).offset(-21 * RATIO);
        }];
        
        // 关闭状态的箱子
        self.closeBoxImageView = imageViewOfAutoScaleImage(@"woodbox close.png");
        [woodenBoxShadowImageView addSubview:self.closeBoxImageView];
        [self.closeBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(woodenBoxShadowImageView);
            make.left.mas_equalTo(woodenBoxShadowImageView);
            make.bottom.mas_equalTo(woodenBoxShadowImageView);
            make.right.mas_equalTo(woodenBoxShadowImageView);
        }];
        
        // 打开状态的箱子
        self.openBoxImageView = imageViewOfAutoScaleImage(@"woodbox open.png");
        self.openBoxImageView.alpha = 0;
        [woodenBoxShadowImageView addSubview:self.openBoxImageView];
        [self.openBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(woodenBoxShadowImageView);
            make.left.mas_equalTo(woodenBoxShadowImageView);
            make.bottom.mas_equalTo(woodenBoxShadowImageView);
            make.right.mas_equalTo(woodenBoxShadowImageView);
        }];
        
        // 光
        self.boxShineImageView = imageViewOfAutoScaleImage(@"woodbox shine.png");
        self.boxShineImageView.alpha = 0;
        [self addSubview:self.boxShineImageView];
        
        if (!IS_IPHONE_4_OR_LESS) {
            [self.boxShineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(202*RATIO, 141*RATIO));
                make.top.mas_equalTo(ws).offset(95 * RATIO);
                make.left.mas_equalTo(ws).offset(26 * RATIO);
            }];
        } else {
            [self.boxShineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(202*RATIO, 141*RATIO));
                make.top.mas_equalTo(ws).offset(82.5 * RATIO);
                make.left.mas_equalTo(ws).offset(21.5 * RATIO);
            }];
        }
        
    } else if (boxType == FBArgentBox) {
        UILabel *argentBoxLabel = [[UILabel alloc] init];
        argentBoxLabel.text = @"我的银宝箱";
        argentBoxLabel.font = [UIFont systemFontOfSize:16.0 * RATIO weight:UIFontWeightBold];
        argentBoxLabel.textColor = [UIColor colorWithRed:100/255.0f green:10/255.0f blue:10/255.0f alpha:1.0f];
        argentBoxLabel.numberOfLines = 1;
        [self addSubview:argentBoxLabel];
        [argentBoxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(40 * RATIO));
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.top.mas_equalTo(ws).offset(10 * RATIO);
        }];
        
        UIImageView *argentBoxShadowImageView = imageViewOfAutoScaleImage(@"silverbox shadow.png");
        [self addSubview:argentBoxShadowImageView];
        [argentBoxShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(230*RATIO, 200*RATIO));
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.bottom.mas_equalTo(ws.openBoxButton.mas_top).offset(-21 * RATIO);
        }];
        
        // 关闭状态的箱子
        self.closeBoxImageView = imageViewOfAutoScaleImage(@"silverbox close.png");
        [argentBoxShadowImageView addSubview:self.closeBoxImageView];
        [self.closeBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(argentBoxShadowImageView);
            make.left.mas_equalTo(argentBoxShadowImageView);
            make.bottom.mas_equalTo(argentBoxShadowImageView);
            make.right.mas_equalTo(argentBoxShadowImageView);
        }];
        
        // 打开状态的箱子
        self.openBoxImageView = imageViewOfAutoScaleImage(@"silverbox open.png");
        self.openBoxImageView.alpha = 0;
        [argentBoxShadowImageView addSubview:self.openBoxImageView];
        [self.openBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(argentBoxShadowImageView);
            make.left.mas_equalTo(argentBoxShadowImageView);
            make.bottom.mas_equalTo(argentBoxShadowImageView);
            make.right.mas_equalTo(argentBoxShadowImageView);
        }];
        
        // 光
        self.boxShineImageView = imageViewOfAutoScaleImage(@"silverbox shine.png");
        self.boxShineImageView.alpha = 0;
        [self addSubview:self.boxShineImageView];
        
        if (!IS_IPHONE_4_OR_LESS) {
            [self.boxShineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(202*RATIO, 141*RATIO));
                make.top.mas_equalTo(ws).offset(95 * RATIO);
                make.left.mas_equalTo(ws).offset(26 * RATIO);
            }];
        } else {
            [self.boxShineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(202*RATIO, 141*RATIO));
                make.top.mas_equalTo(ws).offset(82.5 * RATIO);
                make.left.mas_equalTo(ws).offset(21.5 * RATIO);
            }];
        }
    } else if (boxType == FBGoldenBox) {
        UILabel *goldenBoxLabel = [[UILabel alloc] init];
        goldenBoxLabel.text = @"我的金宝箱";
        goldenBoxLabel.font = [UIFont systemFontOfSize:16.0 * RATIO weight:UIFontWeightBold];
        goldenBoxLabel.textColor = [UIColor colorWithRed:100/255.0f green:10/255.0f blue:10/255.0f alpha:1.0f];
        goldenBoxLabel.numberOfLines = 1;
        [self addSubview:goldenBoxLabel];
        [goldenBoxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(40 * RATIO));
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.top.mas_equalTo(ws).offset(10 * RATIO);
        }];
        
        UIImageView *goldenBoxShadowImageView = imageViewOfAutoScaleImage(@"goldbox shadow.png");
        [self addSubview:goldenBoxShadowImageView];
        [goldenBoxShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(230*RATIO, 200*RATIO));
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.bottom.mas_equalTo(ws.openBoxButton.mas_top).offset(-21 * RATIO);
        }];
        
        // 关闭状态的箱子
        self.closeBoxImageView = imageViewOfAutoScaleImage(@"goldbox close.png");
        [goldenBoxShadowImageView addSubview:self.closeBoxImageView];
        [self.closeBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(goldenBoxShadowImageView);
            make.left.mas_equalTo(goldenBoxShadowImageView);
            make.bottom.mas_equalTo(goldenBoxShadowImageView);
            make.right.mas_equalTo(goldenBoxShadowImageView);
        }];
        
        // 打开状态的箱子
        self.openBoxImageView = imageViewOfAutoScaleImage(@"goldbox open.png");
        self.openBoxImageView.alpha = 0;
        [goldenBoxShadowImageView addSubview:self.openBoxImageView];
        [self.openBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(goldenBoxShadowImageView);
            make.left.mas_equalTo(goldenBoxShadowImageView);
            make.bottom.mas_equalTo(goldenBoxShadowImageView);
            make.right.mas_equalTo(goldenBoxShadowImageView);
        }];
        
        // 光
        self.boxShineImageView = imageViewOfAutoScaleImage(@"goldbox shine.png");
        self.boxShineImageView.alpha = 0;
        [self addSubview:self.boxShineImageView];
        
        if (!IS_IPHONE_4_OR_LESS) {
            [self.boxShineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(202*RATIO, 141*RATIO));
                make.top.mas_equalTo(ws).offset(95 * RATIO);
                make.left.mas_equalTo(ws).offset(26 * RATIO);
            }];
        } else {
            [self.boxShineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(202*RATIO, 141*RATIO));
                make.top.mas_equalTo(ws).offset(82.5 * RATIO);
                make.left.mas_equalTo(ws).offset(21.5 * RATIO);
            }];
        }
    } else if (boxType == FBDiamondBox) {
        UILabel *diamondBoxLabel = [[UILabel alloc] init];
        diamondBoxLabel.text = @"我的钻石宝箱";
        diamondBoxLabel.font = [UIFont systemFontOfSize:16.0 * RATIO weight:UIFontWeightBold];
        diamondBoxLabel.textColor = [UIColor colorWithRed:100/255.0f green:10/255.0f blue:10/255.0f alpha:1.0f];
        diamondBoxLabel.numberOfLines = 1;
        [self addSubview:diamondBoxLabel];
        [diamondBoxLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(@(40 * RATIO));
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.top.mas_equalTo(ws).offset(10 * RATIO);
        }];
        
        UIImageView *diamondBoxShadowImageView = imageViewOfAutoScaleImage(@"Diamondbox shadow.png");
        [self addSubview:diamondBoxShadowImageView];
        [diamondBoxShadowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(230*RATIO, 200*RATIO));
            make.centerX.mas_equalTo(ws.mas_centerX);
            make.bottom.mas_equalTo(ws.openBoxButton.mas_top).offset(-21 * RATIO);
        }];
        
        // 关闭状态的箱子
        self.closeBoxImageView = imageViewOfAutoScaleImage(@"Diamondbox close.png");
        [diamondBoxShadowImageView addSubview:self.closeBoxImageView];
        [self.closeBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(diamondBoxShadowImageView);
            make.left.mas_equalTo(diamondBoxShadowImageView);
            make.bottom.mas_equalTo(diamondBoxShadowImageView);
            make.right.mas_equalTo(diamondBoxShadowImageView);
        }];
        
        // 打开状态的箱子
        self.openBoxImageView = imageViewOfAutoScaleImage(@"Diamondbox open.png");
        self.openBoxImageView.alpha = 0;
        [diamondBoxShadowImageView addSubview:self.openBoxImageView];
        [self.openBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(diamondBoxShadowImageView);
            make.left.mas_equalTo(diamondBoxShadowImageView);
            make.bottom.mas_equalTo(diamondBoxShadowImageView);
            make.right.mas_equalTo(diamondBoxShadowImageView);
        }];
        
        // 光
        self.boxShineImageView = imageViewOfAutoScaleImage(@"Diamondbox shine.png");
        self.boxShineImageView.alpha = 0;
        [self addSubview:self.boxShineImageView];
        
        if (!IS_IPHONE_4_OR_LESS) {
            [self.boxShineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(202*RATIO, 141*RATIO));
                make.top.mas_equalTo(ws).offset(95 * RATIO);
                make.left.mas_equalTo(ws).offset(26 * RATIO);
            }];
        } else {
            [self.boxShineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(202*RATIO, 141*RATIO));
                make.top.mas_equalTo(ws).offset(82.5 * RATIO);
                make.left.mas_equalTo(ws).offset(21.5 * RATIO);
            }];
        }
    }
}

- (void)setTotalBoxNum:(NSInteger)totalBoxNum
{
    _totalBoxNum = totalBoxNum;
    
    if (_totalBoxNum != 0) {
        self.openBoxButton.enabled = YES;
    }
}

- (void)setToyView:(UIView *)toyView
{
    _toyView = toyView;
    
    WS(ws);
    
    _toyView.alpha = 0;
    [self insertSubview:_toyView aboveSubview:self.boxShineImageView];
    [_toyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(215*RATIO, 160*RATIO));
        make.top.mas_equalTo(ws).offset(48 * RATIO);
        make.left.mas_equalTo(ws).offset(22 * RATIO);
    }];
    
    // 玩具下面的按钮
    self.showToyDetailButton = [[UIButton alloc] init];
    [self.showToyDetailButton setImage:imageOfAutoScaleImage(@"details.png") forState:UIControlStateNormal];
    [self.showToyDetailButton setImage:imageOfAutoScaleImage(@"details.png") forState:UIControlStateHighlighted];
    self.showToyDetailButton.alpha = 0;
    [self.showToyDetailButton addTarget:self action:@selector(showToyDetailButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:self.showToyDetailButton aboveSubview:_toyView];
    [self.showToyDetailButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(71*RATIO, 25*RATIO));
        make.left.mas_equalTo(ws).offset(45 * RATIO);
        make.top.mas_equalTo(ws).offset(180 * RATIO);
    }];
    
    self.saveToyButton = [[UIButton alloc] init];
    [self.saveToyButton setImage:imageOfAutoScaleImage(@"put in.png") forState:UIControlStateNormal];
    [self.saveToyButton setImage:imageOfAutoScaleImage(@"put in.png") forState:UIControlStateHighlighted];
    self.saveToyButton.alpha = 0;
    [self.saveToyButton addTarget:self action:@selector(saveToyButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self insertSubview:self.saveToyButton aboveSubview:self.showToyDetailButton];
    [self.saveToyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(71*RATIO, 25*RATIO));
        make.left.mas_equalTo(self.showToyDetailButton.mas_right).offset(10 * RATIO);
        make.top.mas_equalTo(ws).offset(180 * RATIO);
    }];
}

#pragma mark ----------------------button action------------------------
- (void)openBoxButtonPress:(UIButton *)button
{
    
    BOOL isGoOn;
    if ([self.delegate respondsToSelector:@selector(openButtonWillBePressedInOpenBoxView:)]) {
        isGoOn = [self.delegate openButtonWillBePressedInOpenBoxView:self];
    }
    
    if (isGoOn) {
        self.openBoxButton.enabled = NO;
        self.closeBoxImageView.alpha = 0;
        self.openBoxImageView.alpha = 1;
        
        [self addShineAnim:self.boxShineImageView];
        
        if ([self.delegate respondsToSelector:@selector(openButtonBeingPressedInOpenBoxView:)]) {
            [self.delegate openButtonBeingPressedInOpenBoxView:self];
        }
 
        self.currentIndex++;
    }
    
    if ([self.delegate respondsToSelector:@selector(openButtonBePressedInOpenBoxView:)]) {
        [self.delegate openButtonBePressedInOpenBoxView:self];
    }
}

- (void)showToyDetailButtonPressed:(UIButton *)showToyDetailButton
{
    if ([self.delegate respondsToSelector:@selector(showDetailOfToyInOpenBoxView:)]) {
        [self.delegate showDetailOfToyInOpenBoxView:self];
    }
}

- (void)saveToyButtonPressed:(UIButton *)saveToyButton
{
    [self addSaveToyAnim:self.toyView];
    
    if ([self.delegate respondsToSelector:@selector(saveToyInOpenBoxView:)]) {
        [self.delegate saveToyInOpenBoxView:self];
    }
}

#pragma mark ----------------------interface------------------------
- (void)closeBox
{
    if (self.currentIndex != self.totalBoxNum) {
        self.openBoxButton.enabled = YES;
    } else {
        self.openBoxButton.enabled = NO;
    }
    
    self.closeBoxImageView.alpha = 1;
    self.openBoxImageView.alpha = 0;
    self.boxShineImageView.alpha = 0;
    self.toyView.alpha = 0;
    self.showToyDetailButton.alpha = 0;
    self.saveToyButton.alpha = 0;
    
    self.isAnimStop = YES;
    
    [self.boxShineImageView.layer removeAllAnimations];
    [self.toyView.layer removeAllAnimations];
    [self.showToyDetailButton.layer removeAllAnimations];
    [self.saveToyButton.layer removeAllAnimations];
    [self.coinImageView.layer removeAllAnimations];
    [self.coinImageView2.layer removeAllAnimations];
    [self.coinImageView3.layer removeAllAnimations];
    [self.coinImageView4.layer removeAllAnimations];
    [self.coinImageView5.layer removeAllAnimations];
    

    
    
}

- (void)setToys:(NSArray<UIView *> *)views isGold:(NSDictionary *)isGold goldNum:(NSDictionary *)goldNum
{
    self.toyViews = views;
    self.toysIsGold = isGold;
    self.toysGoldNum = goldNum;
    
    self.currentToyIndex = 0;
    self.isAnimStop = NO;
    
    [self addToyOutAnimWithDelay:0];
}

#pragma mark ----------------------anim------------------------
- (void)addShineAnim:(UIView *)view
{
    WS(ws);
    
    [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        ws.boxShineImageView.alpha = 1;
    } completion:nil];
}


- (void)addToyOutAnimWithDelay:(NSTimeInterval)delay
{
    WS(ws);
    
    // 宝箱中当前的玩具图片
    self.toyView = self.toyViews[self.currentToyIndex];
    
    // 宝箱中国当前的玩具是否是金币
    if ([self.toysIsGold[@(self.currentToyIndex)] isEqualToString:@"TRUE"]) {
        self.currToyIsGold = YES;
    } else {
        self.currToyIsGold = NO;
    }
    
    // 宝箱中当前的金币数量
    self.currToyGoldNum = [self.toysGoldNum[@(self.currentToyIndex)] integerValue];
    
    self.currentToyIndex++;

    [self.toyView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(ws).offset((48+20) * RATIO);
    }];
    
    [self layoutIfNeeded];
    
    [UIView animateKeyframesWithDuration:1 delay:delay options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1 animations:^{
            self.toyView.alpha = 1;
            [self.toyView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(ws).offset((48) * RATIO);
            }];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            if (!ws.currToyIsGold) {
                ws.showToyDetailButton.alpha = 1;
                ws.saveToyButton.alpha = 1;
            }
        }];
        
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        if (ws.currToyIsGold && !ws.isAnimStop) {
            // 创建动画金币
            self.coinImageView = imageViewOfAutoScaleImage(@"box coin2.png");
            [ws.toyView addSubview:self.coinImageView];
            [self.coinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(ws.toyView.height).multipliedBy(0.15);
                make.left.equalTo(ws.toyView.right).multipliedBy(0.2744);
                make.bottom.equalTo(ws.toyView.bottom).multipliedBy(1 - 0.20625);
            }];
            
            self.coinImageView2 = imageViewOfAutoScaleImage(@"box coin2.png");
            [ws.toyView addSubview:self.coinImageView2];
            [self.coinImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(ws.toyView.height).multipliedBy(0.15);
                make.left.equalTo(ws.toyView.right).multipliedBy(0.2744);
                make.bottom.equalTo(ws.toyView.bottom).multipliedBy(1 - 0.20625);
            }];
            
            self.coinImageView3 = imageViewOfAutoScaleImage(@"box coin2.png");
            [ws.toyView addSubview:self.coinImageView3];
            [self.coinImageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(ws.toyView.height).multipliedBy(0.15);
                make.left.equalTo(ws.toyView.right).multipliedBy(0.2744);
                make.bottom.equalTo(ws.toyView.bottom).multipliedBy(1 - 0.20625);
            }];
            
            self.coinImageView4 = imageViewOfAutoScaleImage(@"box coin2.png");
            [ws.toyView addSubview:self.coinImageView4];
            [self.coinImageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(ws.toyView.height).multipliedBy(0.15);
                make.left.equalTo(ws.toyView.right).multipliedBy(0.2744);
                make.bottom.equalTo(ws.toyView.bottom).multipliedBy(1 - 0.20625);
            }];
            
            self.coinImageView5 = imageViewOfAutoScaleImage(@"box coin2.png");
            [ws.toyView addSubview:self.coinImageView5];
            [self.coinImageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.height.equalTo(ws.toyView.height).multipliedBy(0.15);
                make.left.equalTo(ws.toyView.right).multipliedBy(0.2744);
                make.bottom.equalTo(ws.toyView.bottom).multipliedBy(1 - 0.20625);
            }];
            
            [ws addGoldAnimDelay:0 View:self.coinImageView closeBoxOrNot:NO];
            [ws addGoldAnimDelay:0.15 View:self.coinImageView2 closeBoxOrNot:NO];
            [ws addGoldAnimDelay:0.3 View:self.coinImageView3 closeBoxOrNot:NO];
            [ws addGoldAnimDelay:0.45 View:self.coinImageView4 closeBoxOrNot:NO];
            [ws addGoldAnimDelay:0.6 View:self.coinImageView5 closeBoxOrNot:YES];
            
            [ws.mbVC goldNumChange:ws.currToyGoldNum];
        }
    }];
}

- (void)addSaveToyAnim:(UIView *)view
{
    CGPoint currPosition = [self convertPoint:[self.mbVC boatPosition] fromView:self.mbVC.view];
    CGFloat newX = currPosition.x;
    CGFloat newY = currPosition.y;
    
    CABasicAnimation *animRight = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animRight.duration = 0.2;
    animRight.beginTime = 0;
    animRight.autoreverses = NO;
    animRight.toValue = [NSNumber numberWithFloat:newX];
    
    CABasicAnimation *animDown = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animDown.duration = 0.2;
    animDown.beginTime = 0;
    animDown.autoreverses = NO;
    animDown.toValue = [NSNumber numberWithFloat:newY];
    
    CABasicAnimation *animScale = [CABasicAnimation animationWithKeyPath:@"transform"];
    animScale.duration = 0.2;
    animScale.beginTime = 0;
    animScale.autoreverses = NO;
    animScale.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    animScale.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.2, 0.2, 1)];
    
    CAAnimationGroup *toyAnimGroup = [CAAnimationGroup animation];
    toyAnimGroup = [CAAnimationGroup animation];
    toyAnimGroup.animations = @[animRight, animDown, animScale];
    toyAnimGroup.beginTime = 0;
    toyAnimGroup.duration = 0.2;
    toyAnimGroup.removedOnCompletion = NO;
    toyAnimGroup.fillMode = kCAFillModeForwards;
    toyAnimGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    toyAnimGroup.delegate = self;
    
    [view.layer addAnimation:toyAnimGroup forKey:nil];
    
    self.showToyDetailButton.alpha = 0;
    self.saveToyButton.alpha = 0;
}

- (void)addGoldAnimDelay:(NSTimeInterval)delay View:(UIView *)view closeBoxOrNot:(BOOL)closeBox
{
    CGRect currRect = [self convertRect:[self.mbVC goldNumFrame] fromView:self.mbVC.view];
    CGFloat newX = currRect.origin.x;
    CGFloat newY = currRect.origin.y;
    
    CABasicAnimation *animRight = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animRight.duration = 0.4;
    animRight.beginTime = delay;
    animRight.autoreverses = NO;
    animRight.toValue = [NSNumber numberWithFloat:newX];
    
    CABasicAnimation *animUp = [CABasicAnimation animationWithKeyPath:@"position.y"];
    animUp.duration = 0.4;
    animUp.beginTime = delay;
    animUp.autoreverses = NO;
    animUp.toValue = [NSNumber numberWithFloat:newY];
    
    CAAnimationGroup *goldAnimGroup = [CAAnimationGroup animation];
    goldAnimGroup = [CAAnimationGroup animation];
    goldAnimGroup.animations = @[animRight, animUp];
    goldAnimGroup.beginTime = 0;
    goldAnimGroup.duration = 0.4 + delay;
    goldAnimGroup.removedOnCompletion = YES;
    goldAnimGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    if (closeBox) {
        goldAnimGroup.delegate = self;
    }
    
    [view.layer addAnimation:goldAnimGroup forKey:nil];
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (self.isAnimStop == NO) {
        if (self.currentToyIndex == self.toyViews.count) {
            [self closeBox];
        } else {
            self.toyView.alpha = 0;
            [self.toyView removeFromSuperview];
        }
        
        if (!self.currToyIsGold) {
            [self.mbVC boatShake];
        }
        
        if (self.currentToyIndex != self.toyViews.count) {
            [self addToyOutAnimWithDelay:0.3];
        }
    }
}

@end
