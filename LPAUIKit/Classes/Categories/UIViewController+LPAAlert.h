//
//  UIViewController+LPAAlert.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/13.
//

#import <UIKit/UIKit.h>

@interface UIViewController (LPAAlert)

- (void)lpa_alertWithTitle:(NSString *)title
                   message:(NSString *)message
                    action:(NSArray<UIAlertAction *> *)alertActions;

- (void)lpa_actionSheetWithTitle:(NSString *)title
                         message:(NSString *)message
                         actions:(NSArray<UIAlertAction *> *)alertActions;

@end
