//
//  CustomBaseNavUIViewController.h
//  Pods
//
//  Created by lijunfeng on 2020/5/28.
//

#import <UIKit/UIKit.h>
#import "CustomBaseNavigationBar.h"

NS_ASSUME_NONNULL_BEGIN

@interface CustomBaseNavUIViewController : UIViewController<CustomBaseNavigationBarDelegate,CustomBaseNavigationBarDataSource>

/// 导航条
@property (strong, nonatomic, readonly) CustomBaseNavigationBar *baseNavigationBar;

/// 导航条高度
@property (nonatomic, assign, readonly) CGFloat baseNavigationBarHeight;

/// 是否隐藏导航条，默认隐藏导航条
@property (nonatomic, assign) BOOL baseNavigationBarHidden;

/// 是否隐藏导航条下的细线（YES:隐藏，NO：不隐藏，默认不隐藏）
@property (nonatomic, assign) BOOL baseNavigationBarBottomLineHidden;

@end

NS_ASSUME_NONNULL_END

/*
 LeftView的设置用法示例：
 
 1. 关闭导航条leftView默认显示的返回按钮，在子类实现代理方法 return nil 即可：
 - (UIView *)customBaseNavigationBarLeftView:(CustomBaseNavigationBar *)navigationBar
 
 2. 设置导航条leftView显示图片的方法：
    2.1 先关闭默认的返回按钮 return nil
    2.2 再实现返回指定图片的代理方法 return UIImage 即可
 - (UIView *)customBaseNavigationBarLeftView:(CustomBaseNavigationBar *)navigationBar
 - (UIImage *)customBaseNavigationBarLeftButtonImage:(UIButton *)rightButton navigationBar:(CustomBaseNavigationBar *)navigationBar
 
 3. 设置导航条leftView显示文字的方法：
    3.1 先关闭默认的返回按钮 return nil
    3.2 再实现返回指定文字的代理方法 return UIImage 即可
 - (UIView *)customBaseNavigationBarLeftView:(CustomBaseNavigationBar *)navigationBar
 - (NSMutableAttributedString *)customBaseNavigationBarLeftButtonTitle:(UIButton *)rightButton navigationBar:(CustomBaseNavigationBar *)navigationBar
 
 4. 设置leftView的边距方法：
 - (UIEdgeInsets)customBaseNavigationBarLeftViewMargin:(CustomBaseNavigationBar *)navigationBar
 
 RightView的设置用法示例：
 1. 设置导航条RightView显示文字的方法：
 - (NSMutableAttributedString *)customBaseNavigationBarRightButtonTitle:(UIButton *)rightButton navigationBar:(CustomBaseNavigationBar *)navigationBar
 
 2. 设置导航条RightView显示图片的方法：
 - (UIImage *)customBaseNavigationBarRightButtonImage:(UIButton *)rightButton navigationBar:(CustomBaseNavigationBar *)navigationBar
 
 3. 设置rightView的边距方法：
 - (UIEdgeInsets)customBaseNavigationBarRightViewMargin:(CustomBaseNavigationBar *)navigationBar
 
 */
