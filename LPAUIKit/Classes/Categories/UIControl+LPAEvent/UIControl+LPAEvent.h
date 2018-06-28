//
//  UIControl+LPAEvent.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/28.
//

#import <UIKit/UIKit.h>

@interface UIControl (LPAEvent)

- (void)lpa_touchDown:(void (^)(void))eventBlock;
- (void)lpa_touchDownRepeat:(void (^)(void))eventBlock;
- (void)lpa_touchDragInside:(void (^)(void))eventBlock;
- (void)lpa_touchDragOutside:(void (^)(void))eventBlock;
- (void)lpa_touchDragEnter:(void (^)(void))eventBlock;
- (void)lpa_touchDragExit:(void (^)(void))eventBlock;
- (void)lpa_touchUpInside:(void (^)(void))eventBlock;
- (void)lpa_touchUpOutside:(void (^)(void))eventBlock;
- (void)lpa_touchCancel:(void (^)(void))eventBlock;
- (void)lpa_valueChanged:(void (^)(void))eventBlock;
- (void)lpa_editingDidBegin:(void (^)(void))eventBlock;
- (void)lpa_editingChanged:(void (^)(void))eventBlock;
- (void)lpa_editingDidEnd:(void (^)(void))eventBlock;
- (void)lpa_editingDidEndOnExit:(void (^)(void))eventBlock;

@end
