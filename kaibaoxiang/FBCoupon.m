//
//  FBCoupon.m
//  FBCouponView
//
//  Created by 朱志先 on 16/7/12.
//  Copyright © 2016年 朱志先. All rights reserved.
//

#import "FBCoupon.h"
#import "UIImage+ImageRendering.h"
@interface FBCoupon()

@property (nonatomic, strong) UIImageView *couponPaper;
@property (nonatomic, strong) UIImageView *coinBag;
@property (nonatomic, strong) UIImageView *toysBackground;
@property (nonatomic, strong) UIImageView *toysTitle;
@property (nonatomic, strong) UIImageView *toys;
@property (nonatomic, strong) UIImageView *shopIcon;
@property (nonatomic, strong) UIImageView *fireworksBackground;
@property (nonatomic, strong) UIImageView *shopIconBorder;
@property (nonatomic, strong) UILabel *couponTypeDescribeLable;
@property (nonatomic, strong) UILabel *coupondDiscountLable;
@property (nonatomic, strong) UILabel *couponShopLable;
@property (nonatomic, strong) CoinView *coinView;
@property (nonatomic, strong) UIImageView *customImageView;
@property (nonatomic, assign) CGFloat fontSizeRatio;
@property (nonatomic, strong) UIImageView *expImageView;
@property (nonatomic, strong) UILabel *expLable;

@end

@implementation FBCoupon

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat height = [UIScreen mainScreen].bounds.size.height;
        if (height > 700) {
            self.fontSizeRatio = 1;
        }
        else if(height > 650)
        {
            self.fontSizeRatio = 0.85;
        }
        else if(height > 550)
        {
            self.fontSizeRatio = 0.75;
        }
        else if(height > 0)
        {
            self.fontSizeRatio = 0.97 * 0.75;
        }
    }
    return self;
}

//根据样式设置内容
- (void)setCouponType:(FBCouponViewType)couponType
{
    
        _couponType = couponType;
        switch (couponType)
        {
            case FBCouponViewTypeCoin:
                [self setCoinStyle];
                break;
            case FBCouponViewTypeDiscountCoupon:
                [self setDiscountStyle];
                break;
            case FBCouponViewTypeCashCoupon:
                [self setCashStyle];
                break;
            case FBCouponViewTypeCustomCoupon:
                [self setCustomCouponStyle];
                break;
            case FBCouponViewTypeToyCoupon:
                [self setToyStyle];
                break;
            case FBCouponViewTypeCustomType:
                [self setCustomStyle];
                break;
            case FBCouponViewTypeEXP:
                [self setEXPStyle];
                break;
                
            default:
                break;
        }
    
    
}

- (void)setCoinStyle
{
    [self removeAllSubviews];
    
    _coinBag = [UIImageView new];
    if (_coinBagImage) {
        _coinBag.image = _coinBagImage;
    }
    else
    {
        _coinBag.image = kGetImage(@"Purse.png");
    }
    

    
    [self addSubview:_coinBag];
    [_coinBag mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
   
    
    _coinView = [CoinView new];
    
    if (_coinNumberFont) {
        _coinView.coinNumerFont = _coinNumberFont;
    }
    else
    {
        _coinView.coinNumerFont = [UIFont fontWithName:@"AvenirNext-Heavy" size:20 * _fontSizeRatio];
    }
    
    [self addSubview:_coinView];
    [_coinView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.width).multipliedBy(0.3441);
        make.height.equalTo(self.height).multipliedBy(0.15);
        make.left.equalTo(self.right).multipliedBy(0.2744);
        make.bottom.equalTo(self.bottom).multipliedBy(1 - 0.20625);
        
    
    }];

    if(_coinNumber)
    {
        _coinView.coinNumber = _coinNumber;
    }
    

}

- (void)setBasicCoupon
{
    _couponPaper = [UIImageView new];
    if (_couponPaperImage) {
        _couponPaper.image = _couponPaperImage;
    }
    else
    {
        _couponPaper.image = kGetImage(@"coupon1.png");
    }
    
    [self addSubview:_couponPaper];
    [_couponPaper mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    

    _coupondDiscountLable = [UILabel new];
    if (_discount) {
        _coupondDiscountLable.text = _discount;
    }
    _coupondDiscountLable.textAlignment = NSTextAlignmentCenter;
    
    if (_discountFont)
    {
        _coupondDiscountLable.font = _discountFont;
    }
    else
    {
        _coupondDiscountLable.font = [UIFont fontWithName:@"Avenir-Heavy" size:45 * _fontSizeRatio];
    }
    
    
    if (_discountColor)
    {
        _coupondDiscountLable.textColor = _discountColor;
        
    }
    else
    {
        _coupondDiscountLable.textColor = [UIColor whiteColor];
    }
    
    [self addSubview:_coupondDiscountLable];
    [_coupondDiscountLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self).multipliedBy(0.4186);
        make.height.equalTo(self).multipliedBy(0.26);
        make.left.equalTo(self.right).multipliedBy(0.13553);
        make.top.equalTo(self.bottom).multipliedBy(0.30625);
    }];
    
    _couponTypeDescribeLable = [UILabel new];
    if (_customDiscountDescribe) {
        _couponTypeDescribeLable.text = _customDiscountDescribe;
    }
    [self addSubview:_couponTypeDescribeLable];
    
    
    if (_discountDescribeFont)
    {
        _couponTypeDescribeLable.font = _discountDescribeFont;
    }
    else
    {
        _couponTypeDescribeLable.font = [UIFont fontWithName:@"Avenir-Black" size:15 * _fontSizeRatio];
    }
    
    if (_discountDescribeColor) {
        _couponTypeDescribeLable.textColor = _discountDescribeColor;
    }
    else
    {
        _couponTypeDescribeLable.textColor = [UIColor whiteColor];
    }
    _couponTypeDescribeLable.textAlignment = NSTextAlignmentCenter;
    
    [_couponTypeDescribeLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_coupondDiscountLable);
        make.top.equalTo(_coupondDiscountLable.bottom);
        make.left.equalTo(_coupondDiscountLable);
        make.height.equalTo(_coupondDiscountLable).multipliedBy(0.5);
    }];
    
    _shopIcon = [UIImageView new];
    if (_shopIconImage) {
        _shopIcon.image = _shopIconImage;
    }
    [self addSubview:_shopIcon];
    [_shopIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.height).multipliedBy(0.25);
        make.width.equalTo(self.width).multipliedBy(0.18605);
        make.right.equalTo(self.right).multipliedBy(0.8);
        make.top.equalTo(self.bottom).multipliedBy(0.2875);
    }];
    
    _couponShopLable = [UILabel new];
    if (_shopName) {
        _couponShopLable.text = _shopName;
    }
    [self addSubview:_couponShopLable];
    _couponShopLable.textAlignment = NSTextAlignmentCenter;
    
    if (_shopNameColor) {
        self.couponShopLable.textColor = _shopNameColor;
    }
    else
    {
        _couponShopLable.textColor = [UIColor whiteColor];
    }
    
    if (_shopNameFont) {
        _couponShopLable.font = _shopNameFont;
    }
    else
    {
        _couponShopLable.font = [UIFont fontWithName:@"Avenir-Black" size:11 * _fontSizeRatio];

    }
    
        _couponShopLable.numberOfLines = 2;
    [_couponShopLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(_shopIcon);
        make.height.equalTo(_shopIcon).multipliedBy(0.8);
        make.left.equalTo(_shopIcon);
        make.top.equalTo(_shopIcon.bottom).offset(4);
 
    }];
    
    
    _fireworksBackground = [UIImageView new];
    if (_couponBackgroundImage) {
        _fireworksBackground.image = _couponBackgroundImage;
    }
    else
    {
        _fireworksBackground.image = kGetImage(@"coupon3.png");
    }
    
    [self addSubview:_fireworksBackground];
    [_fireworksBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}


- (void)setDiscountStyle
{
    [self removeAllSubviews];
    
    [self setBasicCoupon];
    self.couponTypeDescribeLable.text = @"活动折扣券";
    
}

- (void)setCashStyle
{
    [self removeAllSubviews];
    
    [self setBasicCoupon];
    self.couponTypeDescribeLable.text = @"现金折扣券";

}

- (void)setCustomCouponStyle
{
    [self removeAllSubviews];
    
    [self setBasicCoupon];

}

- (void)setToyStyle
{
    [self removeAllSubviews];
    
    _toysBackground = [UIImageView new];
    if (_toyBackgroudImage)
    {
        _toysBackground.image = _toyBackgroudImage;
    }
    else
    {
        _toysBackground.image = kGetImage(@"toys@3x.png");
    }
    
    [self addSubview:_toysBackground];
    [_toysBackground mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    _toys = [UIImageView new];
    if (_toysImage) {
        _toys.image = _toysImage;
    }
    [self addSubview:_toys];
    [_toys mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.height).multipliedBy(0.625);
        make.width.equalTo(self.width).multipliedBy(0.46512);
        make.top.equalTo(self.bottom).multipliedBy(0.05625);
        make.left.equalTo(self.right).multipliedBy(0.22791);
    }];
    
    _toysTitle = [UIImageView new];
    if (_toyTitleIamge) {
        _toysTitle.image = _toyTitleIamge;
    }
    else
    {
        _toysTitle.image = kGetImage(@"toys2.png");
    }
    
    [self addSubview:_toysTitle];
    [_toysTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    
}

- (void)removeAllSubviews
{
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)setCustomStyle
{
    [self removeAllSubviews];
    self.customImageView = [UIImageView new];
    [self addSubview:self.customImageView];

    if (_customImage) {
        self.customImageView.image = _customImage;
    }
    
    [self.customImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
}

- (void)setEXPStyle
{
    [self removeAllSubviews];
    self.expImageView = [UIImageView new];
    self.expImageView.image = kGetImage(@"exp.png");
    [self addSubview:self.expImageView];
    [self.expImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    self.expLable = [UILabel new];
    self.expLable.textColor = [UIColor whiteColor];
    self.expLable.textAlignment = NSTextAlignmentCenter;
    self.expLable.adjustsFontSizeToFitWidth = YES;
    self.expLable.font = [UIFont systemFontOfSize:20 weight:5];
    [self addSubview:self.expLable];
    if (_exp) {
        [self setExp:_exp];
    };
    [self.expLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.height).multipliedBy(0.52500);
        make.width.equalTo(self.width).multipliedBy(0.41395);
        make.top.equalTo(self.bottom).multipliedBy(0.3625);
        make.left.equalTo(self.right).multipliedBy(0.25581);
    }];
    
    
    
}


//设置优惠券内容
- (void)setDiscount:(NSString *)discount
{
    _discount = discount;
    self.coupondDiscountLable.text = discount;

}

- (void)setShopName:(NSString *)shopName
{
    _shopName = shopName;
    self.couponShopLable.text = shopName;
}

- (void)setToysImage:(UIImage *)toysImage
{

    _toysImage = toysImage;
    self.toys.image = toysImage;
}

- (void)setCoinNumber:(NSInteger)coinNumber
{
    _coinNumber = coinNumber;
    self.coinView.coinNumber = coinNumber;
}

- (void)setShopIconImage:(UIImage *)shopIconImage
{
    UIImage *image = [shopIconImage systhsisWithBorderImage:kGetImage(@"coupon2.png") andSize:CGSizeMake(40, 40) andCornerRadius:3];
    _shopIconImage = image;
    self.shopIcon.image = image;
}

- (void)setCustomDiscountDescribe:(NSString *)customDiscountDescribe
{
    _customDiscountDescribe = customDiscountDescribe;
    self.couponTypeDescribeLable.text = customDiscountDescribe;
}

//设置字体和颜色
- (void)setDiscountFont:(UIFont *)discountFont
{
    _discountFont = discountFont;
    self.coupondDiscountLable.font = discountFont;
}

- (void)setDiscountColor:(UIColor *)discountColor
{
    _discountColor = discountColor;
    self.coupondDiscountLable.textColor = discountColor;
}

- (void)setDiscountDescribeFont:(UIFont *)discountDescribeFont
{
    _discountDescribeFont = discountDescribeFont;
    self.couponTypeDescribeLable.font = discountDescribeFont;
}

- (void)setDiscountDescribeColor:(UIColor *)discountDescribeColor
{
    _discountDescribeColor = discountDescribeColor;
    self.couponTypeDescribeLable.textColor = discountDescribeColor;
}

- (void)setCoinNumberFont:(UIFont *)coinNumberFont
{
    _coinNumberFont = coinNumberFont;
    self.coinView.coinNumerFont = coinNumberFont;
}

- (void)setCoinNumberColor:(UIColor *)coinNumberColor
{
    _coinNumberColor = coinNumberColor;
    self.coinView.coinNumberColor = coinNumberColor;
}

- (void)setShopNameFont:(UIFont *)shopNameFont
{
    _shopNameFont = shopNameFont;
    self.couponShopLable.font = shopNameFont;
}

- (void)setShopNameColor:(UIColor *)shopNameColor
{
    _shopNameColor = shopNameColor;
    self.couponShopLable.textColor = shopNameColor;
}

//自定义图片
- (void)setCoinBagImage:(UIImage *)coinBagImage
{
    _coinBagImage = coinBagImage;
    self.coinBag.image = coinBagImage;
}

- (void)setCouponPaperImage:(UIImage *)couponPaperImage
{
    _couponPaperImage = couponPaperImage;
    self.couponPaper.image = couponPaperImage;
}

- (void)setCouponBackgroundImage:(UIImage *)couponBackgroundImage
{
    _couponBackgroundImage = couponBackgroundImage;
    self.fireworksBackground.image = couponBackgroundImage;
}

- (void)setCoinImage:(UIImage *)coinImage
{
    _coinImage = coinImage;
    self.coinView.coinImage = coinImage;
}

- (void)setToyBackgroudImage:(UIImage *)toyBackgroudImage
{
    _toyBackgroudImage = toyBackgroudImage;
    self.toysBackground.image = toyBackgroudImage;
}

- (void)setToyTitleIamge:(UIImage *)toyTitleIamge
{
    _toyTitleIamge = toyTitleIamge;
    self.toysTitle.image = toyTitleIamge;
}

- (void)setCustomImage:(UIImage *)customImage
{
    _customImage = customImage;
}

- (void)setExp:(NSInteger)exp
{
    _exp = exp;
    self.expLable.text = [NSString stringWithFormat:@"经验%ld",exp];
}






@end

#pragma mark - coinView;
@interface CoinView ()

@property (nonatomic, strong) UIImageView *coinIcon;
@property (nonatomic, strong) UILabel *CoinNumberLable;

@end


@implementation CoinView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.coinIcon = [UIImageView new];
        if (_coinImage)
        {
            self.coinIcon.image = _coinImage;
        }
        else
        {
            self.coinIcon.image = kGetImage(@"box coin1.png");
        }
        
        [self addSubview:self.coinIcon];
        [self.coinIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.equalTo(self);
            make.width.height.equalTo(self.height);
        }];
    
        self.CoinNumberLable = [UILabel new];
        [self addSubview:self.CoinNumberLable];
 
        if (self.coinNumberColor)
        {
            self.CoinNumberLable.textColor = self.coinNumberColor;
        }
        else
        {
            self.CoinNumberLable.textColor = [UIColor colorWithRed:222/255.0 green:208/255.0 blue:30/255.0 alpha:1];
        }
        
        if (_coinNumerFont) {
            self.CoinNumberLable.font = _coinNumerFont;
        }
 

        self.CoinNumberLable.textAlignment = NSTextAlignmentCenter;
        [self.CoinNumberLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coinIcon.right);
            make.top.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)setCoinNumber:(NSInteger)coinNumber
{
    _coinNumber = coinNumber;
    self.CoinNumberLable.text = [NSString stringWithFormat:@"%ld",coinNumber];
}

- (void)setCoinNumberColor:(UIColor *)coinNumberColor
{
    _coinNumberColor = coinNumberColor;
    self.CoinNumberLable.textColor = coinNumberColor;
}


- (void)setCoinNumerFont:(UIFont *)coinNumerFont
{
    _coinNumerFont = coinNumerFont;
    self.CoinNumberLable.font = coinNumerFont;
}

- (void)setCoinImage:(UIImage *)coinImage
{
    _coinImage = coinImage;
    self.coinIcon.image = coinImage;
}




@end
