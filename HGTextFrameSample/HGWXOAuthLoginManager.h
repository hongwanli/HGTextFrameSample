//
//  HGWXOAuthLoginManager.h
//  HGTextFrameSample
//
//  Created by JoyHong on 15/8/5.
//  Copyright (c) 2015年 北京嗨购电子商务有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^OAuthLoginSuccessedBlock)(NSDictionary * userInfo);
typedef void(^OAuthLoginFailedBlock)(NSError * error);


@interface HGWXOAuthLoginManager : NSObject
+ (HGWXOAuthLoginManager *)shareInstance;
- (BOOL)handleOpenURL:(NSURL *)URL;
- (void)sendOAuthLoginRequestWithSuccessed:(OAuthLoginSuccessedBlock)successedBlk failed:(OAuthLoginFailedBlock)failedBlk;
@end
