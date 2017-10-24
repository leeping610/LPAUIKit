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

#import <LPAUIKit/LPAUIKit.h>
#import <LPAUIKit/LPATableViewController.h>
#import <LPAUIKit/LPACollectionViewController.h>
#import <LPAUIKit/UIView+LPAToastHUD.h>

@interface LPADemoViewController ()

@end

@implementation LPADemoViewController

#pragma mark - Life Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Event Response

- (IBAction)tableViewButtonHandler:(id)sender
{
    LPADemoTableViewController *tableViewController = [[LPADemoTableViewController alloc] init];
    [self.navigationController pushViewController:tableViewController animated:YES];
}

- (IBAction)collectionViewButtonHandler:(id)sender
{
    LPADemoCollectionViewController *collectionViewController = [[LPADemoCollectionViewController alloc] init];
    [self.navigationController pushViewController:collectionViewController animated:YES];
}

@end
