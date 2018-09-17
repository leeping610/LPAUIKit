//
//  LPADemoWebViewController.m
//  LPAUIKit_Example
//
//  Created by 平果太郎 on 2017/11/26.
//  Copyright © 2017年 leeping610. All rights reserved.
//

#import "LPADemoWebViewController.h"
#import <Masonry/Masonry.h>

@interface LPADemoWebViewController () <WKNavigationDelegate>

@end

@implementation LPADemoWebViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Navigation Bar
    self.lpa_navigationBarHide = NO;
    self.lpa_barTintColor = [UIColor yellowColor];
    self.lpa_tintColor = [UIColor blackColor];
    // WebView
    self.lpa_progressBarTintColor = [UIColor greenColor];
    self.lpa_progressBarTrackTintColor = [UIColor redColor];
    self.lpa_allowsBackForwardNavigationGestures = YES;
    self.lpa_webView.navigationDelegate = self;
    // Start request
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"https://www.baidu.com"]];
    [self.lpa_webView loadRequest:request];
    
    __weak typeof(self) weakSelf = self;
    [self lpa_addRightBarButtonItemWithText:@"close" handlerBlock:^(UIButton *button){
        [weakSelf dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    [self lpa_webView_observeValueForKeyPath:keyPath ofObject:object change:change context:context];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [self lpa_webView_dealloc];
}

@end
