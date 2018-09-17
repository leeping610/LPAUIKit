//
//  UINavigationController+LPAStatusBar.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/28.
//

#import "UINavigationController+LPAStatusBar.h"
#import <objc/runtime.h>

@implementation UINavigationController (LPAStatusBar)

#pragma mark - Class Methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [class lpa_swizzleMethod:@selector(prefersStatusBarHidden) withMethod:@selector(lpa_prefersStatusBarHidden)];
        [class lpa_swizzleMethod:@selector(preferredStatusBarStyle) withMethod:@selector(lpa_preferredStatusBarStyle)];
        [class lpa_swizzleMethod:@selector(preferredStatusBarUpdateAnimation) withMethod:@selector(lpa_preferredStatusBarUpdateAnimation)];
    });
}

#pragma mark - StatusBar Methods

- (BOOL)lpa_prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}

- (UIStatusBarStyle)lpa_preferredStatusBarStyle {
    return [self.topViewController preferredStatusBarStyle];
}

- (UIStatusBarAnimation)lpa_preferredStatusBarUpdateAnimation {
    return [self.topViewController preferredStatusBarUpdateAnimation];
}

#pragma mark - Swizzle Methods

+ (BOOL)lpa_swizzleMethod:(SEL)origSel withMethod:(SEL)altSel {
    Method origMethod = class_getInstanceMethod(self, origSel);
    Method altMethod = class_getInstanceMethod(self, altSel);
    if (!origMethod || !altMethod) {
        return NO;
    }
    class_addMethod(self,
                    origSel,
                    class_getMethodImplementation(self, origSel),
                    method_getTypeEncoding(origMethod));
    class_addMethod(self,
                    altSel,
                    class_getMethodImplementation(self, altSel),
                    method_getTypeEncoding(altMethod));
    method_exchangeImplementations(class_getInstanceMethod(self, origSel),
                                   class_getInstanceMethod(self, altSel));
    return YES;
}

+ (BOOL)lpa_swizzleClassMethod:(SEL)origSel withMethod:(SEL)altSel {
    return [object_getClass((id)self) lpa_swizzleMethod:origSel withMethod:altSel];
}

@end
