//
//  LPAUIKit-Macros.h
//  Pods
//
//  Created by 平果太郎 on 2018/9/17.
//

#ifndef LPAUIKit_Macros_h
#define LPAUIKit_Macros_h

#define LPAUIKitResourcesPath [[NSBundle mainBundle] pathForResource:@"Frameworks/LPAUIKit.framework/LPAUIKit" ofType:@"bundle"]
#define LPAUIKitResourcesBundle [NSBundle bundleWithPath:LPAUIKitResourcesPath]

#define LPAUIKitImageResource(imageName) LPAUIKitResourcesBundle ? [UIImage imageNamed:imageName inBundle:LPAUIKitResourcesBundle compatibleWithTraitCollection:nil] : [UIImage imageNamed:imageName inBundle:[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LPAUIKit" ofType:@"bundle"]] compatibleWithTraitCollection:nil]
#define LPAUIKitLocalizedResource(key) LPAUIKitResourcesBundle ? [LPAUIKitResourcesBundle localizedStringForKey:key value:key table:nil] : [[NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:@"LPAUIKit" ofType:@"bundle"]] localizedStringForKey:key value:key table:nil]

#endif /* LPAUIKit_Macros_h */
