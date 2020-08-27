//
//  CustomBaseNavigationBar.m
//  Pods
//
//  Created by lijunfeng on 2020/5/28.
//

#import "CustomBaseNavigationBar.h"

@interface CustomBaseNavigationBar ()
@property (strong, nonatomic) UILabel *navTitleLabel;
@end

@implementation CustomBaseNavigationBar

- (void)layoutSubviews {
    [super layoutSubviews];
        
    [self.superview bringSubviewToFront:self];
    CGFloat statusBarH = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame);
    
    self.navContentView.frame = self.bounds;
    self.navTitleLabel.frame = CGRectMake(0, statusBarH, CGRectGetWidth(self.bounds), 44.f);
    self.bottomBlackLineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - 0.5, CGRectGetWidth(self.bounds), 0.5);
        
    UIEdgeInsets leftMargin = [self leftViewEdgeInsets];
    UIEdgeInsets rightMargin = [self rightViewEdgeInsets];
    
    if (_leftView) {
        self.leftView.frame = CGRectMake(leftMargin.left,
                                         statusBarH + ((44 - CGRectGetHeight(self.leftView.bounds))/2.f),
                                         CGRectGetWidth(self.leftView.bounds),
                                         CGRectGetHeight(self.leftView.bounds));
    }
    
    if (_rightView) {
        self.rightView.frame = CGRectMake(CGRectGetWidth(self.bounds) - CGRectGetWidth(self.rightView.bounds) - rightMargin.right,
                                          statusBarH + ((44 - CGRectGetHeight(self.rightView.bounds))/2.f),
                                          CGRectGetWidth(self.rightView.bounds),
                                          CGRectGetHeight(self.rightView.bounds));
    }
    
    if (_titleView) {
        CGFloat titleViewW = CGRectGetWidth(self.titleView.frame);
        CGFloat titleViewH = CGRectGetHeight(self.titleView.frame);
        
        if (titleViewW > 0 && titleViewH > 0) { // 外部设置了宽和高
            CGFloat titleViewX = (CGRectGetWidth(self.bounds) - titleViewW) / 2.f;
            CGFloat titleViewY = statusBarH + (44 - titleViewH) / 2.f;
            self.titleView.frame = CGRectMake(titleViewX, titleViewY, titleViewW, titleViewH);
        } else {
            CGFloat maxW = MAX(CGRectGetMaxX(self.leftView.frame), CGRectGetWidth(self.rightView.bounds) + rightMargin.right);
            self.titleView.frame = CGRectMake(maxW, statusBarH,
                                              CGRectGetWidth(self.bounds) - maxW - maxW,
                                              CGRectGetHeight(self.bounds) - statusBarH);
        }
    }
}

#pragma mark - Setters
- (void)setTitleView:(UIView *)titleView {
    self.navTitleLabel.hidden = YES;
    [_titleView removeFromSuperview];
    _titleView = titleView;
    if (titleView == nil) return;
    
    [self insertSubview:titleView aboveSubview:self.navContentView];
    
    __block BOOL isHaveTapGes = NO;
    [titleView.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[UITapGestureRecognizer class]]) {
            isHaveTapGes = YES;
            *stop = YES;
        }
    }];
    
    if (!isHaveTapGes) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleClick:)];
        [titleView addGestureRecognizer:tap];
    }
    
    [self layoutIfNeeded];
}

- (void)setTitle:(NSString *)title {
    _title = title;
    if (title == nil) return;
    
    /// 字体颜色
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitleColor:)] && [self.dataSource customBaseNavigationBarTitleColor:self]) {
        self.navTitleLabel.textColor = [self.dataSource customBaseNavigationBarTitleColor:self];
    }
    
    /// 字体大小
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitleFont:)] && [self.dataSource customBaseNavigationBarTitleFont:self]) {
        self.navTitleLabel.font = [self.dataSource customBaseNavigationBarTitleFont:self];
    }
    
    self.navTitleLabel.text = title;
}

- (void)setAttributedTitle:(NSMutableAttributedString *)attributedTitle {
    _attributedTitle = attributedTitle;
    if (attributedTitle == nil) return;
    self.navTitleLabel.attributedText = attributedTitle;
}

- (void)setTitleColor:(UIColor *)titleColor {
    _titleColor = titleColor;
    if (titleColor == nil) return;
    self.navTitleLabel.textColor = titleColor;
}

- (void)setTitleFont:(UIFont *)titleFont {
    _titleFont = titleFont;
    if (titleFont == nil) return;
    self.navTitleLabel.font = titleFont;
}

- (void)setNavBarColor:(UIColor *)navBarColor {
    _navBarColor = navBarColor;
    if (navBarColor == nil) return;
    self.backgroundColor = navBarColor;
}

- (void)setNavBarLineColor:(UIColor *)navBarLineColor {
    _navBarLineColor = navBarLineColor;
    if (navBarLineColor == nil) return;
    self.bottomBlackLineView.backgroundColor = navBarLineColor;
}

- (void)setLeftView:(UIView *)leftView {
    [_leftView removeFromSuperview];
    _leftView = leftView;
    
    if (leftView == nil) return;
    [self addSubview:leftView];
    
    if ([leftView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)leftView;
        [btn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self layoutIfNeeded];
}

- (void)setBackgroundImage:(UIImage *)backgroundImage {
    _backgroundImage = backgroundImage;
    if (backgroundImage == nil) return;
    self.layer.contents = (id)backgroundImage.CGImage;
}

- (void)setRightView:(UIView *)rightView {
    [_rightView removeFromSuperview];
    _rightView = rightView;
    
    if (rightView == nil) return;
    [self addSubview:rightView];
    
    if ([rightView isKindOfClass:[UIButton class]]) {
        UIButton *btn = (UIButton *)rightView;
        [btn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    [self layoutIfNeeded];
}

- (void)setDataSource:(id<CustomBaseNavigationBarDataSource>)dataSource {
    _dataSource = dataSource;
    [self setupDataSourceUI];
}

#pragma mark - getter
- (UIView *)navContentView {
    if (!_navContentView) {
        _navContentView = [[UIView alloc] init];
        [self insertSubview:_navContentView atIndex:0];
    }
    return _navContentView;
}

- (UILabel *)navTitleLabel {
    if (!_navTitleLabel) {
        _navTitleLabel = [[UILabel alloc] init];
        _navTitleLabel.numberOfLines = 0;
        _navTitleLabel.textAlignment = NSTextAlignmentCenter;
        _navTitleLabel.backgroundColor = [UIColor clearColor];
        _navTitleLabel.userInteractionEnabled = YES;
        _navTitleLabel.lineBreakMode = NSLineBreakByClipping;
        [self insertSubview:_navTitleLabel aboveSubview:self.navContentView];
    }
    return _navTitleLabel;
}

- (UIView *)bottomBlackLineView {
    if(!_bottomBlackLineView) {
        UIView *bottomBlackLineView = [[UIView alloc] init];
        [self addSubview:bottomBlackLineView];
        _bottomBlackLineView = bottomBlackLineView;
        if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarBottomLineViewColor:)]) {
            bottomBlackLineView.backgroundColor = [self.dataSource customBaseNavigationBarBottomLineViewColor:self];
        } else {
            bottomBlackLineView.backgroundColor = [UIColor colorWithRed:244/255.f green:244/255.f blue:244/255.f alpha:1.0];
        }
    }
    return _bottomBlackLineView;
}

- (UIEdgeInsets)leftViewEdgeInsets {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarLeftViewMargin:)]) {
        return [self.dataSource customBaseNavigationBarLeftViewMargin:self];
    }
    return UIEdgeInsetsZero;
}

- (UIEdgeInsets)rightViewEdgeInsets {
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarRightViewMargin:)]) {
        return [self.dataSource customBaseNavigationBarRightViewMargin:self];
    }
    return UIEdgeInsetsZero;
}

#pragma mark -
#pragma mark - Methods

- (void)setupDataSourceUI {
    
    /* ------- UI ------ */
    
    /** 导航条的背景颜色 */
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarBackgroundColor:)]) {
        self.backgroundColor = [self.dataSource customBaseNavigationBarBackgroundColor:self];
    }
    
    /** 标题View */
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitleView:)]) {
        self.titleView = [self.dataSource customBaseNavigationBarTitleView:self];
    }
    
    /** 标题*/
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitle:)]) {
        self.attributedTitle = [self.dataSource customBaseNavigationBarTitle:self];
    }
    
    /** 标题大小 */
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitleFont:)] && ![self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitle:)]) {
        UIFont *titleFont = [self.dataSource customBaseNavigationBarTitleFont:self];
        
        if (titleFont && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitleView:)]) {
            UIView *v = [self.dataSource customBaseNavigationBarTitleView:self];
            if (titleFont && v && [v isKindOfClass:[UILabel class]]) {
                UILabel *titleNav = (UILabel *)v;
                titleNav.font = titleFont;
            }
        }
        else if (titleFont && self.titleView && [self.titleView isKindOfClass:[UILabel class]]) {
            UILabel *titleNav = (UILabel *)self.titleView;
            titleNav.font = titleFont;
        }
    }
    
    /** 标题颜色 */
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitleColor:)] && ![self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitle:)]) {
        UIColor *color = [self.dataSource customBaseNavigationBarTitleColor:self];
        if (color && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarTitleView:)]) {
            UIView *v = [self.dataSource customBaseNavigationBarTitleView:self];
            if (color && v && [v isKindOfClass:[UILabel class]]) {
                UILabel *titleNav = (UILabel *)v;
                titleNav.textColor = color;
            }
        }
        else if (color && self.titleView && [self.titleView isKindOfClass:[UILabel class]]) {
            UILabel *titleNav = (UILabel *)self.titleView;
            titleNav.textColor = color;
        }
    }
    
    /** leftView */
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarLeftView:)] &&
        [self.dataSource customBaseNavigationBarLeftView:self] &&
        ![self.dataSource respondsToSelector:@selector(customBaseNavigationBarLeftButtonImage:navigationBar:)] &&
        ![self.dataSource respondsToSelector:@selector(customBaseNavigationBarLeftButtonTitle:navigationBar:)]) {
        self.leftView = [self.dataSource customBaseNavigationBarLeftView:self];
    }
    else if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarLeftButtonImage:navigationBar:)]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImage *image = [self.dataSource customBaseNavigationBarLeftButtonImage:btn navigationBar:self];
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        self.leftView = btn;
    }
    else if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarLeftButtonTitle:navigationBar:)]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        NSMutableAttributedString *title = [self.dataSource customBaseNavigationBarLeftButtonTitle:btn navigationBar:self];
        [btn setAttributedTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds), 44) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        [btn setFrame:CGRectMake(0, 0, ceilf(titleSize.width + 2.f), 44)];
        self.leftView = btn;
    }
    
    /** rightView */
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarRightView:)] && [self.dataSource customBaseNavigationBarRightView:self]) {
        self.rightView = [self.dataSource customBaseNavigationBarRightView:self];
    }
    else if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarRightButtonImage:navigationBar:)]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        UIImage *image = [self.dataSource customBaseNavigationBarRightButtonImage:btn navigationBar:self];
        if (image) {
            [btn setImage:image forState:UIControlStateNormal];
        }
        self.rightView = btn;
    }
    else if (self.dataSource && [self.dataSource respondsToSelector:@selector(customBaseNavigationBarRightButtonTitle:navigationBar:)]) {
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 44, 44)];
        NSMutableAttributedString *title = [self.dataSource customBaseNavigationBarRightButtonTitle:btn navigationBar:self];
        [btn setAttributedTitle:title forState:UIControlStateNormal];
        CGSize titleSize = [title boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.bounds), 44) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        [btn setFrame:CGRectMake(0, 0, ceilf(titleSize.width + 2.f), 44)];
        self.rightView = btn;
    }
    
}

#pragma mark -
#pragma mark - event

- (void)leftBtnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBar:leftButtonEvent:)]) {
        [self.delegate navigationBar:self leftButtonEvent:btn];
    }
}

- (void)rightBtnClick:(UIButton *)btn {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBar:rightButtonEvent:)]) {
        [self.delegate navigationBar:self rightButtonEvent:btn];
    }
}

- (void)titleClick:(UITapGestureRecognizer *)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(navigationBar:titleViewEvent:)]) {
        [self.delegate navigationBar:self titleViewEvent:sender.view];
    }
}

@end
