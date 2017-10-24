//
//  LPATableView.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/19.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, LPATableViewRefreshType)
{
    LPATableViewRefreshTypeNone = 0,
    LPATableViewRefreshTypeHeader = 1 << 1,
    LPATableViewRefreshTypeFooter = 1 << 2
};

@class LPATableView;

@protocol LPATableViewDelegate<NSObject>

@optional

- (void)tableViewDidHeaderPull:(LPATableView *)tableView;
- (void)tableViewDidFooterPull:(LPATableView *)tableView;

@end

@interface LPATableView : UITableView

@property (nonatomic, weak) id<LPATableViewDelegate> lpaDelegate;
@property (nonatomic, assign) LPATableViewRefreshType refreshType;

- (instancetype)initWithFrame:(CGRect)frame
                  refreshType:(LPATableViewRefreshType)refreshType;
- (instancetype)initWithFrame:(CGRect)frame
                        style:(UITableViewStyle)style
                  refreshType:(LPATableViewRefreshType)refreshType;

- (void)beginHeaderRefresh;
- (void)beginFooterRefresh;
- (void)endRefresh;

@end
