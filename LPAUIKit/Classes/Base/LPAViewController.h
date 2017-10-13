//
//  LPAViewController.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/10/11.
//

#import <UIKit/UIKit.h>
#import "UIView+LPAToastHUD.h"

#import <LPAServerAPIManager/LPAServerAPIManager.h>

@interface LPAViewController : UIViewController <LPAServerAPIManagerDelegate,
                                                 LPAServerAPIManagerParamSource>


@end
