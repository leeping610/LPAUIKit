//
//  NSString+LPAAttributedString.m
//  LPAUIKit
//
//  Created by 平果太郎 on 2017/11/24.
//

#import "NSString+LPAAttributedString.h"

@implementation NSString (LPAAttributedString)

- (NSAttributedString *)lpa_attributeStringWithSubString:(NSString *)subString
                                                   color:(UIColor *)color {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange subStringRange = [self rangeOfString:subString];
    [attributedString setAttributes:@{NSForegroundColorAttributeName: color}
                              range:subStringRange];
    return attributedString;
}

- (NSAttributedString *)lpa_attributeStringWithSubStrings:(NSArray<NSString *> *)subStrings
                                                   colors:(NSArray<UIColor *> *)colors {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [subStrings enumerateObjectsUsingBlock:^(NSString *subString, NSUInteger idx, BOOL *stop){
        NSRange subStringRange = [self rangeOfString:subString];
        [attributedString setAttributes:@{NSForegroundColorAttributeName: colors[idx]}
                                  range:subStringRange];
    }];
    return attributedString;
}

- (NSAttributedString *)lpa_attributeStringWithSubString:(NSString *)subString
                                     attributeDictionary:(NSDictionary *)attributeDictionary {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange subStringRange = [self rangeOfString:subString];
    [attributedString setAttributes:attributeDictionary range:subStringRange];
    return attributedString;
}

- (NSAttributedString *)lpa_attributeStringWithSubStrings:(NSArray<NSString *> *)subStrings
                                     attributeDictionarys:(NSArray<NSDictionary *> *)attributeDictionarys {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [subStrings enumerateObjectsUsingBlock:^(NSString *subString, NSUInteger idx, BOOL *stop){
        NSRange subStringRange = [self rangeOfString:subString];
        [attributedString setAttributes:attributeDictionarys[idx] range:subStringRange];
    }];
    return attributedString;
}

@end
