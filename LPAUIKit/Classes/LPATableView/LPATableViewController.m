//
//  LPATableViewController.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import "LPATableViewController.h"

#import <Masonry/Masonry.h>

@interface LPATableViewController ()

@property (nonatomic, strong, readwrite) LPATableView *tableView;

@property (nonatomic, assign, getter=isFromNib) BOOL fromNib;

@end

@implementation LPATableViewController

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Set from xib
    self.fromNib = YES;
    self.tableDatas = [NSMutableArray array];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _tableDatas = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithRefreshType:(LPATableViewRefreshType)refreshType {
    self = [self init];
    if (self) {
        _refreshType = refreshType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.isFromNib || _tableView == nil) {
        [self.view addSubview:self.tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *maker){
            maker.top.mas_equalTo(self.mas_topLayoutGuide);
            maker.leading.mas_equalTo(self.view);
            maker.trailing.mas_equalTo(self.view);
            maker.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
        }];
        self.fromNib = NO;
    }else {
        _tableView.delegate = self;
        _tableView.dataSource = self;
        if (!_tableView.tableFooterView) {
            _tableView.tableFooterView = [UIView new];
        }
    }
    _tableView.refreshType = _refreshType;
}

- (void)registerCell:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier {
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass)
                                               bundle:nil]
         forCellReuseIdentifier:reuseIdentifier];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response

- (void)reloadTableViewDatas {
    [self.tableView reloadData];
}

#pragma mark - UITableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _tableDatas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellIdentifier];
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Custom Accessors

- (LPATableView *)tableView {
    if (!_tableView) {
        _tableView = [[LPATableView alloc] initWithFrame:self.view.bounds
                                                   style:UITableViewStylePlain
                                             refreshType:_refreshType];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.lpaDelegate = self;
    }
    return _tableView;
}

- (void)setRefreshType:(LPATableViewRefreshType)refreshType {
    _refreshType = refreshType;
    _tableView.refreshType = _refreshType;
}

@end
