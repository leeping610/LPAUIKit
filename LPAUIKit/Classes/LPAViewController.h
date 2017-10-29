//
//  LPAViewController.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import <UIKit/UIKit.h>
#import "UIView+LPAToastHUD.h"

typedef NS_ENUM(NSInteger, LPAUIKitStatusAppearanceType)
{
    LPAUIKitStatusAppearanceViewControllerBase,
    LPAUIKitStatusAppearanceNormal
};

@interface LPAViewController : UIViewController

@property (nonatomic, assign) LPAUIKitStatusAppearanceType statusAppearanceType;

@property (nonatomic, strong) UIColor *navigationBarTintColor;
@property (nonatomic, strong) UIColor *navigationTintColor;
@property (nonatomic, strong) UIColor *navigationTitleColor;
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;  //  if statusAppearanceType == LPAUIKitStatusAppearanceNormal

@end
