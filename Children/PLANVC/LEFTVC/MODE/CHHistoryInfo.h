//
//  CHHistoryInfo.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/15.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHHistoryInfo : NSObject
@property (nonatomic, assign) NSInteger LocationId;
@property (nonatomic, copy) NSString *Time;
@property (nonatomic, assign) CGFloat Lat;
@property (nonatomic, assign) CGFloat Lng;
@property (nonatomic, assign) CGFloat Speed;
@property (nonatomic, assign) CGFloat Course;
@property (nonatomic, assign) NSInteger IsStop;
@property (nonatomic, assign) NSInteger StopTime;
@property (nonatomic, copy) NSString *Icon;
@property (nonatomic, assign) NSInteger DataType;
@property (nonatomic, strong) NSString *StopTimeStr;
@property (nonatomic, strong) NSString *EndTime;
@property (nonatomic, assign) NSInteger Battery;

@end
