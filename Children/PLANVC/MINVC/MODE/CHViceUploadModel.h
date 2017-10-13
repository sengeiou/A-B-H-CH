//
//  CHViceUploadModel.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/26.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHViceUploadModel : NSObject
@property (nonatomic, copy) NSString *SerialNumber;
@property (nonatomic, assign) NSInteger Long;
@property (nonatomic, copy) NSString *VoiceTime;
@property (nonatomic, copy) NSString *Command;
@property (nonatomic, copy) NSString *IdentityID;
@property (nonatomic, assign) NSInteger UserId;
@property (nonatomic, assign) NSInteger ChatType;
@property (nonatomic, assign) NSInteger FileType;
@property (nonatomic, copy) NSString *Token;
@property (nonatomic, copy) NSString *Language;
@property (nonatomic, copy) NSString *AppId;
@end
