//
//  UIViewController+LPANavigationBar.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/28.
//

#import "UIViewController+LPANavigationBar.h"
#import <objc/runtime.h>

static void *kLPAViewControllerNavigationBarTintColorKey = &kLPAViewControllerNavigationBarTintColorKey;
static void *kLPAViewControllerNavigationBarBarTintColorKey = &kLPAViewControllerNavigationBarBarTintColorKey;
static void *kLPAViewControllerNavigationBarBarHideKey = &kLPAViewControllerNavigationBarBarHideKey;
static void *kLPAViewControllerNavigationBarTitleTextAttributesKey = &kLPAViewControllerNavigationBarTitleTextAttributesKey;

@implementation UIViewController (LPANavigationBar)

@dynamic lpa_tintColor;
@dynamic lpa_barTintColor;
@dynamic lpa_navigationBarHide;
@dynamic lpa_titleTextAttributes;

#pragma mark - Class Methods

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        [class lpa_swizzleMethod:@selector(viewWillAppear:) withMethod:@selector(lpa_viewWillAppear:)];
    });
}

#pragma mark - Life Cycle

- (void)lpa_viewWillAppear:(BOOL)animated {
    [self lpa_viewWillAppear:animated];
    /// Set 
    if (self.lpa_tintColor) {
        self.navigationController.navigationBar.tintColor = self.lpa_tintColor;
    }
    if (self.lpa_barTintColor) {
        self.navigationController.navigationBar.barTintColor = self.lpa_barTintColor;
    }
    if (self.lpa_titleTextAttributes) {
        self.navigationController.navigationBar.titleTextAttributes = self.lpa_titleTextAttributes;
    }
    [self.navigationController setNavigationBarHidden:self.lpa_navigationBarHide animated:YES];
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

#pragma mark - Custom Accessors

- (void)setLpa_tintColor:(UIColor *)lpa_tintColor {
    if (lpa_tintColor) {
        objc_setAssociatedObject(self, kLPAViewControllerNavigationBarTintColorKey, lpa_tintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setLpa_barTintColor:(UIColor *)lpa_barTintColor {
    if (lpa_barTintColor) {
        objc_setAssociatedObject(self, kLPAViewControllerNavigationBarBarTintColorKey, lpa_barTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (void)setLpa_navigationBarHide:(BOOL)lpa_navigationBarHide {
    objc_setAssociatedObject(self, kLPAViewControllerNavigationBarBarHideKey, @(lpa_navigationBarHide), OBJC_ASSOCIATION_ASSIGN);
}

- (void)setLpa_titleTextAttributes:(NSDictionary *)lpa_titleTextAttributes {
    if (lpa_titleTextAttributes) {
        objc_setAssociatedObject(self, kLPAViewControllerNavigationBarTitleTextAttributesKey, lpa_titleTextAttributes, OBJC_ASSOCIATION_COPY);
    }
}

- (UIColor *)lpa_tintColor {
    return objc_getAssociatedObject(self, kLPAViewControllerNavigationBarTintColorKey);
}

- (UIColor *)lpa_barTintColor {
    return objc_getAssociatedObject(self, kLPAViewControllerNavigationBarBarTintColorKey);
}

- (BOOL)lpa_navigationBarHide {
    return [objc_getAssociatedObject(self, kLPAViewControllerNavigationBarBarHideKey) boolValue];
}

- (NSDictionary *)lpa_titleTextAttributes {
    return objc_getAssociatedObject(self, kLPAViewControllerNavigationBarTitleTextAttributesKey);
}

@end
