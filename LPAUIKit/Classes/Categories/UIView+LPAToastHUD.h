//
//  UIViewController+LPAToast.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/12.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LPAToastHUDBackgroundStyle)
{
    /// Solid color background
    LPAToastHUDBackgroundStyleSolidColor,
    /// UIVisualEffectView or UIToolbar.layer background view
    LPAToastHUDBackgroundStyleBlur
};

typedef NS_ENUM(NSInteger, LPAToastHUDAnimation)
{
    /// Opacity animation
    LPAToastHUDAnimationFade,
    /// Opacity + scale animation (zoom in when appearing zoom out when disappearing)
    LPAToastHUDAnimationZoom,
    /// Opacity + scale animation (zoom out style)
    LPAToastHUDAnimationZoomOut,
    /// Opacity + scale animation (zoom in style)
    LPAToastHUDAnimationZoomIn
};

typedef void(^LPAToastHUDProgressBlock)(CGFloat progress);

@interface UIView (LPAToastHUD)

/**
 start a normal HUD toast
 */
- (void)lpa_startLoading;

/**
 start a disable HUD toast
 */
- (void)lpa_startDisableLoading;

/**
 start a HUD toast with a text

 @param loadingText The loading text
 */
- (void)lpa_startLoadingWithText:(NSString *)loadingText;

/**
 start a disable HUD toast with a text

 @param loadingText The loading text
 */
- (void)lpa_startDisableLoadingWithText:(NSString *)loadingText;

/**
 end the HUD toast in this viewController
 */
- (void)lpa_endLoading;

/**
 end the HUD toast in this viewController then start a 2s success toast tips
 
 @param successText The success text
 */
- (void)lpa_endLoadingWithSuccess:(NSString *)successText;

/**
 end the HUD toast in this viewController then start a 2s failure toast tips

 @param failureText The failure text
 */
- (void)lpa_endLoadingWithFailure:(NSString *)failureText;

/**
 start a HUD toast with progress

 @param progressBlock Progress block
 */
- (void)lpa_startLoadingWithProgress:(void (^)(LPAToastHUDProgressBlock block))progressBlock;

/**
 start a disable HUD toast with progress

 @param progressBlock The progress block
 */
- (void)lpa_startDisableLoadingWithProgress:(void (^)(LPAToastHUDProgressBlock block))progressBlock;

/**
 start a normal HUD toast with text & progress

 @param loadingText The loading text
 @param progressBlock The progress block
 */
- (void)lpa_startLoadingWithText:(NSString *)loadingText progressBlock:(void (^)(LPAToastHUDProgressBlock block))progressBlock;

/**
 start a disable HUD toast with text & progress

 @param loadingText The loading text
 @param progressBlock The progress block
 */
- (void)lpa_startDisableLoadingWithText:(NSString *)loadingText progressBlock:(void (^)(LPAToastHUDProgressBlock block))progressBlock;

/**
 show a just text HUD toast

 @param text The text
 */
- (void)lpa_showText:(NSString *)text;

/**
 show a just text HUD toast with delay block

 @param text The text
 @param delayBlock The delay block
 */
- (void)lpa_showText:(NSString *)text delayBlock:(void (^)(void))delayBlock;

/**
 show a just text HUD toast with text & auto hide time interval

 @param text The text
 @param seconds The auto hide time interval
 */
- (void)lpa_showText:(NSString *)text waitForSeconds:(NSTimeInterval)seconds;

/**
 show a just text HUD toast with text & auto hide time interval & delay block

 @param text The text
 @param seconds The auto hide time interval
 @param delayBlock The delay block
 */
- (void)lpa_showText:(NSString *)text waitForSeconds:(NSTimeInterval)seconds delayBlock:(void (^)(void))delayBlock;

/**
 set the HUD auto hide timeInterval

 @param timeInterval auto hide timeInterval
 */
+ (void)lpa_setAutoHideTimeInterval:(NSTimeInterval)timeInterval;

/**
 set the HUD backgroundStyle

 @param style backgroundStyle enum
 */
+ (void)lpa_setToastHUDBackgroundStyle:(LPAToastHUDBackgroundStyle)style;

/**
 set the HUD animationType

 @param animationType animation enum
 */
+ (void)lpa_setToastHUDAnimation:(LPAToastHUDAnimation)animationType;

@end
