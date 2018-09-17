//
//  LPADemoTableCellViewModel.h
//  LPAUIKit_Example
//
//  Created by 平果太郎 on 2018/7/5.
//  Copyright © 2018 leeping610. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LPAUIKit/LPAUIKit.h>

@interface LPADemoTableCellViewModel : NSObject <LPATableCellViewModelProtocol>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *descriptionText;

@end
