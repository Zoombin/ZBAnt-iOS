//
//  ZBLoginViewController.m
//  ZBAnt
//
//  Created by zhangbin on 9/18/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBLoginViewController.h"
#import "ZBHTTPManager.h"
#import "UIImageView+AFNetworking.h"
#import "CRToast.h"

@interface ZBLoginViewController ()

@property (readwrite) UILabel *imageUrlLabel;
@property (readwrite) UIImageView *imageView;
@property (readwrite) UITextField *codeTextField;
@property (readwrite) NSMutableDictionary *options;

@end

@implementation ZBLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = [NSString stringWithFormat:@"%@:%@", _server.name, _server.outerIp];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
	[self.view addGestureRecognizer:tap];
	
	_options = [@{
	  kCRToastTextKey : @"test",
	  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
	  kCRToastBackgroundColorKey : [UIColor redColor],
	  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
	  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
	  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
	  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
	} mutableCopy];
	
	CGRect rect = CGRectMake(40, 80, 80, 40);
	
	UIButton *captchaButton = [UIButton buttonWithType:UIButtonTypeCustom];
	captchaButton.frame = rect;
	captchaButton.showsTouchWhenHighlighted = YES;
	[captchaButton setTitle:@"Captcha" forState:UIControlStateNormal];
	captchaButton.backgroundColor = [UIColor blueColor];
	[captchaButton addTarget:self action:@selector(captcha) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:captchaButton];
	
	
	rect.origin.x = 10;
	rect.origin.y += 60;
	rect.size.width = self.view.bounds.size.width - 10 * 2;
	rect.size.height = 60;
	_imageUrlLabel = [[UILabel alloc] initWithFrame:rect];
	_imageUrlLabel.backgroundColor = [UIColor grayColor];
	_imageUrlLabel.numberOfLines = 0;
	_imageUrlLabel.font = [UIFont systemFontOfSize:11];
	_imageUrlLabel.text = @"null";
	[self.view addSubview:_imageUrlLabel];
	
	
	rect.origin.x = 50;
	rect.origin.y += 80;
	rect.size = CGSizeMake(100, 80);
	_imageView = [[UIImageView alloc] initWithFrame:rect];
	_imageView.backgroundColor = [UIColor lightGrayColor];
	[self.view addSubview:_imageView];
	
	rect.origin.x += 150;
	rect.size = CGSizeMake(100, 40);
	_codeTextField = [[UITextField alloc] initWithFrame:rect];
	_codeTextField.backgroundColor = [UIColor grayColor];
	[self.view addSubview:_codeTextField];
	
	rect.origin.x = 0;
	rect.origin.y += 100;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 40;
	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.showsTouchWhenHighlighted = YES;
	loginButton.frame = rect;
	[loginButton setTitle:@"Login" forState:UIControlStateNormal];
	[loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	loginButton.backgroundColor = [UIColor greenColor];
	[loginButton addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loginButton];
}

- (void)dismiss {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)captcha {
	[[ZBHTTPManager shared] captcha:_server.outerIp withBlock:^(id responseObject, NSError *error) {
		if (!error) {
			NSDictionary *data = responseObject[@"data"];
			_imageUrlLabel.text = data[@"captchaUrl"];
			[_imageView setImageWithURL:data[@"captchaUrl"]];
		}
	}];
}

- (void)login {
	if (_codeTextField.text.length) {
		[[ZBHTTPManager shared] login:_server.outerIp code:_codeTextField.text withBlock:^(id responseObject, NSError *error) {
			BOOL success = NO;
			_options[kCRToastTextKey] = @"登录失败!";
			_options[kCRToastBackgroundColorKey] = [UIColor redColor];
			if (!error) {
				NSDictionary *data = responseObject[@"data"];
				success = [data[@"ones"] boolValue];
				if (success) {
					_options[kCRToastTextKey] = @"登录成功!";
					_options[kCRToastBackgroundColorKey] = [UIColor greenColor];
				}
			}
			
			[CRToastManager showNotificationWithOptions:_options completionBlock:^{
				if (success) {
					[self dismiss];
				}
			}];
		}];
	}
}

@end
