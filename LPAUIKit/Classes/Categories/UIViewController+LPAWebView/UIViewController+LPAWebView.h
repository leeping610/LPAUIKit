//
//  UIViewController+LPAWebView.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/28.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (LPAWebView)

@property (nonatomic, strong, readonly) WKWebView *lpa_webView;

@property (nonatomic, strong) UIColor *lpa_progressBarTintColor;
@property (nonatomic, strong) UIColor *lpa_progressBarTrackTintColor;
@property (nonatomic, assign) BOOL lpa_allowsBackForwardNavigationGestures;

- (void)lpa_webView_observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context;
- (void)lpa_webView_dealloc;

@end

NS_ASSUME_NONNULL_END
