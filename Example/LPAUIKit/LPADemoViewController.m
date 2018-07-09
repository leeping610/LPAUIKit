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
    [self lpa_addLeftBarButtonItemWithTextList:@[@"left1", @"左2"] handlerBlockList:leftHandlerBlockList];
    [self lpa_addRightBarButtonItemWithTextList:@[@"右1", @"right2"] handlerBlockList:rightHandlerBlockList];
    /// GCD
//    dispatch_queue_t queue1 = dispatch_queue_create("com.leeping.gcd.queue1", DISPATCH_QUEUE_SERIAL);
//    dispatch_queue_t queue2 = dispatch_queue_create("com.leeping.gcd.queue2", DISPATCH_QUEUE_CONCURRENT);
//    dispatch_async(queue2, ^{
//        dispatch_sync(queue1, ^{
//            for (NSInteger i = 0; i < 5; i++) {
//                [NSThread sleepForTimeInterval:0.5];
//                NSLog(@"1-%@", [NSThread currentThread]);
//            }
//        });
//        dispatch_sync(queue1, ^{
//            for (NSInteger i = 0; i < 5; i++) {
//                [NSThread sleepForTimeInterval:0.5];
//                NSLog(@"2-%@", [NSThread currentThread]);
//            }
//        });
//        dispatch_sync(queue1, ^{
//            for (NSInteger i = 0; i < 5; i++) {
//                [NSThread sleepForTimeInterval:0.5];
//                NSLog(@"3-%@", [NSThread currentThread]);
//            }
//        });
//    });
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
