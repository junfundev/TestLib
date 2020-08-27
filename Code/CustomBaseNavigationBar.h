//
//  CustomBaseNavigationBar.h
//  Pods
//
//  Created by lijunfeng on 2020/5/28.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CustomBaseNavigationBarDelegate;
@protocol CustomBaseNavigationBarDataSource;

@interface CustomBaseNavigationBar : UIView

/// 事件代理
@property (nullable, nonatomic, weak) id <CustomBaseNavigationBarDelegate> delegate;

/// 数据源代理
@property (nullable, nonatomic, weak) id <CustomBaseNavigationBarDataSource> dataSource;

/// 底部的黑线
@property (nullable, strong, nonatomic) UIView *bottomBlackLineView;

/// 标题View
@property (nullable, strong, nonatomic) UIView *titleView;

/// 左侧View（默认返回按钮）
@property (nullable, strong, nonatomic) UIView *leftView;

/// 右侧view
@property (nullable, strong, nonatomic) UIView *rightView;

/// 设置背景图片
@property (nullable, strong, nonatomic) UIImage *backgroundImage;

/// contentView
@property (nullable, strong, nonatomic) UIView *navContentView;

/// 设置标题
@property (nullable, copy, nonatomic) NSString *title;

/// 设置可变标题
@property (nullable, copy, nonatomic) NSMutableAttributedString *attributedTitle;

/// 设置标题颜色
@property (nullable, strong, nonatomic) UIColor *titleColor;

/// 设置标题字体
@property (nullable, strong, nonatomic) UIFont *titleFont;

/// 设置导航条颜色
@property (nullable, strong, nonatomic) UIColor *navBarColor;

/// 设置导航条底部细线颜色
@property (nullable, strong, nonatomic) UIColor *navBarLineColor;


@end

// 主要处理导航条
@protocol  CustomBaseNavigationBarDataSource<NSObject>

@optional

/// 头部可变标题
- (NSMutableAttributedString *)customBaseNavigationBarTitle:(CustomBaseNavigationBar *)navigationBar;

/// 导航条的背景图片
- (UIImage *)customBaseNavigationBarBackgroundImage:(CustomBaseNavigationBar *)navigationBar;

/// 导航条标题的字体大小
- (UIFont *)customBaseNavigationBarTitleFont:(CustomBaseNavigationBar *)navigationBar;

/// 导航条标题的颜色
- (UIColor *)customBaseNavigationBarTitleColor:(CustomBaseNavigationBar *)navigationBar;

/// 导航条的背景色
- (UIColor *)customBaseNavigationBarBackgroundColor:(CustomBaseNavigationBar *)navigationBar;

/// 导航条底部细线颜色
- (UIColor *)customBaseNavigationBarBottomLineViewColor:(CustomBaseNavigationBar *)navigationBar;

/// 是否显示底部黑线
- (BOOL)customBaseNavigationBarIsHideBottomLine:(CustomBaseNavigationBar *)navigationBar;

/// 导航条的左边的view（默认返回按钮，如果不需要则在子类重写改代理方法return nil即可）
- (nullable UIView *)customBaseNavigationBarLeftView:(CustomBaseNavigationBar *)navigationBar;

/// 导航条右边的 view
- (nullable UIView *)customBaseNavigationBarRightView:(CustomBaseNavigationBar *)navigationBar;

/// 导航条中间的 View
- (nullable UIView *)customBaseNavigationBarTitleView:(CustomBaseNavigationBar *)navigationBar;

/// 导航条左边的按钮
- (nullable UIImage *)customBaseNavigationBarLeftButtonImage:(UIButton *)leftButton navigationBar:(CustomBaseNavigationBar *)navigationBar;

/// 导航条右边的按钮
- (UIImage *)customBaseNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(CustomBaseNavigationBar *)navigationBar;

/// 导航条左边按钮的标题
- (NSMutableAttributedString *)customBaseNavigationBarLeftButtonTitle:(UIButton *)rightButton navigationBar:(CustomBaseNavigationBar *)navigationBar;

/// 导航条右边按钮的标题
- (NSMutableAttributedString *)customBaseNavigationBarRightButtonTitle:(UIButton *)rightButton navigationBar:(CustomBaseNavigationBar *)navigationBar;

/// 导航条左边View的边距（当前仅left有效）
- (UIEdgeInsets)customBaseNavigationBarLeftViewMargin:(CustomBaseNavigationBar *)navigationBar;

/// 导航条右边View的边距（当前仅right有效）
- (UIEdgeInsets)customBaseNavigationBarRightViewMargin:(CustomBaseNavigationBar *)navigationBar;

@end


@protocol CustomBaseNavigationBarDelegate <NSObject>

@optional

/*
 备注：子类只需要重写该代理方法即可
 */

/// 左边的按钮的点击
- (void)navigationBar:(CustomBaseNavigationBar *)navigationBar leftButtonEvent:(UIButton *)sender;

/// 右边的按钮的点击
- (void)navigationBar:(CustomBaseNavigationBar *)navigationBar rightButtonEvent:(UIButton *)sender;

/// 中间如果是 label 就会有点击
- (void)navigationBar:(CustomBaseNavigationBar *)navigationBar titleViewEvent:(UIView *)sender;

@end

NS_ASSUME_NONNULL_END
