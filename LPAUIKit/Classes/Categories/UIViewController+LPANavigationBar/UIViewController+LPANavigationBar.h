//
//  UIViewController+LPANavigationBar.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/28.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LPANavigationBar)

@property (nonatomic, strong) UIColor *lpa_tintColor;
@property (nonatomic, strong) UIColor *lpa_barTintColor;
@property (nonatomic, assign) BOOL lpa_navigationBarHide;

@property (nonatomic, copy) NSDictionary *lpa_titleTextAttributes;

@end
