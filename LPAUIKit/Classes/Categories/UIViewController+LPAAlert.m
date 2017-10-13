//
//  UIViewController+LPAAlert.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/13.
//

#import "UIViewController+LPAAlert.h"
#import <objc/runtime.h>

static void *LPAControllerAlertSignalKey = "LPAControllerAlertSignalKey";

@implementation UIViewController (LPAAlert)

#pragma mark - Class Methods

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dispatch_semaphore_t signal = dispatch_semaphore_create(1);
        objc_setAssociatedObject(self, LPAControllerAlertSignalKey, signal, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    });
}

#pragma mark - Public Methods

- (void)lpa_alertWithTitle:(NSString *)title
                   message:(NSString *)message
                    action:(NSArray<UIAlertAction *> *)alertActions
{
    UIAlertController *alertController = [[self class] normalAlerControllerWithTitle:title message:message];
    [alertActions enumerateObjectsUsingBlock:^(UIAlertAction *alertAction, NSUInteger idx, BOOL *stop){
        [alertController addAction:alertAction];
    }];
    [[self class] presentAlertController:alertController];
}

- (void)lpa_actionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                         actions:(NSArray<UIAlertAction *> *)alertActions
{
    UIAlertController *actionSheetController = [[self class] normalActionSheetControllerWithTitle:title message:message];
    [alertActions enumerateObjectsUsingBlock:^(UIAlertAction *alertAction, NSUInteger idx, BOOL *stop){
        [actionSheetController addAction:alertAction];
    }];
    [[self class] presentAlertController:actionSheetController];
}

#pragma mark - Private Methods

+ (UIAlertController *)normalAlerControllerWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    return alertController;
}

+ (UIAlertController *)normalActionSheetControllerWithTitle:(NSString *)title message:(NSString *)message
{
    UIAlertController *actionSheetController = [UIAlertController alertControllerWithTitle:title
                                                                                   message:message
                                                                            preferredStyle:UIAlertControllerStyleActionSheet];
    return actionSheetController;
}

+ (void)presentAlertController:(UIAlertController *)alertController
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_semaphore_t signal = objc_getAssociatedObject(self, LPAControllerAlertSignalKey);
        dispatch_time_t overtime = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
        dispatch_semaphore_wait(signal, overtime);
        dispatch_async(dispatch_get_main_queue(), ^{
            UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
            while ([topController presentedViewController] != nil) {
                topController = [topController presentedViewController];
            }
            [topController presentViewController:alertController animated:YES completion:^{
                dispatch_semaphore_signal(signal);
            }];
        });
    });
}

@end
