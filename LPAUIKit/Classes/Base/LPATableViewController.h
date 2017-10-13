//
//  LPATableViewController.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import "LPAViewController.h"

typedef NS_OPTIONS(NSInteger, LPATableViewRefreshType)
{
    LPATableViewRefreshTypeNone = 0,
    LPATableViewRefreshTypeHeader = 1 << 1,
    LPATableViewRefreshTypeFooter = 1 << 2
};

@interface LPATableViewController : LPAViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, assign) LPATableViewRefreshType refreshType;

@property (nonatomic, strong) NSMutableArray *tableViewDatas;

- (void)tableViewDidHeaderPull;
- (void)tableViewDidFooterPull;

- (void)beginHeaderPullRefresh;
- (void)reloadTableViewDatas;

- (void)registerCell:(Class)cellClass
     reuseIdentifier:(NSString *)reuseIdentifier;

@end
