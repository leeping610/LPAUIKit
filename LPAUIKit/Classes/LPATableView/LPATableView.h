//
//  LPATableView.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/19.
//

#import <UIKit/UIKit.h>

#import "LPATableViewModel.h"
#import "LPATableSectionViewModel.h"
#import "LPATableSectionViewModelProtocol.h"
#import "LPATableCellViewModelProtocol.h"
#import "LPATableViewCellProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@class LPATableView;

@protocol LPATableViewDelegate<NSObject>

@end

@interface LPATableView : UITableView

@property (nonatomic, weak) id<LPATableViewDelegate> lpaDelegate;
@property (nonatomic, strong, readonly) LPATableViewModel *tableViewModel;

- (void)bindTableViewModel:(LPATableViewModel *)tableViewModel;

@end

NS_ASSUME_NONNULL_END
