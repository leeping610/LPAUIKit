//
//  UIViewController+LPAWebView.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/28.
//

#import "UIViewController+LPAWebView.h"

#import <objc/runtime.h>
#import <Masonry/Masonry.h>

static void *kLPAWebViewControllerWebViewKey = &kLPAWebViewControllerWebViewKey;
static void *kLPAWebViewControllerProgressViewKey = &kLPAWebViewControllerProgressViewKey;
static void *kLPAWebViewControllerProgressBarTintColorKey = &kLPAWebViewControllerProgressBarTintColorKey;
static void *kLPAWebViewControllerProgressBarTrackTintColorKey = &kLPAWebViewControllerProgressBarTrackTintColorKey;
static void *kLPAWebViewControllerAllowsGesturesKey = &kLPAWebViewControllerAllowsGesturesKey;

@implementation UIViewController (LPAWebView)

@dynamic lpa_webView;
@dynamic lpa_progressBarTintColor;
@dynamic lpa_progressBarTrackTintColor;
@dynamic lpa_allowsBackForwardNavigationGestures;

#pragma mark - Life Cycle

- (void)lpa_webView_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat new = [change[@"new"] floatValue];
        CGFloat old = [change[@"old"] floatValue];
        if (self.lpa_webView.estimatedProgress >= 1) {
            [self progressView].hidden = YES;
        }else {
            [self progressView].hidden = NO;
        }
        if (new > old) {
            [[self progressView] setProgress:new animated:YES];
        }else {
            [[self progressView] setProgress:0 animated:NO];
        }
    }
}

- (void)lpa_webView_dealloc {
    WKWebView *webView = objc_getAssociatedObject(self, kLPAWebViewControllerWebViewKey);
    if (webView) {
        [webView removeObserver:self forKeyPath:@"estimatedProgress"];
    }
}

#pragma mark - Custom Accessors

- (WKWebView *)lpa_webView {
    WKWebView *webView = objc_getAssociatedObject(self, kLPAWebViewControllerWebViewKey);
    if (!webView) {
        WKWebViewConfiguration *webViewConfiguration = [[WKWebViewConfiguration alloc] init];
        webView = [[WKWebView alloc] initWithFrame:self.view.bounds
                                     configuration:webViewConfiguration];
        webView.allowsBackForwardNavigationGestures = self.lpa_allowsBackForwardNavigationGestures;
        [self.view addSubview:webView];
        [self.view addSubview:[self progressView]];
        [webView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(self.view);
            maker.leading.mas_equalTo(self.view);
            maker.trailing.mas_equalTo(self.view);
            maker.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        }];
        [[self progressView] mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(self.mas_topLayoutGuide);
            maker.leading.mas_equalTo(webView);
            maker.trailing.mas_equalTo(webView);
            maker.height.mas_equalTo(2);
        }];
        // Add progress KVO
        [webView addObserver:self
                  forKeyPath:@"estimatedProgress"
                    options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                    context:nil];
        objc_setAssociatedObject(self, kLPAWebViewControllerWebViewKey, webView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return webView;
}

- (UIProgressView *)progressView {
    UIProgressView *progressView = objc_getAssociatedObject(self, kLPAWebViewControllerProgressViewKey);
    if (!progressView) {
        progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        progressView.tintColor = self.lpa_progressBarTintColor;
        progressView.trackTintColor = self.lpa_progressBarTrackTintColor;
        objc_setAssociatedObject(self, kLPAWebViewControllerProgressViewKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return progressView;
}

- (void)setLpa_progressBarTintColor:(UIColor *)progressBarTintColor {
    if (progressBarTintColor) {
        objc_setAssociatedObject(self, kLPAWebViewControllerProgressBarTintColorKey, progressBarTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else {
        id object = objc_getAssociatedObject(self, kLPAWebViewControllerProgressBarTintColorKey);
        objc_removeAssociatedObjects(object);
    }
}

- (void)setLpa_progressBarTrackTintColor:(UIColor *)progressBarTrackTintColor {
    if (progressBarTrackTintColor) {
        objc_setAssociatedObject(self, kLPAWebViewControllerProgressBarTrackTintColorKey, progressBarTrackTintColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }else {
        id object = objc_getAssociatedObject(self, kLPAWebViewControllerProgressBarTrackTintColorKey);
        objc_removeAssociatedObjects(object);
    }
}

- (void)setLpa_allowsBackForwardNavigationGestures:(BOOL)lpa_allowsBackForwardNavigationGestures {
    objc_setAssociatedObject(self, kLPAWebViewControllerAllowsGesturesKey, @(lpa_allowsBackForwardNavigationGestures), OBJC_ASSOCIATION_ASSIGN);
}

- (UIColor *)lpa_progressBarTintColor {
    UIColor *progressBarTrackTintColor = objc_getAssociatedObject(self, kLPAWebViewControllerProgressBarTintColorKey);
    return progressBarTrackTintColor;
}

- (UIColor *)lpa_progressBarTrackTintColor {
    UIColor *progressBarTrackTintColor = objc_getAssociatedObject(self, kLPAWebViewControllerProgressBarTrackTintColorKey);
    return progressBarTrackTintColor;
}

- (BOOL)lpa_allowsBackForwardNavigationGestures {
    return [objc_getAssociatedObject(self, kLPAWebViewControllerAllowsGesturesKey) boolValue];
}

@end
