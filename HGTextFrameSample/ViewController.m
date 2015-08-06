//
//  ViewController.m
//  HGTextFrameSample
//
//  Created by JoyHong on 15/7/31.
//  Copyright (c) 2015年 北京嗨购电子商务有限公司. All rights reserved.
//

#import "ViewController.h"
#import "HGWXOAuthLoginManager.h"
#import "UIView+Additions.h"
#import "UIImageView+WebCache.h"

#define kTitleLabelLeftMargin               (10.f)
#define kTitleLabelTopMargin                (30.f)
#define kTitleLabelFontSize                 (15.f)

#define kTitleLabelLineSpace                (20.f)

#define kWXOAuthLoginButtonTopMargin        (10.f)
#define kWXOAuthLoginButtonHeight           (50.f)

#define kNickNameLabelTopMargin             (30.f)
#define kNickNameLabelFontSize              (15.f)

#define kUserHeaderImageViewTopMargin       (10.f)
#define kUserHeaderImageViewWidth           (60.f)
#define kUserHeaderImageViewHeight          (60.f)

@interface ViewController ()
@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIButton * WXOAuthLoginButton;
@property (nonatomic, strong) UILabel * nickNameLabel;
@property (nonatomic, strong) UIImageView * userHeaderImageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSString * text = @"我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大我就是想看看你到底有多大";
    
    NSMutableDictionary * attributes = [NSMutableDictionary dictionary];
    attributes[NSFontAttributeName] = [UIFont systemFontOfSize:kTitleLabelFontSize];
    
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = kTitleLabelLineSpace;
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    
    NSAttributedString * attributedString = [[NSAttributedString alloc] initWithString:text attributes:attributes];
    CGSize contentSize = [attributedString boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 2*kTitleLabelLeftMargin, LONG_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    NSLog(@"contentSize.with====%@",@(contentSize.width));
    NSLog(@"contentSize.height====%@",@(contentSize.height));
        
    self.titleLabel.attributedText = attributedString;
    [self.titleLabel sizeToFit];
    NSLog(@"titleLabel===%@",_titleLabel);
    
    [self WXOAuthLoginButton];
    
    CGRect frame = _WXOAuthLoginButton.frame;
    frame.origin.y = _titleLabel.frame.origin.y + _titleLabel.frame.size.height + kWXOAuthLoginButtonTopMargin;
    _WXOAuthLoginButton.frame = frame;
    
    [self nickNameLabel].top = _WXOAuthLoginButton.bottom + kNickNameLabelTopMargin;
    [self userHeaderImageView].top = _nickNameLabel.bottom + kUserHeaderImageViewTopMargin;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        CGRect frame = CGRectMake(kTitleLabelLeftMargin, kTitleLabelTopMargin, self.view.frame.size.width - 2*kTitleLabelLeftMargin, 0);
        _titleLabel = [[UILabel alloc] initWithFrame:frame];
        _titleLabel.numberOfLines = 0.f;
        _titleLabel.font = [UIFont systemFontOfSize:kTitleLabelFontSize];
        _titleLabel.layer.borderColor = [UIColor redColor].CGColor;
        _titleLabel.layer.borderWidth = 0.5f;
        [self.view addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UIButton *)WXOAuthLoginButton {
    if (!_WXOAuthLoginButton) {
        CGRect frame = CGRectMake(kTitleLabelLeftMargin, _titleLabel.frame.origin.y, self.view.frame.size.width - 2*kTitleLabelLeftMargin, kWXOAuthLoginButtonHeight);
        _WXOAuthLoginButton = [UIButton buttonWithType:UIButtonTypeSystem];
        _WXOAuthLoginButton.frame = frame;
        [_WXOAuthLoginButton setTitle:@"WXOAuthLogin" forState:UIControlStateNormal];
        [_WXOAuthLoginButton addTarget:self action:@selector(OAuthLoginButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_WXOAuthLoginButton];
    }
    return _WXOAuthLoginButton;
}

- (void)OAuthLoginButtonPressed {
    [[HGWXOAuthLoginManager shareInstance] sendOAuthLoginRequestWithSuccessed:^(NSDictionary *userInfo) {
        NSLog(@"userInfo==%@",userInfo);
        self.nickNameLabel.text = [userInfo objectForKey:@"nickname"];
        NSString * imageURL = [userInfo objectForKey:@"headimgurl"];
        [self.userHeaderImageView sd_setImageWithURL:[NSURL URLWithString:imageURL] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            
        }];
    } failed:^(NSError *error) {
        NSLog(@"获取授权信息失败");
    }];
}

- (UILabel *)nickNameLabel {
    if (!_nickNameLabel) {
        CGRect frame = CGRectMake(0, _WXOAuthLoginButton.bottom + kNickNameLabelTopMargin, self.view.frame.size.width - 2*kTitleLabelLeftMargin, kNickNameLabelFontSize);
        _nickNameLabel = [[UILabel alloc] initWithFrame:frame];
        _nickNameLabel.numberOfLines = 0.f;
        _nickNameLabel.font = [UIFont systemFontOfSize:kNickNameLabelFontSize];
        _nickNameLabel.layer.borderColor = [UIColor redColor].CGColor;
        _nickNameLabel.layer.borderWidth = 0.5f;
        _nickNameLabel.textAlignment = NSTextAlignmentCenter;
        _nickNameLabel.centerX = self.view.centerX;
        [self.view addSubview:_nickNameLabel];
    }
    return _nickNameLabel;
}

- (UIImageView *)userHeaderImageView {
    if (!_userHeaderImageView) {
        CGRect frame = CGRectMake(0, _nickNameLabel.bottom + kUserHeaderImageViewTopMargin, kUserHeaderImageViewWidth, kUserHeaderImageViewHeight);
        _userHeaderImageView = [[UIImageView alloc] initWithFrame:frame];
        _userHeaderImageView.centerX = self.view.centerX;
        [self.view addSubview:_userHeaderImageView];
    }
    return _userHeaderImageView;
}

@end
