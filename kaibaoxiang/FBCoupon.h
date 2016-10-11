//
//  FBCoupon.h
//  FBCouponView
//
//  Created by 朱志先 on 16/7/12.
//  Copyright © 2016年 朱志先. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, FBCouponViewType) {
    
    FBCouponViewTypeCoin = 1,
    FBCouponViewTypeDiscountCoupon = 2,
    FBCouponViewTypeCashCoupon  = 3,
    FBCouponViewTypeCustomCoupon = 4,
    FBCouponViewTypeToyCoupon = 5,
    FBCouponViewTypeCustomType = 6,
    FBCouponViewTypeEXP = 7,
};

@interface FBCoupon : UIView
//优惠券样式
@property (nonatomic ,assign) FBCouponViewType couponType;
//金币数量
@property (nonatomic ,assign) NSInteger coinNumber;
//商店名字
@property (nonatomic ,strong) NSString *shopName;
//折扣金额或折扣幅度
@property (nonatomic ,strong) NSString *discount;
//折扣类型的描述，选现金和打折券类型时不用设置
@property (nonatomic ,strong) NSString *customDiscountDescribe;
//商店图片
@property (nonatomic ,strong) UIImage *shopIconImage;
//玩具图片
@property (nonatomic ,strong) UIImage *toysImage;
//金币文本的字体和颜色
@property (nonatomic ,strong) UIFont *coinNumberFont;
@property (nonatomic ,strong) UIColor *coinNumberColor;
//折扣数值的颜色和字体
@property (nonatomic ,strong) UIFont *discountFont;
@property (nonatomic ,strong) UIColor *discountColor;
//商店名字的颜色和字体
@property (nonatomic ,strong) UIFont *shopNameFont;
@property (nonatomic ,strong) UIColor *shopNameColor;
//折扣类型描述的颜色和字体
@property (nonatomic ,strong) UIFont *discountDescribeFont;
@property (nonatomic ,strong) UIColor *discountDescribeColor;

//钱袋的图片
@property (nonatomic, strong) UIImage *coinBagImage;

//金币图片
@property (nonatomic, strong) UIImage *coinImage;

//优惠券纸片
@property (nonatomic, strong) UIImage *couponPaperImage;

//优惠券背景图
@property (nonatomic, strong) UIImage *couponBackgroundImage;

//玩具背景图片
@property (nonatomic, strong) UIImage *toyBackgroudImage;

//玩具标题图片
@property (nonatomic, strong) UIImage *toyTitleIamge;

//自定义类型图片
@property (nonatomic, strong) UIImage *customImage;

//经验值
@property (nonatomic, assign) NSInteger exp;


@end


@interface CoinView: UIView

@property (nonatomic, assign) NSInteger coinNumber;
@property (nonatomic, strong) UIFont *coinNumerFont;
@property (nonatomic, strong) UIColor *coinNumberColor;
@property (nonatomic, strong) UIImage *coinImage;

@end


