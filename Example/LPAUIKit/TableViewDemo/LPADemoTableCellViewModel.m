//
//  LPADemoTableCellViewModel.m
//  LPAUIKit_Example
//
//  Created by 平果太郎 on 2018/7/5.
//  Copyright © 2018 leeping610. All rights reserved.
//

#import "LPADemoTableCellViewModel.h"
#import "LPADemoTableViewCell.h"

@interface LPADemoTableCellViewModel ()

@end

@implementation LPADemoTableCellViewModel

- (NSString *)cellIdentifier {
    return @"LPADemoTableViewCellIdentifier";
}

- (Class)reuseViewClass {
    return [LPADemoTableViewCell class];
}

- (UITableViewCellStyle)tableViewCellStyle {
    return UITableViewCellStyleSubtitle;
}

- (NSString *)titleText {
    return @"hahahahaha";
}

- (NSString *)detailText {
    return @"xixixixixi";
}

- (CGFloat)cellHeight {
    return 200.0f;
}

@end
