//
//  NSDate+CH.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/8/23.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (CH)
- (NSUInteger)getDay;
- (NSUInteger)getMonth;
- (NSUInteger)getYear;
+ (NSDate *)dateWithYear:(NSInteger)year month:(NSUInteger)month day:(NSUInteger)day;
- (NSDate *)timeDifferenceWithNumbers:(NSInteger)numbers;
+ (NSDate *)getNowDateFromatAnDate:(NSDate *)date;
@end
