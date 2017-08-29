//
//  CHGeoCodingMode.m
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/29.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import "CHGeoCodingMode.h"

@implementation CHGeoCodingMode
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"FormattedAddress":@"FormattedAddressLines[0]"};
}
@end
