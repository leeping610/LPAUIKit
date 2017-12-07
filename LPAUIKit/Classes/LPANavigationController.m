//
//  LPANavigationController.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/29.
//

#import "LPANavigationController.h"

@interface LPANavigationController ()

@end

@implementation LPANavigationController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - StatusBar Methods

- (BOOL)prefersStatusBarHidden
{
    return [self.topViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return [self.topViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return [self.topViewController preferredStatusBarUpdateAnimation];
}

#pragma mark - UIInterfaceOrientation

- (BOOL)shouldAutorotate
{
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [self.topViewController supportedInterfaceOrientations];
}

@end
