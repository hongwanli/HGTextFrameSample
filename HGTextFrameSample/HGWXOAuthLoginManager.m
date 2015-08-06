//
//  HGWXOAuthLoginManager.m
//  HGTextFrameSample
//
//  Created by JoyHong on 15/8/5.
//  Copyright (c) 2015年 北京嗨购电子商务有限公司. All rights reserved.
//

#import "HGWXOAuthLoginManager.h"
#import "WXApi.h"

#define kWXAppID                    (@"wx73bdf02facab9ca2")
#define kWXState                    (@"HG2015")
#define kWXSecretKey                (@"f17f13bbac8893946a267566c24628fb")
#define kWXAccessTokenURL           (@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code")
#define kWXUserInfoURL              (@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@")


@interface HGWXOAuthLoginManager () <WXApiDelegate>
@property (nonatomic, copy) OAuthLoginSuccessedBlock successedBlock;
@property (nonatomic, copy) OAuthLoginFailedBlock failedBlock;
/**
 *  获取access_token的code
 */
@property (nonatomic, strong) NSString * code;
/**
 *  授权用户唯一标识
 */
@property (nonatomic, strong) NSString * openid;
@property (nonatomic, strong) NSString * unionid;
@property (nonatomic, strong) NSString * access_token;
@end

@implementation HGWXOAuthLoginManager

+ (HGWXOAuthLoginManager *)shareInstance {
    static HGWXOAuthLoginManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [WXApi registerApp:kWXAppID];
        instance = [[HGWXOAuthLoginManager alloc] init];
    });
    return instance;
}

- (BOOL)handleOpenURL:(NSURL *)URL {
   return  [WXApi handleOpenURL:URL delegate:self];
}

- (void)sendOAuthLoginRequestWithSuccessed:(OAuthLoginSuccessedBlock)successedBlk failed:(OAuthLoginFailedBlock)failedBlk {
    _successedBlock = successedBlk;
    _failedBlock = failedBlk;
    SendAuthReq * request = [[SendAuthReq alloc] init];
    request.scope = @"snsapi_userinfo";
    request.state = kWXState;
    [WXApi sendReq:request];
}

- (void)getAccess_token {
    NSString *url =[NSString stringWithFormat:kWXAccessTokenURL,kWXAppID,kWXSecretKey,self.code];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                self.access_token = [dic objectForKey:@"access_token"];
                self.openid = [dic objectForKey:@"openid"];
                self.unionid = [dic objectForKey:@"unionid"];
                [self getUserInfo];
            } else {
                if (self.failedBlock) {
                    self.failedBlock(nil);
                }
            }
        });
    });
}

- (void)getUserInfo {
    NSString *url =[NSString stringWithFormat:kWXUserInfoURL,self.access_token,self.openid];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *zoneUrl = [NSURL URLWithString:url];
        NSString *zoneStr = [NSString stringWithContentsOfURL:zoneUrl encoding:NSUTF8StringEncoding error:nil];
        NSData *data = [zoneStr dataUsingEncoding:NSUTF8StringEncoding];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                if (self.successedBlock) {
                    self.successedBlock(dic);
                }
            } else {
                if (self.failedBlock) {
                    self.failedBlock(nil);
                }
            }
        });
        
    });
}

#pragma mark -WXApiDelegate

- (void)onResp:(BaseResp *)resp {
    SendAuthResp * authResp = (SendAuthResp *)resp;
    if (resp.errCode == 0) {
        self.code = authResp.code;
        [self getAccess_token];
    }
}

@end
