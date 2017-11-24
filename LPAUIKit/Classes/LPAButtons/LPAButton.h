//
//  LPAButton.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/11/24.
//

#import <UIKit/UIKit.h>

@interface LPAButton : UIButton

@property (nonatomic, assign) IBInspectable CGFloat corderRadius;

@property (nonatomic, strong) IBInspectable UIColor *normalBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *higtlightedBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor *disableBackgroundColor;

@property (nonatomic, assign) IBInspectable CGFloat borderWidth;
@property (nonatomic, strong) IBInspectable UIColor *normalBorderColor;
@property (nonatomic, strong) IBInspectable UIColor *selectedBorderColor;
@property (nonatomic, strong) IBInspectable UIColor *highlightedBorderColor;
@property (nonatomic, strong) IBInspectable UIColor *disableBorderColor;

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;

@end
