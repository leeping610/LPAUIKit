//
//  UIViewController+LPAToast.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/12.
//

#import "UIView+LPAToastHUD.h"

#import <objc/runtime.h>
#import <MBProgressHUD/MBProgressHUD.h>

static const void *LPAToastHUDAutoHideTimeIntervalKey = &LPAToastHUDAutoHideTimeIntervalKey;
static const void *LPAToastHUDBackgroundStyleKey = &LPAToastHUDBackgroundStyleKey;
static const void *LPAToastHUDAnimationKey = &LPAToastHUDAnimationKey;

static CGFloat const LPAToastHUDDetailLabelFontSize = 13;

@implementation UIView (LPAToastHUD)

#pragma mark - Toast Methods

- (void)lpa_startLoading
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    [progressHUD showAnimated:YES];
}

- (void)lpa_startDisableLoading
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.userInteractionEnabled = YES;
    [progressHUD showAnimated:YES];
}

- (void)lpa_startLoadingWithText:(NSString *)loadingText
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.label.text = loadingText;
    [progressHUD showAnimated:YES];
}

- (void)lpa_startDisableLoadingWithText:(NSString *)loadingText
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeIndeterminate;
    progressHUD.label.text = loadingText;
    progressHUD.userInteractionEnabled = YES;
    [progressHUD showAnimated:YES];
}

- (void)lpa_endLoading
{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:self];
    [progressHUD hideAnimated:YES];
}

- (void)lpa_endLoadingWithSuccess:(NSString *)successText
{
    [self lpa_showText:successText];
}

- (void)lpa_endLoadingWithFailure:(NSString *)failureText
{
    [self lpa_showText:failureText];
}

- (void)lpa_startLoadingWithProgress:(void (^)(LPAToastHUDProgressBlock))progressBlock
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeDeterminate;
    LPAToastHUDProgressBlock block = ^(CGFloat progress){
        progressHUD.progress = progress;
    };
    if (progressBlock) {
        progressBlock(block);
    }
    [progressHUD showAnimated:YES];
}

- (void)lpa_startDisableLoadingWithProgress:(void (^)(LPAToastHUDProgressBlock))progressBlock
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeDeterminate;
    progressHUD.userInteractionEnabled = YES;
    LPAToastHUDProgressBlock block = ^(CGFloat progress){
        progressHUD.progress = progress;
    };
    if (progressBlock) {
        progressBlock(block);
    }
    [progressHUD showAnimated:YES];
}

- (void)lpa_startLoadingWithText:(NSString *)loadingText
                   progressBlock:(void (^)(LPAToastHUDProgressBlock))progressBlock
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeDeterminate;
    progressHUD.label.text = loadingText;
    LPAToastHUDProgressBlock block = ^(CGFloat progress){
        progressHUD.progress = progress;
    };
    if (progressBlock) {
        progressBlock(block);
    }
    [progressHUD showAnimated:YES];
}

- (void)lpa_startDisableLoadingWithText:(NSString *)loadingText
                          progressBlock:(void (^)(LPAToastHUDProgressBlock))progressBlock
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeDeterminate;
    progressHUD.label.text = loadingText;
    progressHUD.userInteractionEnabled = YES;
    LPAToastHUDProgressBlock block = ^(CGFloat progress){
        progressHUD.progress = progress;
    };
    if (progressBlock) {
        progressBlock(block);
    }
    [progressHUD showAnimated:YES];
}

- (void)lpa_showText:(NSString *)text
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.detailsLabel.text = text;
    progressHUD.detailsLabel.font = [UIFont boldSystemFontOfSize:LPAToastHUDDetailLabelFontSize];
    [progressHUD showAnimated:YES];
    [progressHUD hideAnimated:YES
                   afterDelay:[self autoHideTimeInterval]];
}

- (void)lpa_showText:(NSString *)text delayBlock:(void (^)(void))delayBlock
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.detailsLabel.text = text;
    progressHUD.detailsLabel.font = [UIFont boldSystemFontOfSize:LPAToastHUDDetailLabelFontSize];
    progressHUD.completionBlock = ^{
        if (delayBlock) {
            delayBlock();
        }
    };
    [progressHUD showAnimated:YES];
    [progressHUD hideAnimated:YES
                   afterDelay:[self autoHideTimeInterval]];
}

- (void)lpa_showText:(NSString *)text waitForSeconds:(NSTimeInterval)seconds
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.detailsLabel.text = text;
    progressHUD.detailsLabel.font = [UIFont boldSystemFontOfSize:LPAToastHUDDetailLabelFontSize];
    [progressHUD showAnimated:YES];
    [progressHUD hideAnimated:YES
                   afterDelay:seconds];
}

- (void)lpa_showText:(NSString *)text waitForSeconds:(NSTimeInterval)seconds delayBlock:(void (^)(void))delayBlock
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeText;
    progressHUD.detailsLabel.text = text;
    progressHUD.detailsLabel.font = [UIFont boldSystemFontOfSize:LPAToastHUDDetailLabelFontSize];
    progressHUD.completionBlock = ^{
        if (delayBlock) {
            delayBlock();
        }
    };
    [progressHUD showAnimated:YES];
    [progressHUD hideAnimated:YES
                   afterDelay:seconds];
}

#pragma mark - Config Class Methods

+ (void)lpa_setAutoHideTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject([self class], LPAToastHUDAutoHideTimeIntervalKey, @(timeInterval), OBJC_ASSOCIATION_ASSIGN);
}

+ (void)lpa_setToastHUDBackgroundStyle:(LPAToastHUDBackgroundStyle)style
{
    objc_setAssociatedObject([self class], LPAToastHUDBackgroundStyleKey, @(style), OBJC_ASSOCIATION_ASSIGN);
}

+ (void)lpa_setToastHUDAnimation:(LPAToastHUDAnimation)animationType
{
    objc_setAssociatedObject([self class], LPAToastHUDAnimationKey, @(animationType), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Private Methods

- (MBProgressHUD *)defaultProgressHUD
{
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self];
    progressHUD.minShowTime = 2;
    progressHUD.backgroundView.style = (MBProgressHUDBackgroundStyle)[self toastHUDBackgroundStyle];
    progressHUD.animationType = (MBProgressHUDAnimation)[self toastHUDAnimation];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.userInteractionEnabled = NO;
    [self addSubview:progressHUD];
    return progressHUD;
}

- (NSTimeInterval)autoHideTimeInterval
{
    NSTimeInterval timeInterval = [objc_getAssociatedObject([self class], LPAToastHUDAutoHideTimeIntervalKey) floatValue];
    if (!timeInterval) {
        timeInterval = 3;
    }
    return timeInterval;
}

- (LPAToastHUDBackgroundStyle)toastHUDBackgroundStyle
{
    LPAToastHUDBackgroundStyle toastHUDBackgroundStyle = [objc_getAssociatedObject([self class], LPAToastHUDBackgroundStyleKey) integerValue];
    return toastHUDBackgroundStyle;
}

- (LPAToastHUDAnimation)toastHUDAnimation
{
    LPAToastHUDAnimation anmationType = [objc_getAssociatedObject([self class], LPAToastHUDAnimationKey) integerValue];
    return anmationType;
}

@end
