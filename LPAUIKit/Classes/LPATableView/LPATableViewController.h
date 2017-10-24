//
//  LPATableViewController.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import "LPAViewController.h"
#import "LPATableView.h"

@interface LPATableViewController : LPAViewController <UITableViewDelegate,
                                                       UITableViewDataSource,
                                                       LPATableViewDelegate>

@property (nonatomic, strong, readonly) IBOutlet LPATableView *tableView;
@property (nonatomic, assign) IBInspectable LPATableViewRefreshType refreshType;
@property (nonatomic, strong) NSMutableArray *tableDatas;

- (instancetype)initWithRefreshType:(LPATableViewRefreshType)refreshType;

- (void)reloadTableViewDatas;

- (void)registerCell:(Class)cellClass
     reuseIdentifier:(NSString *)reuseIdentifier;

@end
