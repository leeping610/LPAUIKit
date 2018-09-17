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

//@property (nonatomic, copy) NSString *testProperty;

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

- (UITableViewCellEditingStyle)tableViewCellEditingStyle {
    return UITableViewCellEditingStyleInsert;
}

- (NSString *)titleText {
    return self.title;
}

- (NSString *)detailText {
    return self.descriptionText;
}

- (CGFloat)cellHeight {
    return 100.0f;
}

- (BOOL)canEditRow {
    return YES;
}

- (BOOL)canMoveRow {
    return YES;
}

@end
