//
//  LPATableViewCellProtocol.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2018/7/5.
//

#import <Foundation/Foundation.h>

#import "LPATableCellViewModelProtocol.h"

@protocol LPATableViewCellProtocol <NSObject>

@required

- (void)bindViewModel:(id<LPATableCellViewModelProtocol>)viewModel;

@optional

- (void)cellDidLoad;
- (void)cellWillAppear;

@end
