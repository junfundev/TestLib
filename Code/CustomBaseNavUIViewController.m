//
//  CustomBaseNavUIViewController.m
//  Pods
//
//  Created by lijunfeng on 2020/5/28.
//

#import "CustomBaseNavUIViewController.h"
#import <FDFullscreenPopGesture/UINavigationController+FDFullscreenPopGesture.h>

@interface CustomBaseNavUIViewController ()
{
    @private
    CustomBaseNavigationBar *_navBar;
}
@end

@implementation CustomBaseNavUIViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fd_prefersNavigationBarHidden = YES;
    }
    return self;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.view bringSubviewToFront:self.baseNavigationBar];
}

- (CustomBaseNavigationBar *)baseNavigationBar
{
    if (!_navBar)
    {
        CustomBaseNavigationBar *navigationBar = [[CustomBaseNavigationBar alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight([UIApplication sharedApplication].statusBarFrame) + 44)];
        [self.view addSubview:navigationBar];
        _navBar = navigationBar;
        navigationBar.hidden = YES;
        navigationBar.dataSource = self;
        navigationBar.delegate = self;
    }
    return _navBar;
}

- (CGFloat)baseNavigationBarHeight {
    return CGRectGetMaxY(self.baseNavigationBar.frame);
}

#pragma mark - Setters
- (void)setBaseNavigationBarHidden:(BOOL)baseNavigationBarHidden {
    _baseNavigationBarHidden = baseNavigationBarHidden;
    self.baseNavigationBar.hidden = baseNavigationBarHidden;
}

- (void)setBaseNavigationBarBottomLineHidden:(BOOL)baseNavigationBarBottomLineHidden {
    _baseNavigationBarBottomLineHidden = baseNavigationBarBottomLineHidden;
    self.baseNavigationBar.bottomBlackLineView.hidden = baseNavigationBarBottomLineHidden;
}

- (void)setTitle:(NSString *)title {
    [super setTitle:title];
    if (title == nil) return;
    self.baseNavigationBar.title = title;
}

#pragma mark -
#pragma mark - CustomBaseNavigationBarDataSource
- (UIView *)customBaseNavigationBarLeftView:(CustomBaseNavigationBar *)navigationBar {
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1 && viewcontrollers[viewcontrollers.count-1] == self) {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];
        [button setImage:[UIImage imageNamed:@"navigation_back_black"] forState:UIControlStateNormal];
        button.backgroundColor = [UIColor clearColor];
        return button;
    } else {
        return nil;
    }
}

- (UIColor *)customBaseNavigationBarBackgroundColor:(CustomBaseNavigationBar *)navigationBar {
    return [UIColor whiteColor];
}

- (UIColor *)customBaseNavigationBarTitleColor:(CustomBaseNavigationBar *)navigationBar {
    return [UIColor blackColor];
}

#pragma mark -
#pragma mark - CustomBaseNavigationBarDelegate
- (void)navigationBar:(CustomBaseNavigationBar *)navigationBar leftButtonEvent:(UIButton *)sender {
    NSArray *viewcontrollers = self.navigationController.viewControllers;
    if (viewcontrollers.count > 1 && viewcontrollers[viewcontrollers.count-1] == self) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark -
#pragma mark - Publics
- (UIImage *)getBackImage {
    NSString *bundlePath = [[NSBundle bundleForClass:[self class]].resourcePath stringByAppendingPathComponent:@"CustomNavBarLibResourceBundle.bundle"];
    if (bundlePath == nil) return nil;
    
    NSBundle *resource_bundle = [NSBundle bundleWithPath:bundlePath];
    if (resource_bundle == nil) return nil;
    
    NSString *name = @"navigation_back_black";
    if (ABS([UIScreen mainScreen].scale-3) <= 0.001) { // @3x
        name = [NSString stringWithFormat:@"%@@3x",name];
    } else if (ABS([UIScreen mainScreen].scale-2) <= 0.001){ // @2x
        name = [NSString stringWithFormat:@"%@@2x",name];
    } else {
        name = name;
    }
    NSString *imagePath = [resource_bundle pathForResource:name ofType:@"png"];
    if (imagePath == nil) return nil;
    
    UIImage *image = [UIImage imageWithContentsOfFile:imagePath];
    return image;
}

@end
