//
//  UIScrollView+LPAPullToRefresh.h
//  LPAUIKit
//
//  Created by 平果太郎 on 26/01/2018.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, LPAScrollPullToRefreshStyle) {
    LPAScrollPullToRefreshStyleNone = 0,
    LPAScrollPullToRefreshStyleHeader = 1 << 1,
    LPAScrollPullToRefreshStyleFooter = 1 << 2
};

/** 刷新控件的状态 */
typedef NS_ENUM(NSUInteger, LPAScrollPullToRefreshState) {
    /** 普通闲置状态 */
    LPAScrollPullToRefreshStateIdle = 1,
    /** 松开就可以进行刷新的状态 */
    LPAScrollPullToRefreshStatePulling,
    /** 正在刷新中的状态 */
    LPAScrollPullToRefreshStateRefreshing,
    /** 即将刷新的状态 */
    LPAScrollPullToRefreshStateWillRefresh,
    /** 所有数据加载完毕，没有更多的数据了 */
    LPAScrollPullToRefreshStateNoMoreData
};

@interface UIScrollView (LPAPullToRefresh)

/// 下拉刷新类型.
@property (nonatomic, assign) LPAScrollPullToRefreshStyle lpa_pullToRefreshStyle;
/// 显示/隐藏最后一次刷新时间.
@property (nonatomic, assign) BOOL lpa_displayLastUpdatedTimeLabel;
/// headerText与footerText的字体.
@property (nonatomic, strong) UIFont *lpa_textFont;

/**
 下拉刷新响应block.

 @param pullToRefreshBlock 下拉刷新block
 */
- (void)lpa_didHeaderPullToRefresh:(void (^)(UIScrollView *))pullToRefreshBlock;

/**
 上拉加载响应block.

 @param pullToRefreshBlock 上拉加载block
 */
- (void)lpa_didFooterPullToRefresh:(void (^)(UIScrollView *))pullToRefreshBlock;

/**
 结束下拉刷新/上拉加载状态.
 */
- (void)lpa_endPullToRefresh;

/**
 设置下拉刷新相应状态显示文字.

 @param title 显示的文字
 @param state 刷新状态
 */
- (void)lpa_setHeaderTitle:(NSString *)title forState:(LPAScrollPullToRefreshState)state;

/**
 设置上拉加载相应状态显示文字.

 @param title 显示的文字
 @param state 刷新状态
 */
- (void)lpa_setFooterTitle:(NSString *)title forState:(LPAScrollPullToRefreshState)state;

@end

NS_ASSUME_NONNULL_END
