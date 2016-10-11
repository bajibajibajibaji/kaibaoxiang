//
//  FBMyBoxViewController.m
//  kaibaoxiang
//
//  Created by cc on 16/7/4.
//  Copyright © 2016年 toyscloud. All rights reserved.
//

#import "FBMyBoxViewController.h"
#import "constant.h"
#import "FBOpenBoxView.h"
#import "FBBoxViewModel.h"
#import "FBCoupon.h"

typedef NS_OPTIONS(NSUInteger, FBKeyType) {
    FBWoodenKey = 0,
    FBArgentKey,
    FBGoldenKey,
    FBDiamondKey
};

@interface FBMyBoxViewController () <FBOpenBoxViewDelegate>

/** 上面金币数量 */
@property (assign, nonatomic) NSInteger goldNum;
@property (strong, nonatomic) UIImageView *goldNumImageView;
@property (strong, nonatomic) UICountingLabel *goldNumLabel;

/** 左侧钻石宝箱按钮 */
@property (strong, nonatomic) UIButton *diamondButton;

/** 左侧4个小星星 */
@property (assign, nonatomic) NSInteger diamondStarNum;
@property (assign, nonatomic) NSInteger goldenStarNum;
@property (assign, nonatomic) NSInteger argentStarNum;
@property (assign, nonatomic) NSInteger woodenStarNum;

@property (strong, nonatomic) UILabel *diamondStarLabel;
@property (strong, nonatomic) UILabel *goldenStarLabel;
@property (strong, nonatomic) UILabel *argentStarLabel;
@property (strong, nonatomic) UILabel *woodenStarLabel;

/** 下面钥匙价格的金币数量 */
@property (assign, nonatomic) NSInteger keyForWoodenBoxGoldNum;
@property (assign, nonatomic) NSInteger keyForArgentBoxGoldNum;
@property (assign, nonatomic) NSInteger keyForGoldenBoxGoldNum;
@property (assign, nonatomic) NSInteger keyForDiamondBoxGoldNum;

@property (strong, nonatomic) UILabel *keyForWoodenBoxGoldNumLabel;
@property (strong, nonatomic) UILabel *keyForArgentBoxGoldNumLabel;
@property (strong, nonatomic) UILabel *keyForGoldenBoxGoldNumLabel;
@property (strong, nonatomic) UILabel *keyForDiamondBoxGoldNumLabel;

// 右下角的船
@property (strong, nonatomic) UIImageView *boatImageView;

/** 4个钥匙的小星星 */
@property (strong, nonatomic) UIImageView *woodenKeyStarImageView;
@property (strong, nonatomic) UIImageView *argentKeyStarImageView;
@property (strong, nonatomic) UIImageView *goldenKeyStarImageView;
@property (strong, nonatomic) UIImageView *diamondKeyStarImageView;

@property (assign, nonatomic) NSInteger woodenKeyStarNum;
@property (assign, nonatomic) NSInteger argentKeyStarNum;
@property (assign, nonatomic) NSInteger goldenKeyStarNum;
@property (assign, nonatomic) NSInteger diamondKeyStarNum;

@property (strong, nonatomic) UILabel *woodenKeyStarLabel;
@property (strong, nonatomic) UILabel *argentKeyStarLabel;
@property (strong, nonatomic) UILabel *goldenKeyStarLabel;
@property (strong, nonatomic) UILabel *diamondKeyStarLabel;

/** 中间的开宝箱页面 */
@property (strong, nonatomic) FBOpenBoxView *myDiamondBoxView;
@property (strong, nonatomic) FBOpenBoxView *myGoldenBoxView;
@property (strong, nonatomic) FBOpenBoxView *myArgentBoxView;
@property (strong, nonatomic) FBOpenBoxView *myWoodenBoxView;

/** 模糊背景 */
@property (strong, nonatomic) UIVisualEffectView *visualView;

// 当前boxView
@property (strong, nonatomic) FBOpenBoxView *currentBoxView;

// 当前用的钥匙类型
@property (assign, nonatomic) FBKeyType currentKeyType;

// 每次开宝箱，记录每个宝箱中的金币和
@property (assign, nonatomic) NSInteger goldSum;

@end

@implementation FBMyBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  ////////////////////
    [self preInit];
    [self boxInit];
    [self keyInit];
    [self openBoxInit];
    
    // TODO:获取初始数据
    /****************************** test by cc **********************************/
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 上面金币数量
        self.goldNum = 0;
        
        // 4个宝箱数量
        self.diamondStarNum = 1;
        self.goldenStarNum  = 4;
        self.argentStarNum  = 5;
        self.woodenStarNum  = 6;
        
        // 4种钥匙的数量
        self.woodenKeyStarNum  = 1;
        self.argentKeyStarNum  = 1;
        self.goldenKeyStarNum  = 1;
        self.diamondKeyStarNum = 0;
        
        // 4种钥匙的价格
        self.keyForWoodenBoxGoldNum  = 10;
        self.keyForArgentBoxGoldNum  = 20;
        self.keyForGoldenBoxGoldNum  = 30;
        self.keyForDiamondBoxGoldNum = 40;
        
        
        self.myDiamondBoxView.totalBoxNum = self.diamondStarNum;
        self.myGoldenBoxView.totalBoxNum  = self.goldenStarNum;
        self.myArgentBoxView.totalBoxNum  = self.argentStarNum;
        self.myWoodenBoxView.totalBoxNum  = self.woodenStarNum;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 上面金币数量
            [self.goldNumLabel countFromZeroTo:self.goldNum withDuration:0.5];
            
            // 4个宝箱数量
            self.diamondStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.diamondStarNum];
            self.goldenStarLabel.text  = [NSString stringWithFormat:@"%ld", (long)self.goldenStarNum];
            self.argentStarLabel.text  = [NSString stringWithFormat:@"%ld", (long)self.argentStarNum];
            self.woodenStarLabel.text  = [NSString stringWithFormat:@"%ld", (long)self.woodenStarNum];
            
            // 4种钥匙的数量
            self.woodenKeyStarLabel.text  = [NSString stringWithFormat:@"%ld", (long)self.woodenKeyStarNum];
            self.argentKeyStarLabel.text  = [NSString stringWithFormat:@"%ld", (long)self.argentKeyStarNum];
            self.goldenKeyStarLabel.text  = [NSString stringWithFormat:@"%ld", (long)self.goldenKeyStarNum];
            self.diamondKeyStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.diamondKeyStarNum];
            
            // 4种钥匙的价格
            self.keyForWoodenBoxGoldNumLabel.text  = [NSString stringWithFormat:@"%ld", (long)self.keyForWoodenBoxGoldNum];
            self.keyForArgentBoxGoldNumLabel.text  = [NSString stringWithFormat:@"%ld", (long)self.keyForArgentBoxGoldNum];
            self.keyForGoldenBoxGoldNumLabel.text  = [NSString stringWithFormat:@"%ld", (long)self.keyForGoldenBoxGoldNum];
            self.keyForDiamondBoxGoldNumLabel.text = [NSString stringWithFormat:@"%ld", (long)self.keyForDiamondBoxGoldNum];
        });
    });
    /****************************** test end**********************************/
    
}

- (void)preInit
{
    WS(ws);
    
    // 背景色
    self.view.backgroundColor = [UIColor colorWithRed:35.0f/255.0f green:205.0f/255.0f blue:250.0f/255.0f alpha:1.0f];
    
    // 背景波浪
    UIImageView *boxWaveImageView = imageViewOfAutoScaleImage(@"box wave.png");
    boxWaveImageView.frame = CGRectMake(0, SCREEN_HEIGHT - 186*RATIO, SCREEN_WIDTH, 186*RATIO);
    [self.view addSubview:boxWaveImageView];
    
    // 返回按钮
    UIButton *backButton = [[UIButton alloc] init];
    [self.view addSubview:backButton];
    [backButton setImage:imageOfAutoScaleImage(@"box back.png") forState:UIControlStateNormal];
    backButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40 - 6);
    [backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 13));
        make.top.mas_equalTo(ws.view).offset(35.5);
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
    }];
    [backButton addTarget:self action:@selector(backButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    // 标题
    UILabel *boxTitleLabel = [[UILabel alloc] init];
    [self.view addSubview:boxTitleLabel];
    boxTitleLabel.text = @"我的宝箱";
    boxTitleLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightBold];
    boxTitleLabel.textColor = [UIColor colorWithRed:0.0f/255.0f green:80.0f/255.0f blue:100.0f/255.0f alpha:1.0f]; // #005064
    boxTitleLabel.textAlignment = NSTextAlignmentCenter;
    boxTitleLabel.numberOfLines = 1;
    [boxTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@300);
        make.centerY.mas_equalTo(backButton.mas_centerY);
        make.centerX.mas_equalTo(ws.view.mas_centerX);
    }];
    
    // 金币数量
    self.goldNumImageView = imageViewOfAutoScaleImage(@"integral3.png");
    [self.view addSubview:self.goldNumImageView];
    self.goldNumImageView.layer.contentsCenter = CGRectMake(0.45, 0.2, 0.1, 0); // 9切片
    [self.goldNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(@30.0f);
        make.top.mas_equalTo(ws.view).offset(64 * RATIO);
        make.right.mas_equalTo(ws.view).offset(-39 * RATIO);
    }];
    
    self.goldNumLabel = [[UICountingLabel alloc] init];
    [self.goldNumImageView addSubview:self.goldNumLabel];
    self.goldNumLabel.format = @"%ld";
    self.goldNumLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightRegular];
    self.goldNumLabel.numberOfLines = 1;
    self.goldNumLabel.text = @"0";
    [self.goldNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goldNumImageView.mas_top);
        make.left.mas_equalTo(self.goldNumImageView.mas_left).offset(30);
        make.bottom.mas_equalTo(self.goldNumImageView.mas_bottom);
        make.right.mas_equalTo(self.goldNumImageView.mas_right).offset(-20);
    }];
 
    
    // 船
    self.boatImageView = imageViewOfAutoScaleImage(@"cabin.png");
    [self.view addSubview:self.boatImageView];
    [self.boatImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(116 * RATIO, 116 * RATIO));
        make.right.mas_equalTo(ws.view).offset(-15 * RATIO);
        make.bottom.mas_equalTo(ws.view).offset(-15 * RATIO);
    }];
}

// 4个宝箱初始化
- (void)boxInit
{
    WS(ws);
    
    // 钻石宝箱
    self.diamondButton = [[UIButton alloc] init];
    [self.view addSubview:self.diamondButton];
    [self.diamondButton setImage:imageOfAutoScaleImage(@"box.png") forState:UIControlStateNormal];
    [self.diamondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(ws.view).offset(100/3*RATIO + 64);
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
    }];
    [self.diamondButton addTarget:self action:@selector(diamondButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *diamondLabel = [[UILabel alloc] init];
    [self.view addSubview:diamondLabel];
    diamondLabel.text = @"钻石宝箱";
    diamondLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    diamondLabel.textColor = [UIColor whiteColor];
    diamondLabel.textAlignment = NSTextAlignmentCenter;
    [diamondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 13.33));
        make.top.mas_equalTo(self.diamondButton.mas_bottom).offset(0);
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
    }];
    
    // 钻石宝箱小星星
    UIImageView *diamondStarImageView = imageViewOfAutoScaleImage(@"star.png");
    [self.diamondButton addSubview:diamondStarImageView];
    [diamondStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.top.mas_equalTo(self.diamondButton.mas_top);
        make.right.mas_equalTo(self.diamondButton.mas_right);
    }];
    
    self.diamondStarLabel = [[UILabel alloc] init];
    self.diamondStarLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    self.diamondStarLabel.textColor = [UIColor redColor];
    self.diamondStarLabel.textAlignment = NSTextAlignmentCenter;
    [diamondStarImageView addSubview:self.diamondStarLabel];
    [self.diamondStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(diamondStarImageView.mas_top);
        make.left.mas_equalTo(diamondStarImageView.mas_left);
        make.bottom.mas_equalTo(diamondStarImageView.mas_bottom);
        make.right.mas_equalTo(diamondStarImageView.mas_right);
    }];
    
    
    // 金宝箱
    UIButton *goldenButton = [[UIButton alloc] init];
    [self.view addSubview:goldenButton];
    [goldenButton setImage:imageOfAutoScaleImage(@"box2.png") forState:UIControlStateNormal];
    [goldenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(diamondLabel.mas_bottom).offset(15 * RATIO);
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
    }];
    [goldenButton addTarget:self action:@selector(goldenButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *goldenLabel = [[UILabel alloc] init];
    [self.view addSubview:goldenLabel];
    goldenLabel.text = @"金宝箱";
    goldenLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    goldenLabel.textColor = [UIColor whiteColor];
    goldenLabel.textAlignment = NSTextAlignmentCenter;
    [goldenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 13.33));
        make.top.mas_equalTo(goldenButton.mas_bottom).offset(0);
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
    }];
    
    // 金宝箱小星星
    UIImageView *goldenStarImageView = imageViewOfAutoScaleImage(@"star.png");
    [goldenButton addSubview:goldenStarImageView];
    [goldenStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.top.mas_equalTo(goldenButton.mas_top);
        make.right.mas_equalTo(goldenButton.mas_right);
    }];
    
    self.goldenStarLabel = [[UILabel alloc] init];
    self.goldenStarLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    self.goldenStarLabel.textColor = [UIColor redColor];
    self.goldenStarLabel.textAlignment = NSTextAlignmentCenter;
    [goldenStarImageView addSubview:self.goldenStarLabel];
    [self.goldenStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(goldenStarImageView.mas_top);
        make.left.mas_equalTo(goldenStarImageView.mas_left);
        make.bottom.mas_equalTo(goldenStarImageView.mas_bottom);
        make.right.mas_equalTo(goldenStarImageView.mas_right);
    }];
    
    // 银宝箱
    UIButton *argentButton = [[UIButton alloc] init];
    [self.view addSubview:argentButton];
    [argentButton setImage:imageOfAutoScaleImage(@"box3.png") forState:UIControlStateNormal];
    [argentButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(goldenLabel.mas_bottom).offset(15 * RATIO);
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
    }];
    [argentButton addTarget:self action:@selector(argentButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *argentLabel = [[UILabel alloc] init];
    [self.view addSubview:argentLabel];
    argentLabel.text = @"银宝箱";
    argentLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    argentLabel.textColor = [UIColor whiteColor];
    argentLabel.textAlignment = NSTextAlignmentCenter;
    [argentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 13.33));
        make.top.mas_equalTo(argentButton.mas_bottom).offset(0);
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
    }];
    
    // 银宝箱小星星
    UIImageView *argentStarImageView = imageViewOfAutoScaleImage(@"star.png");
    [argentButton addSubview:argentStarImageView];
    [argentStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.top.mas_equalTo(argentButton.mas_top);
        make.right.mas_equalTo(argentButton.mas_right);
    }];
    
    self.argentStarLabel = [[UILabel alloc] init];
    self.argentStarLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    self.argentStarLabel.textColor = [UIColor redColor];
    self.argentStarLabel.textAlignment = NSTextAlignmentCenter;
    [argentStarImageView addSubview:self.argentStarLabel];
    [self.argentStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(argentStarImageView.mas_top);
        make.left.mas_equalTo(argentStarImageView.mas_left);
        make.bottom.mas_equalTo(argentStarImageView.mas_bottom);
        make.right.mas_equalTo(argentStarImageView.mas_right);
    }];
    
    // 木宝箱
    UIButton *woodenButton = [[UIButton alloc] init];
    [self.view addSubview:woodenButton];
    [woodenButton setImage:imageOfAutoScaleImage(@"box4.png") forState:UIControlStateNormal];
    [woodenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.mas_equalTo(argentLabel.mas_bottom).offset(15 * RATIO);
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
    }];
    [woodenButton addTarget:self action:@selector(woodenButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *woodenLabel = [[UILabel alloc] init];
    [self.view addSubview:woodenLabel];
    woodenLabel.text = @"木宝箱";
    woodenLabel.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    woodenLabel.textColor = [UIColor whiteColor];
    woodenLabel.textAlignment = NSTextAlignmentCenter;
    [woodenLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 13.33));
        make.top.mas_equalTo(woodenButton.mas_bottom).offset(0);
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
    }];
    
    // 木宝箱小星星
    UIImageView *woodenStarImageView = imageViewOfAutoScaleImage(@"star.png");
    [woodenButton addSubview:woodenStarImageView];
    [woodenStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17, 17));
        make.top.mas_equalTo(woodenButton.mas_top);
        make.right.mas_equalTo(woodenButton.mas_right);
    }];
    
    self.woodenStarLabel = [[UILabel alloc] init];
    self.woodenStarLabel.font = [UIFont systemFontOfSize:9 weight:UIFontWeightRegular];
    self.woodenStarLabel.textColor = [UIColor redColor];
    self.woodenStarLabel.textAlignment = NSTextAlignmentCenter;
    [woodenStarImageView addSubview:self.woodenStarLabel];
    [self.woodenStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(woodenStarImageView.mas_top);
        make.left.mas_equalTo(woodenStarImageView.mas_left);
        make.bottom.mas_equalTo(woodenStarImageView.mas_bottom);
        make.right.mas_equalTo(woodenStarImageView.mas_right);
    }];
}

// 4个钥匙初始化
- (void)keyInit
{
    WS(ws);
    
    // key1
    UIImageView *keyForWoodenBoxNumImageView = imageViewOfAutoScaleImage(@"integral2.png");
    [self.view addSubview:keyForWoodenBoxNumImageView];
    [keyForWoodenBoxNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*RATIO, 17*RATIO));
        make.left.mas_equalTo(ws.view).offset(17 * RATIO);
        make.bottom.mas_equalTo(ws.view).offset(-35 * RATIO);
    }];
    
    keyForWoodenBoxNumImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *keyForWoodenBoxNumTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWoodenKey)];
    keyForWoodenBoxNumTap.numberOfTapsRequired = 1;
    keyForWoodenBoxNumTap.numberOfTouchesRequired = 1;
    [keyForWoodenBoxNumImageView addGestureRecognizer:keyForWoodenBoxNumTap];
    
    self.keyForWoodenBoxGoldNumLabel = [[UILabel alloc] init];
    [keyForWoodenBoxNumImageView addSubview:self.keyForWoodenBoxGoldNumLabel];
    self.keyForWoodenBoxGoldNumLabel.font = [UIFont systemFontOfSize:11*RATIO weight:UIFontWeightRegular];
    self.keyForWoodenBoxGoldNumLabel.numberOfLines = 1;
    self.keyForWoodenBoxGoldNumLabel.text = @"000";
    self.keyForWoodenBoxGoldNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.keyForWoodenBoxGoldNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(keyForWoodenBoxNumImageView.mas_top);
        make.bottom.mas_equalTo(keyForWoodenBoxNumImageView.mas_bottom).offset(-2 * RATIO);
        make.left.mas_equalTo(keyForWoodenBoxNumImageView.mas_left).offset(17 * RATIO);
        make.right.mas_equalTo(keyForWoodenBoxNumImageView.mas_right).offset(-10 * RATIO);
    }];
    
    UIImageView *keyForWoodenBoxImageView = imageViewOfAutoScaleImage(@"Chest key4.png");
    [self.view addSubview:keyForWoodenBoxImageView];
    [keyForWoodenBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54*RATIO, 65*RATIO));
        make.left.mas_equalTo(ws.view).offset(15 * RATIO);
        make.bottom.mas_equalTo(keyForWoodenBoxNumImageView.mas_top).offset(-3 * RATIO);
    }];
    
    keyForWoodenBoxImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *keyForWoodenBoxTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapWoodenKey)];
    keyForWoodenBoxTap.numberOfTapsRequired = 1;
    keyForWoodenBoxTap.numberOfTouchesRequired = 1;
    [keyForWoodenBoxImageView addGestureRecognizer:keyForWoodenBoxTap];
    
    // 木钥匙小星星
    self.woodenKeyStarImageView = imageViewOfAutoScaleImage(@"star.png");
    [keyForWoodenBoxImageView addSubview:self.woodenKeyStarImageView];
    [self.woodenKeyStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17*RATIO, 17*RATIO));
        make.bottom.mas_equalTo(keyForWoodenBoxImageView.mas_bottom).offset(-5 * RATIO);
        make.right.mas_equalTo(keyForWoodenBoxImageView.mas_right);
    }];
    
    self.woodenKeyStarLabel = [[UILabel alloc] init];
    self.woodenKeyStarLabel.font = [UIFont systemFontOfSize:11*RATIO weight:UIFontWeightRegular];
    self.woodenKeyStarLabel.text = @"10";
    self.woodenKeyStarLabel.textColor = [UIColor redColor];
    self.woodenKeyStarLabel.textAlignment = NSTextAlignmentCenter;
    [self.woodenKeyStarImageView addSubview:self.woodenKeyStarLabel];
    [self.woodenKeyStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.woodenKeyStarImageView.mas_top);
        make.left.mas_equalTo(self.woodenKeyStarImageView.mas_left);
        make.bottom.mas_equalTo(self.woodenKeyStarImageView.mas_bottom);
        make.right.mas_equalTo(self.woodenKeyStarImageView.mas_right);
    }];
    
    
    // key2
    UIImageView *keyForArgentBoxNumImageView = imageViewOfAutoScaleImage(@"integral2.png");
    [self.view addSubview:keyForArgentBoxNumImageView];
    [keyForArgentBoxNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*RATIO, 17*RATIO));
        make.left.mas_equalTo(keyForWoodenBoxNumImageView.mas_right).offset(17 * RATIO);
        make.bottom.mas_equalTo(ws.view).offset(-35 * RATIO);
    }];
    
    keyForArgentBoxNumImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *keyForArgentBoxNumTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArgentKey)];
    keyForArgentBoxNumTap.numberOfTapsRequired = 1;
    keyForArgentBoxNumTap.numberOfTouchesRequired = 1;
    [keyForArgentBoxNumImageView addGestureRecognizer:keyForArgentBoxNumTap];
    
    self.keyForArgentBoxGoldNumLabel = [[UILabel alloc] init];
    [keyForArgentBoxNumImageView addSubview:self.keyForArgentBoxGoldNumLabel];
    self.keyForArgentBoxGoldNumLabel.font = [UIFont systemFontOfSize:11*RATIO weight:UIFontWeightRegular];
    self.keyForArgentBoxGoldNumLabel.numberOfLines = 1;
    self.keyForArgentBoxGoldNumLabel.text = @"000";
    self.keyForArgentBoxGoldNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.keyForArgentBoxGoldNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(keyForArgentBoxNumImageView.mas_top);
        make.bottom.mas_equalTo(keyForArgentBoxNumImageView.mas_bottom).offset(-2 * RATIO);
        make.left.mas_equalTo(keyForArgentBoxNumImageView.mas_left).offset(17 * RATIO);
        make.right.mas_equalTo(keyForArgentBoxNumImageView.mas_right).offset(-10 * RATIO);
    }];
    
    UIImageView *keyForArgentBoxImageView = imageViewOfAutoScaleImage(@"Chest key3.png");
    [self.view addSubview:keyForArgentBoxImageView];
    [keyForArgentBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54*RATIO, 65*RATIO));
        make.left.mas_equalTo(keyForWoodenBoxImageView.mas_right).offset(13 * RATIO);
        make.bottom.mas_equalTo(keyForArgentBoxNumImageView.mas_top).offset(-3 * RATIO);
    }];
    
    keyForArgentBoxImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *keyForArgentBoxTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapArgentKey)];
    keyForArgentBoxTap.numberOfTapsRequired = 1;
    keyForArgentBoxTap.numberOfTouchesRequired = 1;
    [keyForArgentBoxImageView addGestureRecognizer:keyForArgentBoxTap];
    
    // 银钥匙小星星
    self.argentKeyStarImageView = imageViewOfAutoScaleImage(@"star.png");
    [keyForArgentBoxImageView addSubview:self.argentKeyStarImageView];
    [self.argentKeyStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17*RATIO, 17*RATIO));
        make.bottom.mas_equalTo(keyForArgentBoxImageView.mas_bottom).offset(-5 * RATIO);
        make.right.mas_equalTo(keyForArgentBoxImageView.mas_right);
    }];
    
    self.argentKeyStarLabel = [[UILabel alloc] init];
    self.argentKeyStarLabel.font = [UIFont systemFontOfSize:11*RATIO weight:UIFontWeightRegular];
    self.argentKeyStarLabel.text = @"10";
    self.argentKeyStarLabel.textColor = [UIColor redColor];
    self.argentKeyStarLabel.textAlignment = NSTextAlignmentCenter;
    [self.argentKeyStarImageView addSubview:self.argentKeyStarLabel];
    [self.argentKeyStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.argentKeyStarImageView.mas_top);
        make.left.mas_equalTo(self.argentKeyStarImageView.mas_left);
        make.bottom.mas_equalTo(self.argentKeyStarImageView.mas_bottom);
        make.right.mas_equalTo(self.argentKeyStarImageView.mas_right);
    }];
    
    
    // key3
    UIImageView *keyForGoldenBoxNumImageView = imageViewOfAutoScaleImage(@"integral2.png");
    [self.view addSubview:keyForGoldenBoxNumImageView];
    [keyForGoldenBoxNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*RATIO, 17*RATIO));
        make.left.mas_equalTo(keyForArgentBoxNumImageView.mas_right).offset(17 * RATIO);
        make.bottom.mas_equalTo(ws.view).offset(-35 * RATIO);
    }];
    
    keyForGoldenBoxNumImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *keyForGoldenBoxNumTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGoldenKey)];
    keyForGoldenBoxNumTap.numberOfTapsRequired = 1;
    keyForGoldenBoxNumTap.numberOfTouchesRequired = 1;
    [keyForGoldenBoxNumImageView addGestureRecognizer:keyForGoldenBoxNumTap];
    
    self.keyForGoldenBoxGoldNumLabel = [[UILabel alloc] init];
    [keyForGoldenBoxNumImageView addSubview:self.keyForGoldenBoxGoldNumLabel];
    self.keyForGoldenBoxGoldNumLabel.font = [UIFont systemFontOfSize:11*RATIO weight:UIFontWeightRegular];
    self.keyForGoldenBoxGoldNumLabel.numberOfLines = 1;
    self.keyForGoldenBoxGoldNumLabel.text = @"000";
    self.keyForGoldenBoxGoldNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.keyForGoldenBoxGoldNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(keyForGoldenBoxNumImageView.mas_top);
        make.bottom.mas_equalTo(keyForGoldenBoxNumImageView.mas_bottom).offset(-2 * RATIO);
        make.left.mas_equalTo(keyForGoldenBoxNumImageView.mas_left).offset(17 * RATIO);
        make.right.mas_equalTo(keyForGoldenBoxNumImageView.mas_right).offset(-10 * RATIO);
    }];
    
    UIImageView *keyForGoldenBoxImageView  = imageViewOfAutoScaleImage(@"Chest key2.png");
    [self.view addSubview:keyForGoldenBoxImageView];
    [keyForGoldenBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54*RATIO, 65*RATIO));
        make.left.mas_equalTo(keyForArgentBoxImageView.mas_right).offset(13 * RATIO);
        make.bottom.mas_equalTo(keyForGoldenBoxNumImageView.mas_top).offset(-3 * RATIO);
    }];
    
    keyForGoldenBoxImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *keyForGoldenBoxTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGoldenKey)];
    keyForGoldenBoxTap.numberOfTapsRequired = 1;
    keyForGoldenBoxTap.numberOfTouchesRequired = 1;
    [keyForGoldenBoxImageView addGestureRecognizer:keyForGoldenBoxTap];
    
    // 金钥匙小星星
    self.goldenKeyStarImageView = imageViewOfAutoScaleImage(@"star.png");
    [keyForGoldenBoxImageView addSubview:self.goldenKeyStarImageView];
    [self.goldenKeyStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17*RATIO, 17*RATIO));
        make.bottom.mas_equalTo(keyForGoldenBoxImageView.mas_bottom).offset(-5 * RATIO);
        make.right.mas_equalTo(keyForGoldenBoxImageView.mas_right);
    }];
    
    self.goldenKeyStarLabel = [[UILabel alloc] init];
    self.goldenKeyStarLabel.font = [UIFont systemFontOfSize:11*RATIO weight:UIFontWeightRegular];
    self.goldenKeyStarLabel.text = @"10";
    self.goldenKeyStarLabel.textColor = [UIColor redColor];
    self.goldenKeyStarLabel.textAlignment = NSTextAlignmentCenter;
    [self.goldenKeyStarImageView addSubview:self.goldenKeyStarLabel];
    [self.goldenKeyStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.goldenKeyStarImageView.mas_top);
        make.left.mas_equalTo(self.goldenKeyStarImageView.mas_left);
        make.bottom.mas_equalTo(self.goldenKeyStarImageView.mas_bottom);
        make.right.mas_equalTo(self.goldenKeyStarImageView.mas_right);
    }];
    
    
    // key4
    UIImageView *keyForDiamondBoxNumImageView = imageViewOfAutoScaleImage(@"integral2.png");
    [self.view addSubview:keyForDiamondBoxNumImageView];
    [keyForDiamondBoxNumImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(50*RATIO, 17*RATIO));
        make.left.mas_equalTo(keyForGoldenBoxNumImageView.mas_right).offset(17 * RATIO);
        make.bottom.mas_equalTo(ws.view).offset(-35 * RATIO);
    }];
    
    keyForDiamondBoxNumImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *keyForDiamondBoxNumTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDiamondKey)];
    keyForDiamondBoxNumTap.numberOfTapsRequired = 1;
    keyForDiamondBoxNumTap.numberOfTouchesRequired = 1;
    [keyForDiamondBoxNumImageView addGestureRecognizer:keyForDiamondBoxNumTap];
    
    self.keyForDiamondBoxGoldNumLabel = [[UILabel alloc] init];
    [keyForDiamondBoxNumImageView addSubview:self.keyForDiamondBoxGoldNumLabel];
    self.keyForDiamondBoxGoldNumLabel.font = [UIFont systemFontOfSize:11*RATIO weight:UIFontWeightRegular];
    self.keyForDiamondBoxGoldNumLabel.numberOfLines = 1;
    self.keyForDiamondBoxGoldNumLabel.text = @"000";
    self.keyForDiamondBoxGoldNumLabel.textAlignment = NSTextAlignmentCenter;
    [self.keyForDiamondBoxGoldNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(keyForDiamondBoxNumImageView.mas_top);
        make.bottom.mas_equalTo(keyForDiamondBoxNumImageView.mas_bottom).offset(-2 * RATIO);
        make.left.mas_equalTo(keyForDiamondBoxNumImageView.mas_left).offset(17 * RATIO);
        make.right.mas_equalTo(keyForDiamondBoxNumImageView.mas_right).offset(-10 * RATIO);
    }];
    
    UIImageView *keyForDiamondBoxImageView = imageViewOfAutoScaleImage(@"Chest key1.png");
    [self.view addSubview:keyForDiamondBoxImageView];
    [keyForDiamondBoxImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(54*RATIO, 65*RATIO));
        make.left.mas_equalTo(keyForGoldenBoxImageView.mas_right).offset(13 * RATIO);
        make.bottom.mas_equalTo(keyForDiamondBoxNumImageView.mas_top).offset(-3 * RATIO);
    }];
    
    keyForDiamondBoxImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *keyForDiamondBoxTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDiamondKey)];
    keyForDiamondBoxTap.numberOfTapsRequired = 1;
    keyForDiamondBoxTap.numberOfTouchesRequired = 1;
    [keyForDiamondBoxImageView addGestureRecognizer:keyForDiamondBoxTap];
    
    // 钻石钥匙小星星
    self.diamondKeyStarImageView = imageViewOfAutoScaleImage(@"star.png");
    [keyForDiamondBoxImageView addSubview:self.diamondKeyStarImageView];
    [self.diamondKeyStarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(17*RATIO, 17*RATIO));
        make.bottom.mas_equalTo(keyForDiamondBoxImageView.mas_bottom).offset(-5 * RATIO);
        make.right.mas_equalTo(keyForDiamondBoxImageView.mas_right);
    }];
    
    self.diamondKeyStarLabel = [[UILabel alloc] init];
    self.diamondKeyStarLabel.font = [UIFont systemFontOfSize:11*RATIO weight:UIFontWeightRegular];
    self.diamondKeyStarLabel.text = @"10";
    self.diamondKeyStarLabel.textColor = [UIColor redColor];
    self.diamondKeyStarLabel.textAlignment = NSTextAlignmentCenter;
    [self.diamondKeyStarImageView addSubview:self.diamondKeyStarLabel];
    [self.diamondKeyStarLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.diamondKeyStarImageView.mas_top);
        make.left.mas_equalTo(self.diamondKeyStarImageView.mas_left);
        make.bottom.mas_equalTo(self.diamondKeyStarImageView.mas_bottom);
        make.right.mas_equalTo(self.diamondKeyStarImageView.mas_right);
    }];
}

- (void)openBoxInit
{
    [self myWoodenBoxView];
    [self myArgentBoxView];
    [self myGoldenBoxView];
    [self myDiamondBoxView];
    
    self.currentBoxView = self.myDiamondBoxView;
}

#pragma mark ----------------------lazy------------------------
- (FBOpenBoxView *)myDiamondBoxView
{
    WS(ws);
    
    if (_myDiamondBoxView == nil) {
        _myDiamondBoxView = [[FBOpenBoxView alloc] init];
        _myDiamondBoxView.delegate = self;
        _myDiamondBoxView.mbVC = self;
        _myDiamondBoxView.boxType = FBDiamondBox;
        
        [self.view addSubview:_myDiamondBoxView];
        if (!IS_IPHONE_4_OR_LESS) {
            [_myDiamondBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(290*RATIO, 405*RATIO));
                make.left.mas_equalTo(ws.diamondButton.mas_right).offset(30 * RATIO);
                make.top.mas_equalTo(ws.goldNumImageView.mas_bottom).offset(17 * RATIO);
            }];
        } else {
            [_myDiamondBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(290*0.97*RATIO, 405*0.97*RATIO));
                make.left.mas_equalTo(ws.diamondButton.mas_right).offset(15 * RATIO);
                make.top.mas_equalTo(ws.goldNumImageView.mas_bottom).offset(1 * RATIO);
            }];
        }
    }
    
    return _myDiamondBoxView;
}

- (FBOpenBoxView *)myGoldenBoxView
{
    WS(ws);
    
    if (_myGoldenBoxView == nil) {
        _myGoldenBoxView = [[FBOpenBoxView alloc] init];
        _myGoldenBoxView.delegate = self;
        _myGoldenBoxView.mbVC = self;
        _myGoldenBoxView.boxType = FBGoldenBox;
        [self.view addSubview:_myGoldenBoxView];
        
        if (!IS_IPHONE_4_OR_LESS) {
            [_myGoldenBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(290*RATIO, 405*RATIO));
                make.left.mas_equalTo(ws.diamondButton.mas_right).offset(30 * RATIO);
                make.top.mas_equalTo(ws.goldNumImageView.mas_bottom).offset(17 * RATIO);
            }];
        } else {
            [_myGoldenBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(290*0.97*RATIO, 405*0.97*RATIO));
                make.left.mas_equalTo(ws.diamondButton.mas_right).offset(15 * RATIO);
                make.top.mas_equalTo(ws.goldNumImageView.mas_bottom).offset(1 * RATIO);
            }];
        }
    }
    
    return _myGoldenBoxView;
}

- (FBOpenBoxView *)myArgentBoxView
{
    WS(ws);
    
    if (_myArgentBoxView == nil) {
        _myArgentBoxView = [[FBOpenBoxView alloc] init];
        _myArgentBoxView.delegate = self;
        _myArgentBoxView.mbVC = self;
        _myArgentBoxView.boxType = FBArgentBox;
        [self.view addSubview:_myArgentBoxView];
        
        if (!IS_IPHONE_4_OR_LESS) {
            [_myArgentBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(290*RATIO, 405*RATIO));
                make.left.mas_equalTo(ws.diamondButton.mas_right).offset(30 * RATIO);
                make.top.mas_equalTo(ws.goldNumImageView.mas_bottom).offset(17 * RATIO);
            }];
        } else {
            [_myArgentBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(290*0.97*RATIO, 405*0.97*RATIO));
                make.left.mas_equalTo(ws.diamondButton.mas_right).offset(15 * RATIO);
                make.top.mas_equalTo(ws.goldNumImageView.mas_bottom).offset(1 * RATIO);
            }];
        }
    }
    
    return _myArgentBoxView;
}

- (FBOpenBoxView *)myWoodenBoxView
{
    WS(ws);
    
    if (_myWoodenBoxView == nil) {
        _myWoodenBoxView = [[FBOpenBoxView alloc] init];
        _myWoodenBoxView.delegate = self;
        _myWoodenBoxView.mbVC = self;
        _myWoodenBoxView.boxType = FBWoodenBox;
        [self.view addSubview:_myWoodenBoxView];

        if (!IS_IPHONE_4_OR_LESS) {
            [_myWoodenBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(290*RATIO, 405*RATIO));
                make.left.mas_equalTo(ws.diamondButton.mas_right).offset(30 * RATIO);
                make.top.mas_equalTo(ws.goldNumImageView.mas_bottom).offset(17 * RATIO);
            }];
        } else {
            [_myWoodenBoxView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(290*0.97*RATIO, 405*0.97*RATIO));
                make.left.mas_equalTo(ws.diamondButton.mas_right).offset(15 * RATIO);
                make.top.mas_equalTo(ws.goldNumImageView.mas_bottom).offset(1 * RATIO);
            }];
        }
    }
    
    return _myWoodenBoxView;
}

- (UIVisualEffectView *)visualView
{
    if (_visualView == nil) {
        UIView *view = [[UIView alloc] init];
        view.frame = self.view.bounds;
        view.alpha = 0;
        [self.view addSubview:view];
        
        _visualView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
        _visualView.frame = self.view.bounds;
        [view addSubview:_visualView];
        
        [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            view.alpha = 1;
        } completion:nil];
    }
    
    return _visualView;
}

#pragma mark ----------------------button action------------------------
- (void)backButtonPress:(UIButton *)button
{
    NSLog(@"backButton");
}

- (void)diamondButtonPress:(UIButton *)button
{
    if (self.currentBoxView != self.myDiamondBoxView) {
        [self addTransationAnimInOpenBoxView:self.myDiamondBoxView];
    
        [self.view bringSubviewToFront:self.myDiamondBoxView];
        
        [self.myGoldenBoxView closeBox];
        [self.myArgentBoxView closeBox];
        [self.myWoodenBoxView closeBox];
        
        [self goldNumChange];
        
        self.currentBoxView = self.myDiamondBoxView;
    }
}



- (void)goldenButtonPress:(UIButton *)button
{
    if (self.currentBoxView != self.myGoldenBoxView) {
        [self addTransationAnimInOpenBoxView:self.myGoldenBoxView];
    
        [self.view bringSubviewToFront:self.myGoldenBoxView];
    
        [self.myDiamondBoxView closeBox];
        [self.myArgentBoxView closeBox];
        [self.myWoodenBoxView closeBox];
        
        [self goldNumChange];
        
        self.currentBoxView = self.myGoldenBoxView;
    }
}

- (void)argentButtonPress:(UIButton *)button
{
    if (self.currentBoxView != self.myArgentBoxView) {
        [self addTransationAnimInOpenBoxView:self.myArgentBoxView];
    
        [self.view bringSubviewToFront:self.myArgentBoxView];
    
        [self.myDiamondBoxView closeBox];
        [self.myGoldenBoxView closeBox];
        [self.myWoodenBoxView closeBox];
        
        [self goldNumChange];
        
        self.currentBoxView = self.myArgentBoxView;
    }
}

- (void)woodenButtonPress:(UIButton *)button
{
    if (self.currentBoxView != self.myWoodenBoxView) {
        [self addTransationAnimInOpenBoxView:self.myWoodenBoxView];
    
        [self.view bringSubviewToFront:self.myWoodenBoxView];
    
        [self.myDiamondBoxView closeBox];
        [self.myGoldenBoxView closeBox];
        [self.myArgentBoxView closeBox];
        
        [self goldNumChange];
        
        self.currentBoxView = self.myWoodenBoxView;
    }
}

- (void)purchaseButtonPress:(UIButton *)button
{
    WS(ws);
    
    // TODO:发出购买钥匙请求
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // HTTP GET
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.currentKeyType == FBDiamondKey) {
                if (ws.goldNum >= 40) {
                    ws.goldNum -= 40;
                    [ws goldNumChange];
                    
                    ws.diamondKeyStarNum++;
                    ws.diamondKeyStarLabel.text = [NSString stringWithFormat:@"%ld", (long)ws.diamondKeyStarNum];
                    
                    [ws visualViewFuckOff];
                    [ws addKeyStarAnim:ws.diamondKeyStarImageView];
                } else {
                    [ws visualViewInitWhenGoldIsNotEnough];
                }
            } else if (self.currentKeyType == FBGoldenKey) {
                if (ws.goldNum >= 30) {
                    ws.goldNum -= 30;
                    [ws goldNumChange];
                    
                    ws.goldenKeyStarNum++;
                    ws.goldenKeyStarLabel.text = [NSString stringWithFormat:@"%ld", (long)ws.goldenKeyStarNum];
                    
                    [ws visualViewFuckOff];
                    [ws addKeyStarAnim:ws.goldenKeyStarImageView];
                } else {
                    [ws visualViewInitWhenGoldIsNotEnough];
                }
            } else if (self.currentKeyType == FBArgentKey) {
                if (ws.goldNum >= 20) {
                    ws.goldNum -= 20;
                    [ws goldNumChange];
                    
                    ws.argentKeyStarNum++;
                    ws.argentKeyStarLabel.text = [NSString stringWithFormat:@"%ld", (long)ws.argentKeyStarNum];
                    
                    [ws visualViewFuckOff];
                    [ws addKeyStarAnim:ws.argentKeyStarImageView];
                } else {
                    [ws visualViewInitWhenGoldIsNotEnough];
                }
            } else if (self.currentKeyType == FBWoodenKey) {
                if (ws.goldNum >= 10) {
                    ws.goldNum -= 10;
                    [ws goldNumChange];
                    
                    ws.woodenKeyStarNum++;
                    ws.woodenKeyStarLabel.text = [NSString stringWithFormat:@"%ld", (long)ws.woodenKeyStarNum];
                    
                    [ws visualViewFuckOff];
                    [ws addKeyStarAnim:ws.woodenKeyStarImageView];
                } else {
                    [ws visualViewInitWhenGoldIsNotEnough];
                }
            }
        });
    });
}

- (void)nextTimeButtonPress:(UIButton *)button
{
    [self visualViewFuckOff];
}

#pragma mark ----------------------GestureRecognizer------------------------
- (void)tapWoodenKey
{
    [self visualViewInitWhenKeyIsNotEnoughWithKeyType:FBWoodenKey];
}

- (void)tapArgentKey
{
    [self visualViewInitWhenKeyIsNotEnoughWithKeyType:FBArgentKey];
}

- (void)tapGoldenKey
{
    [self visualViewInitWhenKeyIsNotEnoughWithKeyType:FBGoldenKey];
}

- (void)tapDiamondKey
{
    [self visualViewInitWhenKeyIsNotEnoughWithKeyType:FBDiamondKey];
}


#pragma mark ----------------------FBOpenBoxViewDelegate------------------------
- (BOOL)openButtonWillBePressedInOpenBoxView:(FBOpenBoxView *)openBoxView
{
    if (openBoxView == self.myDiamondBoxView) {
        if (self.diamondKeyStarNum == 0) {
            [self visualViewInitWhenKeyIsNotEnoughWithKeyType:FBDiamondKey];
            return NO;
        }
    } else if (openBoxView == self.myGoldenBoxView) {
        if (self.goldenKeyStarNum == 0) {
            [self visualViewInitWhenKeyIsNotEnoughWithKeyType:FBGoldenKey];
            return NO;
        }
    } else if (openBoxView == self.myArgentBoxView) {
        if (self.argentKeyStarNum == 0) {
            [self visualViewInitWhenKeyIsNotEnoughWithKeyType:FBArgentKey];
            return NO;
        }
    } else if (openBoxView == self.myWoodenBoxView) {
        if (self.woodenKeyStarNum == 0) {
            [self visualViewInitWhenKeyIsNotEnoughWithKeyType:FBWoodenKey];
            return NO;
        }
    }
    
    return YES;
}

- (void)openButtonBeingPressedInOpenBoxView:(FBOpenBoxView *)openBoxView
{
    WS(ws);
    
    // TODO:从后台拿到数据，判断奖励是否是金币
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // TODO:网络获取开宝箱奖励
        dispatch_async(dispatch_get_main_queue(), ^{
            NSMutableArray<UIView *> *toyViews = [NSMutableArray array];
            
            FBCoupon *couponView = [[FBCoupon alloc] init];
            couponView.couponType = FBCouponViewTypeEXP;
            couponView.exp = 99;
            couponView.discount = @"10K";
            couponView.shopIconImage = imageOfAutoScaleImage(@"cabin.png");
            couponView.shopName = @"玩具反斗城";
            couponView.toysImage = imageOfAutoScaleImage(@"cabin.png");
            couponView.coinNumber = 50;
            
            [toyViews addObject:couponView];
            
            FBCoupon *couponView2 = [[FBCoupon alloc] init];
            couponView2.couponType =  FBCouponViewTypeCoin;
            couponView2.coinNumber = 500;
            couponView2.shopIconImage = imageOfAutoScaleImage(@"cabin.png");
            couponView2.shopName = @"玩具反斗城";
            couponView2.toysImage = imageOfAutoScaleImage(@"cabin.png");
            
            [toyViews addObject:couponView2];
            
            FBCoupon *couponView3 = [[FBCoupon alloc] init];
            couponView3.couponType =  FBCouponViewTypeCoin;
            couponView3.coinNumber = 100;
            couponView3.shopIconImage = imageOfAutoScaleImage(@"cabin.png");
            couponView3.shopName = @"玩具反斗城";
            couponView3.toysImage = imageOfAutoScaleImage(@"cabin.png");
            
            [toyViews addObject:couponView3];
            
            FBCoupon *couponView4 = [[FBCoupon alloc] init];
            couponView4.couponType =  FBCouponViewTypeDiscountCoupon;
            couponView4.coinNumber = openBoxView.toyGoldNum;
            couponView4.discount = @"99K";
            couponView4.shopIconImage = imageOfAutoScaleImage(@"cabin.png");
            couponView4.shopName = @"天上掉钱了";
            couponView4.toysImage = imageOfAutoScaleImage(@"cabin.png");
            
            [toyViews addObject:couponView4];
            
            NSMutableDictionary *toysIsGold = [NSMutableDictionary dictionary];
            [toysIsGold setObject:@"FALSE" forKey:@0];
            [toysIsGold setObject:@"TRUE" forKey:@1];
            [toysIsGold setObject:@"TRUE" forKey:@2];
            [toysIsGold setObject:@"FALSE" forKey:@3];
            
            NSMutableDictionary *toysGoldNum = [NSMutableDictionary dictionary];
            [toysGoldNum setObject:@50 forKey:@0];
            [toysGoldNum setObject:@500 forKey:@1];
            [toysGoldNum setObject:@100 forKey:@2];
            
            [openBoxView setToys:toyViews isGold:toysIsGold goldNum:toysGoldNum];
            
            ws.goldSum = ws.goldNum + 650;
            

        });
    });
}

- (void)openButtonBePressedInOpenBoxView:(FBOpenBoxView *)openBoxView
{
    if (openBoxView == self.myDiamondBoxView) {
        if (self.diamondKeyStarNum != 0) {
            self.diamondStarNum--;
            self.diamondKeyStarNum--;
            
            self.diamondStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.diamondStarNum];
            self.diamondKeyStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.diamondKeyStarNum];
        }
    } else if (openBoxView == self.myGoldenBoxView) {
        if (self.goldenKeyStarNum != 0) {
            self.goldenStarNum--;
            self.goldenKeyStarNum--;
            
            self.goldenStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.goldenStarNum];
            self.goldenKeyStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.goldenKeyStarNum];
        }
    } else if (openBoxView == self.myArgentBoxView) {
        if (self.argentKeyStarNum != 0) {
            self.argentStarNum--;
            self.argentKeyStarNum--;
            
            self.argentStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.argentStarNum];
            self.argentKeyStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.argentKeyStarNum];
        }
    } else if (openBoxView == self.myWoodenBoxView) {
        if (self.woodenKeyStarNum != 0) {
            self.woodenStarNum--;
            self.woodenKeyStarNum--;
            
            self.woodenStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.woodenStarNum];
            self.woodenKeyStarLabel.text = [NSString stringWithFormat:@"%ld", (long)self.woodenKeyStarNum];
        }
    }
}

- (void)showDetailOfToyInOpenBoxView:(FBOpenBoxView *)openBoxView
{
    #pragma mark TODO:跳转到玩具详情
    if (openBoxView == self.myDiamondBoxView) {
        NSLog(@"idsmondBox showdetail");
    } else if (openBoxView == self.myGoldenBoxView) {
    } else if (openBoxView == self.myArgentBoxView) {
    } else if (openBoxView == self.myWoodenBoxView) {
    }
}

- (void)saveToyInOpenBoxView:(FBOpenBoxView *)openBoxView
{
    if (openBoxView == self.myDiamondBoxView) {
        NSLog(@"diamondBox save");
    } else if (openBoxView == self.myGoldenBoxView) {
    } else if (openBoxView == self.myArgentBoxView) {
    } else if (openBoxView == self.myWoodenBoxView) {
    }
}

#pragma mark ----------------------other------------------------
- (void)visualViewInitWhenKeyIsNotEnoughWithKeyType:(FBKeyType)keyType
{
    WS(ws);
    
    self.currentKeyType = keyType;
    
    // 水色背景
    UIImageView *waterBGImageView2 = imageViewOfAutoScaleImage(@"background2.png");
    waterBGImageView2.layer.contentsCenter = CGRectMake(0, 0.45, 1, 0.1);
    [self.visualView.contentView addSubview:waterBGImageView2];
    [waterBGImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 154));
        make.centerX.mas_equalTo(ws.visualView.contentView.mas_centerX);
        make.top.mas_equalTo(ws.visualView.contentView).offset(240 * RATIO_V);
    }];
    
    // 水色背景
    UIImageView *waterBGImageView = imageViewOfAutoScaleImage(@"background1.png");
    waterBGImageView.layer.contentsCenter = CGRectMake(0, 0.45, 1, 0.1);
    [self.visualView.contentView addSubview:waterBGImageView];
    [waterBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 154));
        make.centerX.mas_equalTo(ws.visualView.contentView.mas_centerX);
        make.top.mas_equalTo(ws.visualView.contentView).offset(240 * RATIO_V);
    }];
    
    // 水色背景上的label
    NSAttributedString        *componentStr  = [[NSAttributedString alloc] initWithString:@"                 "];
    NSAttributedString        *component2Str = nil;
    
    NSMutableAttributedString *huanhangStr   = [[NSMutableAttributedString alloc] initWithString:@"\n \n"];
    [huanhangStr setAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:7]} range:NSMakeRange(1, 1)];
    
    NSAttributedString        *component3Str = [[NSAttributedString alloc] initWithString:@"用于开启"];
    NSAttributedString        *component4Str = nil;
    NSAttributedString        *component5Str = [[NSAttributedString alloc] initWithString:@"宝箱获得自由漂宝贝，确认花费"];
    NSAttributedString        *component6Str = nil;
    NSAttributedString        *component7Str = [[NSAttributedString alloc] initWithString:@"购买钥匙吗？"];
    
    NSMutableAttributedString *stateStr = [[NSMutableAttributedString alloc] initWithString:@""];
    
    if (keyType == FBDiamondKey) {
        componentStr  = [[NSAttributedString alloc] initWithString:@"                "];
        component2Str = [[NSAttributedString alloc] initWithString:@"钻石钥匙" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        component4Str = [[NSAttributedString alloc] initWithString:@"钻石"];
        component6Str = [[NSAttributedString alloc] initWithString:@"40漂贝" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    } else if (keyType == FBGoldenKey) {
        component2Str = [[NSAttributedString alloc] initWithString:@"金钥匙" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        component4Str = [[NSAttributedString alloc] initWithString:@"金"];
        component6Str = [[NSAttributedString alloc] initWithString:@"30漂贝" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    } else if (keyType == FBArgentKey) {
        component2Str = [[NSAttributedString alloc] initWithString:@"银钥匙" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        component4Str = [[NSAttributedString alloc] initWithString:@"银"];
        component6Str = [[NSAttributedString alloc] initWithString:@"20漂贝" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    } else if (keyType == FBWoodenKey) {
        component2Str = [[NSAttributedString alloc] initWithString:@"木钥匙" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
        component4Str = [[NSAttributedString alloc] initWithString:@"木"];
        component6Str = [[NSAttributedString alloc] initWithString:@"10漂贝" attributes:@{NSForegroundColorAttributeName:[UIColor redColor]}];
    }
    
    [stateStr appendAttributedString:componentStr];
    [stateStr appendAttributedString:component2Str];
    [stateStr appendAttributedString:huanhangStr];
    [stateStr appendAttributedString:component3Str];
    [stateStr appendAttributedString:component4Str];
    [stateStr appendAttributedString:component5Str];
    [stateStr appendAttributedString:component6Str];
    [stateStr appendAttributedString:component7Str];
    
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.numberOfLines = 0;
    stateLabel.attributedText = stateStr;
    [waterBGImageView addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@208.0);
        make.centerX.mas_equalTo(waterBGImageView.mas_centerX);
        make.top.mas_equalTo(waterBGImageView).offset(30);
    }];
    
    // 光
    UIImageView *haloImageView = imageViewOfAutoScaleImage(@"Halo.png");
    [self.visualView.contentView insertSubview:haloImageView aboveSubview:waterBGImageView2];
    [haloImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 97));
        make.centerX.mas_equalTo(ws.visualView.contentView.mas_centerX);
        make.bottom.mas_equalTo(waterBGImageView2.mas_top).offset(21);
    }];
    
    // 钥匙
    UIImageView *keyImageView = nil;
    
    if (keyType == FBDiamondKey) {
        keyImageView = imageViewOfAutoScaleImage(@"key1.png");
    } else if (keyType == FBGoldenKey) {
        keyImageView = imageViewOfAutoScaleImage(@"key2.png");
    } else if (keyType == FBArgentKey) {
        keyImageView = imageViewOfAutoScaleImage(@"key3.png");
    } else if (keyType == FBWoodenKey) {
        keyImageView = imageViewOfAutoScaleImage(@"key4.png");
    }
    
    [self.visualView.contentView insertSubview:keyImageView aboveSubview:haloImageView];
    [keyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.centerX.mas_equalTo(ws.visualView.contentView.mas_centerX);
        make.bottom.mas_equalTo(waterBGImageView2.mas_top).offset(21);
    }];
    
    // “确认购买”按钮
    UIButton *purchaseButton = [[UIButton alloc] init];
    [purchaseButton setImage:imageOfAutoScaleImage(@"purchase.png") forState:UIControlStateNormal];
    [purchaseButton addTarget:self action:@selector(purchaseButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.visualView.contentView addSubview:purchaseButton];
    [purchaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 21));
        make.right.mas_equalTo(ws.visualView.contentView.mas_centerX).offset(-13 * RATIO);
        make.top.mas_equalTo(waterBGImageView.mas_bottom).offset(10);
    }];
    
    // “下次再说”按钮
    UIButton *nextTimeButton = [[UIButton alloc] init];
    [nextTimeButton setImage:imageOfAutoScaleImage(@"Next time.png") forState:UIControlStateNormal];
    [nextTimeButton addTarget:self action:@selector(nextTimeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.visualView.contentView addSubview:nextTimeButton];
    [nextTimeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 21));
        make.left.mas_equalTo(ws.visualView.contentView.mas_centerX).offset(13 * RATIO);
        make.top.mas_equalTo(waterBGImageView.mas_bottom).offset(10);
    }];
    
    self.visualView.contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        ws.visualView.contentView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
}

- (void)visualViewInitWhenGoldIsNotEnough
{
    WS(ws);
    
    NSArray *views = [self.visualView.contentView subviews];
    for (UIView* view in views) {
        [view removeFromSuperview];
    }
    
    // 水色背景
    UIImageView *waterBGImageView2 = imageViewOfAutoScaleImage(@"background2.png");
    waterBGImageView2.layer.contentsCenter = CGRectMake(0, 0.45, 1, 0.1);
    [self.visualView.contentView addSubview:waterBGImageView2];
    [waterBGImageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 154));
        make.centerX.mas_equalTo(ws.visualView.contentView.mas_centerX);
        make.top.mas_equalTo(ws.visualView.contentView).offset(240 * RATIO_V);
    }];
    
    // 水色背景
    UIImageView *waterBGImageView = imageViewOfAutoScaleImage(@"background1.png");
    waterBGImageView.layer.contentsCenter = CGRectMake(0, 0.45, 1, 0.1);
    [self.visualView.contentView addSubview:waterBGImageView];
    [waterBGImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(250, 154));
        make.centerX.mas_equalTo(ws.visualView.contentView.mas_centerX);
        make.top.mas_equalTo(ws.visualView.contentView).offset(240 * RATIO_V);
    }];

    // 水色背景上的label
    UILabel *stateLabel = [[UILabel alloc] init];
    stateLabel.numberOfLines = 0;
    stateLabel.text = @"漂贝不够了~\n分享宝贝获得更多漂贝吧";
    stateLabel.textAlignment = NSTextAlignmentCenter;
    stateLabel.textColor = [UIColor colorWithRed:29.0f/255.0f green:98.0f/255.0f blue:115.0f/255.0f alpha:1.0f];
    stateLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightBold];
    [waterBGImageView addSubview:stateLabel];
    [stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(@208.0);
        make.centerX.mas_equalTo(waterBGImageView.mas_centerX);
        make.top.mas_equalTo(waterBGImageView).offset(30);
    }];
    
    // 光
    UIImageView *haloImageView = imageViewOfAutoScaleImage(@"Halo.png");
    [self.visualView.contentView insertSubview:haloImageView aboveSubview:waterBGImageView2];
    [haloImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(160, 97));
        make.centerX.mas_equalTo(ws.visualView.contentView.mas_centerX);
        make.bottom.mas_equalTo(waterBGImageView2.mas_top).offset(21);
    }];
    
    // 金币
    UIImageView *goldImageView = imageViewOfAutoScaleImage(@"box coin.png");
    [self.visualView.contentView insertSubview:goldImageView aboveSubview:haloImageView];
    [goldImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(70, 70));
        make.centerX.mas_equalTo(ws.visualView.contentView.mas_centerX);
        make.bottom.mas_equalTo(waterBGImageView2.mas_top).offset(21);
    }];
    
    // “我知道了”按钮
    UIButton *knowButton = [[UIButton alloc] init];
    [knowButton setImage:imageOfAutoScaleImage(@"know.png") forState:UIControlStateNormal];
    [knowButton addTarget:self action:@selector(nextTimeButtonPress:) forControlEvents:UIControlEventTouchUpInside];
    [self.visualView.contentView addSubview:knowButton];
    [knowButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(67, 21));
        make.centerX.mas_equalTo(ws.visualView.contentView.centerX);
        make.top.mas_equalTo(waterBGImageView.mas_bottom).offset(12);
    }];
    
    self.visualView.contentView.transform = CGAffineTransformMakeScale(0, 0);
    [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        ws.visualView.contentView.transform = CGAffineTransformMakeScale(1, 1);
    } completion:nil];
 
}

- (void)visualViewFuckOff
{
    WS(ws);
    
    [UIView animateWithDuration:0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        ws.visualView.superview.alpha = 0;
    } completion:^(BOOL finished) {
        [self.visualView.superview removeFromSuperview];
        self.visualView = nil;
    }];
}

- (CGPoint)boatPosition
{
    return self.boatImageView.layer.position;
}

- (CGRect)goldNumFrame
{
    return self.goldNumImageView.frame;
}

- (void)goldNumChange
{
    [self.goldNumLabel countFromCurrentValueTo:self.goldSum withDuration:1.3];
    self.goldNum = self.goldSum;
}

- (void)goldNumChange:(NSInteger)num
{
    self.goldNum += num;
    [self.goldNumLabel countFromCurrentValueTo:self.goldNum withDuration:1.3];
}

- (void)boatShake
{
    [self addShakeAnim:self.boatImageView];
}

#pragma mark ----------------------anim------------------------
- (void)addTransationAnimInOpenBoxView:(FBOpenBoxView *)openBoxView
{
    CGFloat oldX = openBoxView.layer.position.x;
    CABasicAnimation *x_anim= [CABasicAnimation animationWithKeyPath:@"position.x"];
    x_anim.duration = 0.2;
    x_anim.beginTime = 0;
    x_anim.autoreverses = NO;
    x_anim.fromValue = [NSNumber numberWithFloat:oldX + 250*RATIO];
    x_anim.toValue = [NSNumber numberWithFloat:oldX];
    x_anim.removedOnCompletion = YES;
    
    CABasicAnimation *animOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animOpacity.duration = 0.2;
    animOpacity.beginTime = 0;
    animOpacity.autoreverses = NO;
    animOpacity.fromValue = [NSNumber numberWithFloat:0];
    animOpacity.toValue = [NSNumber numberWithFloat:1];
    animOpacity.removedOnCompletion = YES;
    
    CAAnimationGroup *anim_group = [CAAnimationGroup animation];
    anim_group = [CAAnimationGroup animation];
//    anim_group.animations = @[x_anim, animOpacity];
    anim_group.animations = @[x_anim];
    anim_group.beginTime = 0;
    anim_group.duration = 0.2;
    anim_group.removedOnCompletion = YES;
    anim_group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [openBoxView.layer addAnimation:anim_group forKey:nil];
}

- (void)addShakeAnim:(UIView *)view
{
    CGFloat oldX = view.layer.position.x;
    CABasicAnimation *x_anim_R = [CABasicAnimation animationWithKeyPath:@"position.x"];
    x_anim_R.duration = 0.02;
    x_anim_R.beginTime = 0;
    x_anim_R.autoreverses = NO;
    x_anim_R.toValue = [NSNumber numberWithFloat:oldX + 3.5*RATIO];
    x_anim_R.removedOnCompletion = NO;
    x_anim_R.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *x_anim_L = [CABasicAnimation animationWithKeyPath:@"position.x"];
    x_anim_L.duration = 0.04;
    x_anim_L.beginTime = 0.02;
    x_anim_L.autoreverses = NO;
    x_anim_L.toValue = [NSNumber numberWithFloat:oldX - 7*RATIO];
    x_anim_L.removedOnCompletion = NO;
    x_anim_L.fillMode = kCAFillModeForwards;
    
    CAAnimationGroup *anim_group = [CAAnimationGroup animation];
    anim_group = [CAAnimationGroup animation];
    anim_group.animations = @[x_anim_R, x_anim_L];
    anim_group.beginTime = 0;
    anim_group.duration = 0.06;
    anim_group.autoreverses = YES;
    anim_group.removedOnCompletion = NO;
    anim_group.fillMode = kCAFillModeForwards;
    anim_group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [view.layer addAnimation:anim_group forKey:nil];
}

- (void)addKeyStarAnim:(UIView *)view
{
    [UIView animateKeyframesWithDuration:1.7 delay:0.2 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.07 animations:^{
            view.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.07 relativeDuration:0.06 animations:^{
            view.transform = CGAffineTransformMakeScale(1, 1);
        }];
    } completion:nil];
 
}

@end
