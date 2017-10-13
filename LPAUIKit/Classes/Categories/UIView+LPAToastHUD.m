//
//  UIViewController+LPAToast.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/12.
//

#import "UIViewController+LPAToast.h"

#import <objc/runtime.h>
#import <MBProgressHUD/MBProgressHUD.h>

static const void *LPAViewControllerAutoHideTimeIntervalKey = &LPAViewControllerAutoHideTimeIntervalKey;
static const void *LPAViewControllerToastHUDBackgroundStyleKey = &LPAViewControllerToastHUDBackgroundStyleKey;
static const void *LPAViewControllerToastHUDAnimationKey = &LPAViewControllerToastHUDAnimationKey;

@implementation UIView (LPAToastHUD)

#pragma mark - Toast Methods

- (void)lpa_startLoading
{
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
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
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:self.view];
    [progressHUD hideAnimated:YES];
}

- (void)lpa_endLoadingWithSuccess:(NSString *)successText
{
    MBProgressHUD *progressHUD = [MBProgressHUD HUDForView:self.view];
    [progressHUD hideAnimated:YES];
}

- (void)lpa_endLoadingWithFailure:(NSString *)failureText
{
    
}

- (void)lpa_startLoadingWithProgress:(void (^)(LPAToastHUDProgressBlock))progressBlock
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeAnnularDeterminate;
    LPAToastHUDProgressBlock block = ^(CGFloat progress){
        progressHUD.progress = progress;
    };
    if (progressBlock) {
        progressBlock(block);
    }
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
}

- (void)lpa_startDisableLoadingWithText:(NSString *)loadingText
                          progressBlock:(void (^)(LPAToastHUDProgressBlock))progressBlock
{
    
}

- (void)lpa_showText:(NSString *)text
{
    MBProgressHUD *progressHUD = [self defaultProgressHUD];
    progressHUD.mode = MBProgressHUDModeText;
}

- (void)lpa_showText:(NSString *)text delayBlock:(void (^)(void))delayBlock
{
    
}

- (void)lpa_showText:(NSString *)text waitForSeconds:(NSTimeInterval)seconds
{
    
}

- (void)lpa_showText:(NSString *)text waitForSeconds:(NSTimeInterval)seconds delayBlock:(void (^)(void))delayBlock
{
    
}

#pragma mark - Config Class Methods

+ (void)lpa_setAutoHideTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject([self class], LPAViewControllerAutoHideTimeIntervalKey, @(timeInterval), OBJC_ASSOCIATION_ASSIGN);
}

+ (void)lpa_setToastHUDBackgroundStyle:(LPAViewControllerToastHUDBackgroundStyle)style
{
    objc_setAssociatedObject([self class], LPAViewControllerToastHUDBackgroundStyleKey, @(style), OBJC_ASSOCIATION_ASSIGN);
}

+ (void)lpa_setToastHUDAnimation:(LPAViewControllerToastHUDAnimation)animationType
{
    objc_setAssociatedObject([self class], LPAViewControllerToastHUDAnimationKey, @(animationType), OBJC_ASSOCIATION_ASSIGN);
}

#pragma mark - Private Methods

- (MBProgressHUD *)defaultProgressHUD
{
    MBProgressHUD *progressHUD = [[MBProgressHUD alloc] initWithView:self.view];
    progressHUD.minShowTime = 2;
    progressHUD.backgroundView.style = (MBProgressHUDBackgroundStyle)[self toastHUDBackgroundStyle];
    progressHUD.animationType = (MBProgressHUDAnimation)[self toastHUDAnimation];
    progressHUD.removeFromSuperViewOnHide = YES;
    progressHUD.userInteractionEnabled = NO;
    [self.view addSubview:progressHUD];
    return progressHUD;
}

- (NSTimeInterval)autoHideTimeInterval
{
    NSTimeInterval timeInterval = [objc_getAssociatedObject([self class], LPAViewControllerAutoHideTimeIntervalKey) floatValue];
    if (!timeInterval) {
        timeInterval = 3;
    }
    return timeInterval;
}

- (LPAViewControllerToastHUDBackgroundStyle)toastHUDBackgroundStyle
{
    LPAViewControllerToastHUDBackgroundStyle toastHUDBackgroundStyle = [objc_getAssociatedObject([self class], LPAViewControllerToastHUDBackgroundStyleKey) integerValue];
    return toastHUDBackgroundStyle;
}

- (LPAViewControllerToastHUDAnimation)toastHUDAnimation
{
    LPAViewControllerToastHUDAnimation anmationType = [objc_getAssociatedObject([self class], LPAViewControllerToastHUDAnimationKey) integerValue];
    return anmationType;
}

@end
