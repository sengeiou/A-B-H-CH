//
//  CHVideoMode.h
//  Children
//
//  Created by 有限公司 深圳市 on 2017/9/26.
//  Copyright © 2017年 SMA. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CHVideoMode : NSObject
@property (nonatomic, assign) NSInteger FileId;
@property (nonatomic, copy) NSString *SerialNumber;
@property (nonatomic, copy) NSString *FileUrl;
@property (nonatomic, copy) NSString *FileBase;
@property (nonatomic, copy) NSString *Created;
@property (nonatomic, assign) NSInteger SourceType;
@property (nonatomic, assign) NSInteger Long;
@property (nonatomic, assign) NSInteger Type;
@property (nonatomic, copy) NSString *Content;
@property (nonatomic, assign) BOOL IsRead;
@property (nonatomic, copy) NSString *IdentityID;
@property (nonatomic, copy) NSString *Avatar;
@property (nonatomic, copy) NSString *AvatarBase;
@property (nonatomic, assign) NSInteger UserId;
@property (nonatomic, assign) BOOL IsUpload;

@end
