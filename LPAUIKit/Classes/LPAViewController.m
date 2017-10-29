//
//  LPAViewController.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import "LPAViewController.h"

@interface LPAViewController ()

@end

@implementation LPAViewController

#pragma mark - Life Cycle

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    if ([self.parentViewController isKindOfClass:[UINavigationController class]]) {
//        if (self.navigationController.navigationBar.barTintColor != self.navigationBarTintColor) {
//            [self.navigationController.navigationBar setBarTintColor:self.navigationBarTintColor];
//        }
//        if (self.navigationController.navigationBar.tintColor != self.navigationTintColor) {
//            [self.navigationController.navigationBar setTintColor:self.navigationTintColor];
//        }
//        [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:self.navigationTitleColor,
//                                                                          NSFontAttributeName: [UIFont systemFontOfSize:18]}];
//        if (_statusAppearanceType == LPAUIKitStatusAppearanceNormal) {
//            if ([UIApplication sharedApplication].statusBarStyle != self.statusBarStyle) {
//                [[UIApplication sharedApplication] setStatusBarStyle:self.statusBarStyle animated:YES];
//            }
//        }
//    }
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - StatusBar Methods

- (BOOL)prefersStatusBarHidden
{
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

@end
