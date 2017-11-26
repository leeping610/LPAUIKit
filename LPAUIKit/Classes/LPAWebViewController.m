//
//  LPAWebViewController.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/11/24.
//

#import "LPAWebViewController.h"

#import <WebKit/WebKit.h>
#import <Masonry/Masonry.h>

@interface LPAWebViewController () <WKUIDelegate, WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;

@property (nonatomic, strong, readwrite) NSURL *requestURL;

@end

@implementation LPAWebViewController

#pragma mark - Life Cycle

- (instancetype)initWithURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        _requestURL = URL;
    }
    return self;
}

- (instancetype)initWithURLString:(NSString *)URLString
{
    self = [super init];
    if (self) {
        _requestURL = [NSURL URLWithString:URLString];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.webView];
    [self.view addSubview:self.progressView];
    [_progressView mas_makeConstraints:^(MASConstraintMaker *maker){
        maker.top.mas_equalTo(self.mas_topLayoutGuide);
        maker.leading.mas_equalTo(self.view);
        maker.trailing.mas_equalTo(self.view);
        maker.height.mas_equalTo(2);
    }];
    // Add progress KVO
    [_webView addObserver:self
               forKeyPath:@"estimatedProgress"
                  options:NSKeyValueObservingOptionNew |
                          NSKeyValueObservingOptionOld
                  context:nil];
    // Start request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:_requestURL];
    [_webView loadRequest:request];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [_webView removeObserver:self forKeyPath:@"estimatedProgress"];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        CGFloat new = [change[@"new"] floatValue];
        CGFloat old = [change[@"old"] floatValue];
        if (_webView.estimatedProgress >= 1) {
            _progressView.hidden = YES;
        }else {
            _progressView.hidden = NO;
        }
        if (new > old) {
            [_progressView setProgress:new animated:YES];
        }else {
            [_progressView setProgress:0 animated:NO];
        }
    }
}

#pragma mark - WKNavigation Delegate

// 在发送请求之前，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler
{
    decisionHandler(WKNavigationActionPolicyAllow);
}

// 在收到服务器响应头，根据reponse相关信息，决定是否跳转
- (void)webView:(WKWebView *)webView decidePolicyForNavigationResponse:(nonnull WKNavigationResponse *)navigationResponse decisionHandler:(nonnull void (^)(WKNavigationResponsePolicy))decisionHandler
{
    decisionHandler(WKNavigationResponsePolicyAllow);
}

// 接受在服务器跳转请求之后（服务器redirect），不一定调用
- (void)webView:(WKWebView *)webView didReceiveServerRedirectForProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 准备加载网页，等同于UIWebViewDelegate: -webView:shouldStartLoadWIthRequest:navigationType
- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    
}

// 开始获取到网页内容
- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载完成，等同于UIWebViewDelegate: -webViewDidFinishLoad:
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    
}

// 页面加载失败，等同于UIWebViewDelegate: -webView:didFailLoadWithError:
- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    
}

// SSL认证
- (void)webView:(WKWebView *)webView didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler
{
    
}

// 页面内容完全加载完成
- (void)webViewWebContentProcessDidTerminate:(WKWebView *)webView
{
    
}

#pragma mark - Custom Accessors

- (WKWebView *)webView
{
    if (!_webView) {
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        _webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:configuration];
        _webView.UIDelegate = self;
        _webView.navigationDelegate = self;
        _webView.allowsBackForwardNavigationGestures = YES;
    }
    return _webView;
}

- (UIProgressView *)progressView
{
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
        _progressView.tintColor = _progressBarTintColor;
        _progressView.trackTintColor = _progressBarTrackTintColor;
    }
    return _progressView;
}

- (void)setProgressBarTintColor:(UIColor *)progressBarTintColor
{
    _progressBarTintColor = progressBarTintColor;
    _progressView.tintColor = _progressBarTintColor;
}

- (void)setProgressBarTrackTintColor:(UIColor *)progressBarTrackTintColor
{
    _progressBarTrackTintColor = _progressBarTrackTintColor;
    _progressView.trackTintColor = _progressBarTrackTintColor;
}

@end
