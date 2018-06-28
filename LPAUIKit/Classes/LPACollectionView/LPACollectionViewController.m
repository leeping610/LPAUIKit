//
//  LPACollectionViewController.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import "LPACollectionViewController.h"

#import <Masonry/Masonry.h>

@interface LPACollectionViewController ()

@property (nonatomic, strong, readwrite) LPACollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewLayout *collectionViewLayout;

@property (nonatomic, assign, getter=isFromNib) BOOL fromNib;

@end

@implementation LPACollectionViewController

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Set from xib
    self.fromNib = YES;
    self.collectionDatas = [NSMutableArray array];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _collectionDatas = [NSMutableArray array];
    }
    return self;
}

- (instancetype)initWithRefreshType:(LPACollectionViewRefreshType)refreshType {
    self = [self init];
    if (self) {
        _refreshType = refreshType;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (!self.isFromNib || _collectionView == nil) {
        [self.view addSubview:self.collectionView];
        self.fromNib = NO;
    }else {
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    _collectionView.refreshType = _refreshType;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response

- (void)reloadCollectionViewDatas {
    [_collectionView reloadData];
}

- (void)registerCell:(Class)cellClass reuseIdentifier:(NSString *)reuseIdentifier {
    [self.collectionView registerNib:[UINib nibWithNibName:NSStringFromClass(cellClass)
                                                    bundle:nil]
          forCellWithReuseIdentifier:reuseIdentifier];
}

#pragma mark - UICollectionView DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _collectionDatas.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"collectionViewCellIdentifier";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                           forIndexPath:indexPath];
    return cell;
}

#pragma mark - UICollectionView Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

#pragma mark - LPACollectionView Delegate

- (void)collectionViewDidHeaderPull:(LPACollectionView *)collectionView {
    
}

- (void)collectionViewDidFooterPull:(LPACollectionView *)collectionView {
    
}

#pragma mark - Custom Accessors

- (LPACollectionView *)collectionView {
    if (!_collectionView) {
        if (_collectionViewLayout) {
            _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                 collectionViewLayout:_collectionViewLayout];
        }else {
            UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
            _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                 collectionViewLayout:flowLayout];
        }
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.lpaDelegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
    }
    return _collectionView;
}

- (void)setRefreshType:(LPACollectionViewRefreshType)refreshType {
    _refreshType = refreshType;
    _collectionView.refreshType = _refreshType;
}

@end
