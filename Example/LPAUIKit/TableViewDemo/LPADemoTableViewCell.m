//
//  LPADemoTableViewCell.m
//  LPAUIKit_Example
//
//  Created by 平果太郎 on 2018/7/5.
//  Copyright © 2018 leeping610. All rights reserved.
//

#import "LPADemoTableViewCell.h"
#import "LPADemoTableCellViewModel.h"

#import <LPAUIKit/LPAUIKit.h>

@interface LPADemoTableViewCell () <LPATableViewCellProtocol>

@property (nonatomic, strong) LPADemoTableCellViewModel *viewModel;

@end

@implementation LPADemoTableViewCell

#pragma mark - Life Cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - LPATableViewCell Protocol

- (void)bindViewModel:(id<LPATableCellViewModelProtocol>)viewModel {
    self.viewModel = viewModel;
    self.textLabel.text = _viewModel.title;
    self.detailTextLabel.text = _viewModel.descriptionText;
}

- (void)cellDidLoad {
    NSLog(@"%@", NSStringFromSelector(_cmd));
}

- (void)cellWillAppear {
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"%@", self.viewModel.title);
}

@end
