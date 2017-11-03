//
//  LPAHUD.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/31.
//

#import <Foundation/Foundation.h>

#import "UIView+LPAToastHUD.h"

typedef void(^LPAHUDCompleteBlock)();

@interface LPAHUD : NSObject

//+ (void)init;
+ (void)setBackgroundStyle:(LPAToastHUDBackgroundStyle)backgroundStyle;
+ (void)setAnimation:(LPAToastHUDAnimation)animation;

+ (void)show;
+ (void)disableShow;

+ (void)showWithStatus:(NSString *)status;
+ (void)showWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;
+ (void)disableShowWithStatus:(NSString *)status;
+ (void)disableShowWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;

+ (void)showProgress:(CGFloat)progress;
+ (void)disableShowProgress:(CGFloat)progress;

+ (void)showProgress:(CGFloat)progress status:(NSString *)status;
+ (void)disableShowProgress:(CGFloat)progress status:(NSString *)status;

+ (void)showInfoWithStatus:(NSString *)status;
+ (void)showInfoWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;
+ (void)disableShowInfoWithStatus:(NSString *)status;
+ (void)disableShowInfoWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;

+ (void)showSuccessWithStatus:(NSString *)status;
+ (void)showSuccessWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;
+ (void)disableShowSuccessWithStatus:(NSString *)status;
+ (void)disableShowSuccessWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;

+ (void)showErrorWithStatus:(NSString *)status;
+ (void)showErrorWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;
+ (void)disableShowErrorWithStatus:(NSString *)status;
+ (void)disableShowErrorWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;

// shows a image + status, use 28x28 white PNGs
+ (void)showImage:(UIImage *)image status:(NSString *)status;
+ (void)showImage:(UIImage *)image status:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;
+ (void)disableShowImage:(UIImage *)image status:(NSString *)status;
+ (void)disableShowImage:(UIImage *)image status:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block;

+ (void)popActivity; // decrease activity count, if activity count == 0 the HUD is dismissed
+ (void)dismiss;

@end
