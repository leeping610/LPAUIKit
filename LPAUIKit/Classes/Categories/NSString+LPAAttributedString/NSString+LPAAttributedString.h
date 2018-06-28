//
//  NSString+LPAAttributedString.h
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/11/24.
//

#import <Foundation/Foundation.h>

@interface NSString (LPAAttributedString)

- (NSAttributedString *)lpa_attributeStringWithSubString:(NSString *)subString
                                                   color:(UIColor *)color;

- (NSAttributedString *)lpa_attributeStringWithSubStrings:(NSArray<NSString *> *)subStrings
                                                   colors:(NSArray<UIColor *> *)colors;

- (NSAttributedString *)lpa_attributeStringWithSubString:(NSString *)subString
                                     attributeDictionary:(NSDictionary *)attributeDictionary;

- (NSAttributedString *)lpa_attributeStringWithSubStrings:(NSArray<NSString *> *)subStrings
                                     attributeDictionarys:(NSArray<NSDictionary *>*)attributeDictionarys;

@end
