//
//  LPAButton.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/11/24.
//

#import "LPAButton.h"

@interface UIImage (LPAButton)

+ (UIImage *)lpabutton_imageWithColor:(UIColor *)color;

@end

@interface LPAButton ()

@end

@implementation LPAButton

#pragma mark - Class Methods

+ (instancetype)buttonWithType:(UIButtonType)buttonType
{
    return [super buttonWithType:UIButtonTypeCustom];
}

#pragma mark - Life Cycle

- (void)layoutSubviews
{
    [super layoutSubviews];
    // Set border color.
    switch (self.state) {
        case UIControlStateSelected:
            self.layer.borderColor = _selectedBorderColor.CGColor;
            break;
        case UIControlStateDisabled:
            self.layer.borderColor = _disableBorderColor.CGColor;
            break;
        case UIControlStateHighlighted:
            self.layer.borderColor = _highlightedBorderColor.CGColor;
            break;
        default:
            self.layer.borderColor = _normalBorderColor.CGColor;
            break;
    }
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state
{
    UIImage *colorImage = [UIImage lpabutton_imageWithColor:color];
    [self setBackgroundImage:colorImage forState:state];
}

#pragma mark - Custom Accessors

- (void)setCorderRadius:(CGFloat)corderRadius
{
    _corderRadius = corderRadius;
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = _corderRadius;
}

- (void)setNormalBackgroundColor:(UIColor *)normalBackgroundColor
{
    _normalBackgroundColor = normalBackgroundColor;
    [self setBackgroundColor:_normalBackgroundColor forState:UIControlStateNormal];
}

- (void)setSelectedBackgroundColor:(UIColor *)selectedBackgroundColor
{
    _selectedBackgroundColor = selectedBackgroundColor;
    [self setBackgroundColor:_selectedBackgroundColor forState:UIControlStateSelected];
}

- (void)setHigtlightedBackgroundColor:(UIColor *)higtlightedBackgroundColor
{
    _higtlightedBackgroundColor = higtlightedBackgroundColor;
    [self setBackgroundColor:_higtlightedBackgroundColor forState:UIControlStateHighlighted];
}

- (void)setDisableBackgroundColor:(UIColor *)disableBackgroundColor
{
    _disableBackgroundColor = disableBackgroundColor;
    [self setBackgroundColor:_disableBackgroundColor forState:UIControlStateDisabled];
}

- (void)setBorderWidth:(CGFloat)borderWidth
{
    _borderWidth = borderWidth;
    self.layer.borderWidth = _borderWidth;
}

@end

#pragma mark - UIImage Categories Part

@implementation UIImage (LPAButton)

+ (UIImage *)lpabutton_imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
