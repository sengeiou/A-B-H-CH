//
//  CHLocalizeableMode.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/12.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHLocalizeableMode.h"

@implementation CHLocalizeableMode

+ (instancetype)shareLocalizable{
    static CHLocalizeableMode *localize;
    static dispatch_once_t oneToken;
    _dispatch_once(&oneToken, ^{
        localize = [[self alloc] init];
    });
    return localize;
}

+ (NSString *)CHlocalizedStringDic:(NSString *)translation_key comment:(NSString *)comment{
    //    NSString *s = NSLocalizedString(translation_key, nil);
    //    NSString *s = NSLocalizedStringWithDefaultValue(translation_key, nil, nil, comment, nil);
//      NSString *s = [NSString localizedStringWithFormat:NSLocalizedString(translation_key, nil)];
//    if ([comment isKindOfClass:[NSArray class]]) {
//        for (int i = 0; i < [(NSArray *)comment count]; i ++) {
//
//        }
//    }else{
    NSString *s = [NSString localizedStringWithFormat:NSLocalizedString(translation_key, nil),comment];
//    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
//#if SMA
    if (![preferredLang isEqualToString:@"zh"] /*&& ![preferredLang isEqualToString:@"es"] && ![preferredLang isEqualToString:@"it"] && ![preferredLang isEqualToString:@"ko"] && ![preferredLang isEqualToString:@"ru"] && ![preferredLang isEqualToString:@"id"]&& ![preferredLang isEqualToString:@"fr"]&& ![preferredLang isEqualToString:@"de"]&& ![preferredLang isEqualToString:@"nl"]&& ![preferredLang isEqualToString:@"fi"]&& ![preferredLang isEqualToString:@"sv"]&& ![preferredLang isEqualToString:@"da"]&& ![preferredLang isEqualToString:@"nb"]&& ![preferredLang isEqualToString:@"tr"]&& ![preferredLang isEqualToString:@"uk"]&& ![preferredLang isEqualToString:@"pt"]&& ![preferredLang isEqualToString:@"hu"]&& ![preferredLang isEqualToString:@"ro"]&& ![preferredLang isEqualToString:@"pl"]*/) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];

        s = [NSString localizedStringWithFormat:[languageBundle localizedStringForKey:translation_key value:@"" table:nil],comment ? comment:@""];
    }
//#elif ZENFIT

//#endif
    return s;
}

+ (NSString *)appendBaseUrlWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2){
        NSString *s = NSLocalizedString(format, nil);
    va_list args;
    va_start(args, format);
    s = [[NSString alloc] initWithFormat:s arguments:args];
    va_end(args);
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [[allLanguages objectAtIndex:0] substringToIndex:2];
    //#if SMA
    if ([preferredLang isEqualToString:@"zh"] /*&& ![preferredLang isEqualToString:@"es"] && ![preferredLang isEqualToString:@"it"] && ![preferredLang isEqualToString:@"ko"] && ![preferredLang isEqualToString:@"ru"] && ![preferredLang isEqualToString:@"id"]&& ![preferredLang isEqualToString:@"fr"]&& ![preferredLang isEqualToString:@"de"]&& ![preferredLang isEqualToString:@"nl"]&& ![preferredLang isEqualToString:@"fi"]&& ![preferredLang isEqualToString:@"sv"]&& ![preferredLang isEqualToString:@"da"]&& ![preferredLang isEqualToString:@"nb"]&& ![preferredLang isEqualToString:@"tr"]&& ![preferredLang isEqualToString:@"uk"]&& ![preferredLang isEqualToString:@"pt"]&& ![preferredLang isEqualToString:@"hu"]&& ![preferredLang isEqualToString:@"ro"]&& ![preferredLang isEqualToString:@"pl"]*/) {
        NSString * path = [[NSBundle mainBundle] pathForResource:@"en" ofType:@"lproj"];
        NSBundle * languageBundle = [NSBundle bundleWithPath:path];
        va_list args;
        va_start(args, format);
        s = [[NSString alloc] initWithFormat:[languageBundle localizedStringForKey:format value:@"" table:nil] arguments:args];
        va_end(args);
    }
    return s;
}
@end
