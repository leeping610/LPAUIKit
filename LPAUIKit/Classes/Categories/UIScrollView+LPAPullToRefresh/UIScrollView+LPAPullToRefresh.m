//
//  UIScrollView+LPAPullToRefresh.m
//  LPAUIKit
//
//  Created by 平果太郎 on 26/01/2018.
//

#import "UIScrollView+LPAPullToRefresh.h"

#import <objc/runtime.h>
#import <MJRefresh/MJRefresh.h>

static void* kLPAScrollViewPullToRefreshStyleKey = &kLPAScrollViewPullToRefreshStyleKey;
static void* kLPAScrollViewPullToRefreshDisplayLastUpdatedTimeLabel = &kLPAScrollViewPullToRefreshDisplayLastUpdatedTimeLabel;
static void* kLPAScrollViewPullToRefreshTextFontKey = &kLPAScrollViewPullToRefreshTextFontKey;

@implementation UIScrollView (LPAPullToRefresh)

@dynamic lpa_pullToRefreshStyle;
@dynamic lpa_displayLastUpdatedTimeLabel;
@dynamic lpa_textFont;

#pragma mark - Life Cycle

- (void)layoutSubviews {
    [super layoutSubviews];
}

#pragma mark - Pull To Refresh Methods

- (void)lpa_didHeaderPullToRefresh:(void (^)(UIScrollView *))pullToRefreshBlock {
    __weak typeof(self) weakSelf = self;
    self.mj_header.refreshingBlock = ^{
        if (pullToRefreshBlock) {
            pullToRefreshBlock(weakSelf);
        }
    };
}

- (void)lpa_didFooterPullToRefresh:(void (^)(UIScrollView *))pullToRefreshBlock {
    __weak typeof(self) weakSelf = self;
    self.mj_footer.refreshingBlock = ^{
        if (pullToRefreshBlock) {
            pullToRefreshBlock(weakSelf);
        }
    };
}

- (void)lpa_endPullToRefresh {
    [self.mj_header endRefreshing];
    [self.mj_footer endRefreshing];
}

- (void)lpa_setHeaderTitle:(NSString *)title forState:(LPAScrollPullToRefreshState)state {
    if (self.mj_header) {
        [[self lpa_header] setTitle:title forState:(MJRefreshState)state];
    }
}

- (void)lpa_setFooterTitle:(NSString *)title forState:(LPAScrollPullToRefreshState)state {
    if (self.mj_footer) {
        [[self lpa_footer] setTitle:title forState:(MJRefreshState)state];
    }
}

#pragma mark - Custom Accessors

- (void)setLpa_pullToRefreshStyle:(LPAScrollPullToRefreshStyle)lpa_pullToRefreshStyle {
    objc_setAssociatedObject(self, kLPAScrollViewPullToRefreshStyleKey, @(lpa_pullToRefreshStyle), OBJC_ASSOCIATION_ASSIGN);
    if (lpa_pullToRefreshStyle & LPAScrollPullToRefreshStyleHeader) {
        MJRefreshNormalHeader *normalHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:nil];
        normalHeader.lastUpdatedTimeLabel.hidden = !self.lpa_displayLastUpdatedTimeLabel;
        self.mj_header = normalHeader;
    }else {
        self.mj_header = nil;
    }
    if (lpa_pullToRefreshStyle & LPAScrollPullToRefreshStyleFooter) {
        MJRefreshBackNormalFooter *normalFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:nil];
        self.mj_footer = normalFooter;
    }else {
        self.mj_footer = nil;
    }
}

- (void)setLpa_displayLastUpdatedTimeLabel:(BOOL)lpa_displayLastUpdatedTimeLabel {
    objc_setAssociatedObject(self, kLPAScrollViewPullToRefreshDisplayLastUpdatedTimeLabel, @(lpa_displayLastUpdatedTimeLabel), OBJC_ASSOCIATION_ASSIGN);
    if (self.mj_header) {
        MJRefreshNormalHeader *normalHeader = (MJRefreshNormalHeader *)self.mj_header;
        normalHeader.lastUpdatedTimeLabel.hidden = !lpa_displayLastUpdatedTimeLabel;
    }
}

- (void)setLpa_textFont:(UIFont *)lpa_textFont {
    objc_setAssociatedObject(self, kLPAScrollViewPullToRefreshTextFontKey, lpa_textFont, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (self.mj_header && lpa_textFont) {
        [self lpa_header].stateLabel.font = lpa_textFont;
    }
    if (self.mj_footer && lpa_textFont) {
        [self lpa_footer].stateLabel.font = lpa_textFont;
    }
}

- (LPAScrollPullToRefreshStyle)lpa_pullToRefreshStyle {
    return (LPAScrollPullToRefreshStyle)[objc_getAssociatedObject(self, kLPAScrollViewPullToRefreshStyleKey) integerValue];
}

- (BOOL)lpa_displayLastUpdatedTimeLabel {
    return (BOOL)[objc_getAssociatedObject(self, kLPAScrollViewPullToRefreshDisplayLastUpdatedTimeLabel) integerValue];
}

- (UIFont *)lpa_textFont {
    return (UIFont *)objc_getAssociatedObject(self, kLPAScrollViewPullToRefreshTextFontKey);
}

- (MJRefreshNormalHeader *)lpa_header {
    if (self.mj_header) {
        MJRefreshNormalHeader *normalHeader = (MJRefreshNormalHeader *)self.mj_header;
        return normalHeader;
    }
    return nil;
}

- (MJRefreshBackNormalFooter *)lpa_footer {
    if (self.mj_footer) {
        MJRefreshBackNormalFooter *normalFooter = (MJRefreshBackNormalFooter *)self.mj_footer;
        return normalFooter;
    }
    return nil;
}

@end
