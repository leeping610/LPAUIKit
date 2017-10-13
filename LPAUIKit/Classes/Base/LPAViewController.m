//
//  LPAViewController.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import "LPAViewController.h"

#import <Aspects/Aspects.h>

@interface LPAViewController ()

@end

@implementation LPAViewController

#pragma mark - Life Cycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - LPAServerAPIManager ParamSource

- (NSDictionary *)paramSourceForServerAPIManager:(LPAServerAPIManager *)serverAPIManager
{
    return @{};
}

#pragma mark - LPAServerAPIManager Delegate

- (void)serverAPIManager:(LPAServerAPIManager *)serverAPIManager didRequestSuccess:(id)responseObject
{
    
}

- (void)serverAPIManager:(LPAServerAPIManager *)serverAPIManager didRequestFailed:(NSError *)error
{
    
}

@end
