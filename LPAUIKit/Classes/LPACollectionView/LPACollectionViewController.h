//
//  LPACollectionViewController.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import "LPAViewController.h"
#import "LPACollectionView.h"

@interface LPACollectionViewController : LPAViewController <UICollectionViewDelegate,
                                                            UICollectionViewDataSource,
                                                            UICollectionViewDelegateFlowLayout,
                                                            LPACollectionViewDelegate>

@property (nonatomic, strong, readonly) IBOutlet LPACollectionView *collectionView;
@property (nonatomic, assign) IBInspectable LPACollectionViewRefreshType refreshType;
@property (nonatomic, strong) NSMutableArray *collectionDatas;

- (instancetype)initWithRefreshType:(LPACollectionViewRefreshType)refreshType;
- (instancetype)initWithLayout:(UICollectionViewLayout *)layout
                   refreshType:(LPACollectionViewRefreshType)refreshType;

- (void)reloadCollectionViewDatas;
// Register xib cell
- (void)registerCell:(Class)cellClass
     reuseIdentifier:(NSString *)reuseIdentifier;

@end
