//
//  LPADemoViewController.m
//  LPAUIKit
//
//  Created by leeping610 on 10/11/2017.
//  Copyright (c) 2017 leeping610. All rights reserved.
//

#import "LPADemoViewController.h"
#import "LPADemoTableViewController.h"
#import "LPADemoCollectionViewController.h"
#import "LPADemoWebViewController.h"

#import <LPAUIKit/LPAUIKit.h>
#import <LPAUIKit/LPATableViewController.h>
#import <LPAUIKit/LPACollectionViewController.h>
#import <LPAUIKit/UIView+LPAToastHUD.h>
#import <LPAUIKit/LPAHUD.h>

@interface LPADemoViewController ()

@end

@implementation LPADemoViewController

#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.lpa_barTintColor = [UIColor whiteColor];
    self.lpa_tintColor = [UIColor blueColor];
    ///
//    [self lpa_addLeftBarButtonItemWithText:@"哈哈哈哈" handlerBlock:^(UIButton *barButton) {
//        NSLog(@"嘻嘻嘻😁");
//    }];
//    [self lpa_addRightBarButtonItemWithText:@"呵呵呵呵" handlerBlock:^(UIButton *barButton) {
//        NSLog(@"嘻嘻嘻😢");
//    }];
//    [self lpa_addLeftBarButtonItemWithImage:[UIImage imageNamed:@"error"] handlerBlock:^(UIButton *barButton) {
//        NSLog(@"error");
//    }];
//    [self lpa_addRightBarButtonItemWithImage:[UIImage imageNamed:@"success"] handlerBlock:^(UIButton *barButton) {
//        NSLog(@"success");
//    }];
    self.lpa_barItemFont = [UIFont systemFontOfSize:12];
    LPABarButtonItemHandlerBlock leftBlock1 = ^(UIButton *barButton) {
        NSLog(@"左1");
    };
    LPABarButtonItemHandlerBlock leftBlock2 = ^(UIButton *barButton) {
        NSLog(@"左2");
    };
    LPABarButtonItemHandlerBlock rightBlock1 = ^(UIButton *barButton) {
        NSLog(@"右1");
    };
    LPABarButtonItemHandlerBlock rightBlock2 = ^(UIButton *barButton) {
        NSLog(@"右2");
    };
    NSMutableArray *leftHandlerBlockList = [[NSMutableArray alloc] init];
    NSMutableArray *rightHandlerBlockList = [[NSMutableArray alloc] init];
    [leftHandlerBlockList addObject:leftBlock1];
    [leftHandlerBlockList addObject:leftBlock2];
    [rightHandlerBlockList addObject:rightBlock1];
    [rightHandlerBlockList addObject:rightBlock2];
    [self lpa_addLeftBarButtonItemWithTextList:@[@"左1", @"左2"] handlerBlockList:leftHandlerBlockList];
    [self lpa_addRightBarButtonItemWithTextList:@[@"右1", @"右2"] handlerBlockList:rightHandlerBlockList];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response

- (IBAction)tableViewButtonHandler:(id)sender {
    LPADemoTableViewController *tableViewController = [[LPADemoTableViewController alloc] init];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (IBAction)collectionViewButtonHandler:(id)sender {
    LPADemoCollectionViewController *collectionViewController = [[LPADemoCollectionViewController alloc] init];
    [self.navigationController pushViewController:collectionViewController animated:YES];
}

- (IBAction)webViewButtonHandler:(id)sender {
    LPADemoWebViewController *webViewController = [[LPADemoWebViewController alloc] init];
    [self.navigationController pushViewController:webViewController animated:YES];
}

@end
