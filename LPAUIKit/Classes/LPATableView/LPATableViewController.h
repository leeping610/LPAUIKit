//
//  LPATableViewController.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import <UIKit/UIKit.h>
#import "LPATableView.h"

@interface LPATableViewController : UIViewController <UITableViewDelegate,
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
