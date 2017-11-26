//
//  LPAWebViewController.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/11/24.
//

#import <LPAUIKit/LPAUIKit.h>

@interface LPAWebViewController : LPAViewController

@property (nonatomic, strong, readonly) NSURL *requestURL;

@property (nonatomic, strong) UIColor *progressBarTintColor;
@property (nonatomic, strong) UIColor *progressBarTrackTintColor;

- (instancetype)initWithURL:(NSURL *)URL;
- (instancetype)initWithURLString:(NSString *)URLString;

@end
