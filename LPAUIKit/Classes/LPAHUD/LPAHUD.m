//
//  LPAHUD.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/31.
//

#import "LPAHUD.h"

#import <objc/runtime.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "LPAUIKit-Macros.h"

#define LPAHUDKeyWindow [UIApplication sharedApplication].keyWindow

static const void *LPAHUDBackgroundStyleKey = &LPAHUDBackgroundStyleKey;
static const void *LPAHUDAnimationKey = &LPAHUDAnimationKey;

@interface LPAHUD ()

@end

@implementation LPAHUD

#pragma mark - Initial

+ (void)setBackgroundStyle:(LPAToastHUDBackgroundStyle)backgroundStyle {
    [UIView lpa_setToastHUDBackgroundStyle:backgroundStyle];
}

+ (void)setAnimation:(LPAToastHUDAnimation)animation {
    [UIView lpa_setToastHUDAnimation:animation];
}

#pragma mark - Show (Normal)

+ (void)show {
    [LPAHUDKeyWindow lpa_startLoading];
}

+ (void)disableShow {
    [LPAHUDKeyWindow lpa_startDisableLoading];
}

#pragma mark - Show (Status)

+ (void)showWithStatus:(NSString *)status {
    [LPAHUDKeyWindow lpa_showText:status];
}

+ (void)showWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    [LPAHUDKeyWindow lpa_showText:status delayBlock:block];
}

+ (void)disableShowWithStatus:(NSString *)status {
    [LPAHUDKeyWindow lpa_disableShowText:status];;
}

+ (void)disableShowWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    [LPAHUDKeyWindow lpa_disableShowText:status delayBlock:block];
}

#pragma mark - Progress

+ (void)showProgress:(CGFloat)progress {
    [LPAHUDKeyWindow lpa_startLoadingWithProgress:^(LPAToastHUDProgressBlock block){
        block(progress);
    }];
}

+ (void)disableShowProgress:(CGFloat)progress {
    [LPAHUDKeyWindow lpa_startDisableLoadingWithProgress:^(LPAToastHUDProgressBlock block){
        block(progress);
    }];
}

#pragma mark - Progress (Status)

+ (void)showProgress:(CGFloat)progress status:(NSString *)status {
    [LPAHUDKeyWindow lpa_startLoadingWithText:status
                                progressBlock:^(LPAToastHUDProgressBlock block){
                                    block(progress);
                                }];
}

+ (void)disableShowProgress:(CGFloat)progress status:(NSString *)status {
    [LPAHUDKeyWindow lpa_startDisableLoadingWithText:status
                                       progressBlock:^(LPAToastHUDProgressBlock block){
                                           block(progress);
                                       }];
}

#pragma mark - Info

+ (void)showInfoWithStatus:(NSString *)status {
    UIImage *infoImage = LPAUIKitImageResource(@"info");
    [LPAHUDKeyWindow lpa_showImage:infoImage withText:status];
}

+ (void)showInfoWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    UIImage *infoImage = LPAUIKitImageResource(@"info");
    [LPAHUDKeyWindow lpa_showImage:infoImage withText:status delayBlock:block];
}

+ (void)disableShowInfoWithStatus:(NSString *)status {
    UIImage *infoImage = LPAUIKitImageResource(@"info");
    [LPAHUDKeyWindow lpa_disableShowImage:infoImage withText:status];
}

+ (void)disableShowInfoWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    UIImage *infoImage = LPAUIKitImageResource(@"info");
    [LPAHUDKeyWindow lpa_disableShowImage:infoImage withText:status delayBlock:block];
}

#pragma mark - Success

+ (void)showSuccessWithStatus:(NSString *)status {
    UIImage *successImage = LPAUIKitImageResource(@"success");
    [LPAHUDKeyWindow lpa_showImage:successImage withText:status];
}

+ (void)showSuccessWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    UIImage *successImage = LPAUIKitImageResource(@"success");
    [LPAHUDKeyWindow lpa_showImage:successImage withText:status delayBlock:block];
}

+ (void)disableShowSuccessWithStatus:(NSString *)status {
    UIImage *successImage = LPAUIKitImageResource(@"success");
    [LPAHUDKeyWindow lpa_disableShowImage:successImage withText:status];
}

+ (void)disableShowSuccessWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    UIImage *successImage = LPAUIKitImageResource(@"success");
    [LPAHUDKeyWindow lpa_disableShowImage:successImage withText:status delayBlock:block];
}

#pragma mark - Error

+ (void)showErrorWithStatus:(NSString *)status {
    UIImage *errorImage = LPAUIKitImageResource(@"error");
    [LPAHUDKeyWindow lpa_showImage:errorImage withText:status];
}

+ (void)showErrorWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    UIImage *errorImage = LPAUIKitImageResource(@"error");
    [LPAHUDKeyWindow lpa_showImage:errorImage withText:status delayBlock:block];
}

+ (void)disableShowErrorWithStatus:(NSString *)status {
    UIImage *errorImage = LPAUIKitImageResource(@"error");
    [LPAHUDKeyWindow lpa_disableShowImage:errorImage withText:status];
}

+ (void)disableShowErrorWithStatus:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    UIImage *errorImage = LPAUIKitImageResource(@"error");
    [LPAHUDKeyWindow lpa_disableShowImage:errorImage withText:status delayBlock:block];
}

#pragma mark - Image

+ (void)showImage:(UIImage *)image status:(NSString *)status {
    [LPAHUDKeyWindow lpa_showImage:image withText:status];
}

+ (void)showImage:(UIImage *)image status:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    [LPAHUDKeyWindow lpa_showImage:image withText:status delayBlock:block];
}

+ (void)disableShowImage:(UIImage *)image status:(NSString *)status {
    [LPAHUDKeyWindow lpa_disableShowImage:image withText:status];
}

+ (void)disableShowImage:(UIImage *)image status:(NSString *)status delayBlock:(LPAHUDCompleteBlock)block {
    [LPAHUDKeyWindow lpa_disableShowImage:image withText:status delayBlock:block];
}

#pragma mark - pop & dismiss

+ (void)popActivity {
    [LPAHUDKeyWindow lpa_endLoading];
}

+ (void)dismiss {
    [LPAHUDKeyWindow lpa_endLoading];
}

@end
