//
//  LPATableCellViewModelProtocol.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/6/29.
//

#import <Foundation/Foundation.h>

@protocol LPATableCellViewModelProtocol <NSObject>

@optional

- (Class)reuseViewClass;
- (NSString *)cellIdentifier;

- (CGFloat)cellHeight;
- (CGFloat)estimatedHeight;

- (NSString *)detailText;
- (NSString *)titleText;
- (UIEdgeInsets)separatorInset;
- (UITableViewCellStyle)tableViewCellStyle;
- (UITableViewCellSelectionStyle)tableViewCellSelectionStyle;
- (UITableViewCellAccessoryType)tableViewCellAccessoryType;

@end
