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

@protocol LPATableViewDelegate <NSObject>

@optional

// Display customization

- (void)tableView:(LPATableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(LPATableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(LPATableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(LPATableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(LPATableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section;
- (void)tableView:(LPATableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section;

- (UITableViewCellAccessoryType)tableView:(LPATableView *)tableView accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(LPATableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(LPATableView *)tableView didHighlightRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(LPATableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSIndexPath *)tableView:(LPATableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath;
- (nullable NSIndexPath *)tableView:(LPATableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(LPATableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)tableView:(LPATableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath;

- (nullable NSArray<UITableViewRowAction *> *)tableView:(LPATableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void)tableView:(LPATableView *)tableView willBeginEditingRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(LPATableView *)tableView didEndEditingRowAtIndexPath:(nullable NSIndexPath *)indexPath;
- (void)tableView:(LPATableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath;
- (void)tableView:(LPATableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath;

- (BOOL)tableView:(LPATableView *)tableView shouldShowMenuForRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(LPATableView *)tableView canPerformAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;
- (void)tableView:(LPATableView *)tableView performAction:(SEL)action forRowAtIndexPath:(NSIndexPath *)indexPath withSender:(nullable id)sender;
- (BOOL)tableView:(LPATableView *)tableView canFocusRowAtIndexPath:(NSIndexPath *)indexPath;
- (BOOL)tableView:(LPATableView *)tableView shouldUpdateFocusInContext:(UITableViewFocusUpdateContext *)context;
- (void)tableView:(LPATableView *)tableView didUpdateFocusInContext:(UITableViewFocusUpdateContext *)context withAnimationCoordinator:(UIFocusAnimationCoordinator *)coordinator;
- (nullable NSIndexPath *)indexPathForPreferredFocusedViewInTableView:(LPATableView *)tableView;

@end

@interface LPATableView : UITableView

@property (nonatomic, weak) id<LPATableViewDelegate> lpaDelegate;
@property (nonatomic, strong, readonly) LPATableViewModel *tableViewModel;

- (void)bindTableViewModel:(LPATableViewModel *)tableViewModel;

@end

NS_ASSUME_NONNULL_END
