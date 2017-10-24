//
//  LPACollectionView.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/19.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSInteger, LPACollectionViewRefreshType)
{
    LPACollectionViewRefreshTypeNone = 0,
    LPACollectionViewRefreshTypeHeader = 1 << 1,
    LPACollectionViewRefreshTypeFooter = 1 << 2
};

@class LPACollectionView;

@protocol LPACollectionViewDelegate <NSObject>

@optional

- (void)collectionViewDidHeaderPull:(LPACollectionView *)collectionView;
- (void)collectionViewDidFooterPull:(LPACollectionView *)collectionView;

@end

@interface LPACollectionView : UICollectionView

@property (nonatomic, weak) id<LPACollectionViewDelegate> lpaDelegate;
@property (nonatomic, assign) LPACollectionViewRefreshType refreshType;

- (instancetype)initWithFrame:(CGRect)frame
                  refreshType:(LPACollectionViewRefreshType)refreshType;
- (instancetype)initWithFrame:(CGRect)frame
         collectionViewLayout:(UICollectionViewLayout *)layout
                  refreshType:(LPACollectionViewRefreshType)refreshType;

- (void)beginHeaderRefresh;
- (void)beginFooterRefresh;
- (void)endRefresh;

@end
