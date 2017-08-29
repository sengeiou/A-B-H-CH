//
//  CHGeoCodingMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/29.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHGeoCodingMode : NSObject
@property (copy, nonatomic) NSString *City;
@property (copy, nonatomic) NSString *Country;
@property (copy, nonatomic) NSString *CountryCode;
@property (copy, nonatomic) NSString *FormattedAddress;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *State;
@property (copy, nonatomic) NSString *Street;
@property (copy, nonatomic) NSString *SubLocality;
@property (copy, nonatomic) NSString *SubThoroughfare;
@property (copy, nonatomic) NSString *Thoroughfare;
@end
