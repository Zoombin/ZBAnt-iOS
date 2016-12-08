//
//  ZBServerDetailsViewController.m
//  ZBAnt
//
//  Created by zhangbin on 06/12/2016.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBServerDetailsViewController.h"
#import "ZBHTTPManager.h"
#import "CRToast.h"


@interface ZBServerDetailsViewController ()

@property (readwrite) NSMutableDictionary *options;
@property (readwrite) UIButton *removeButton;
@property (readwrite) UIButton *activeButton;
@property (readwrite) UIButton *masterButton;
@property (readwrite) UITextField *innerIpTextField;
@property (readwrite) UITextField *outerIpTextField;
@property (readwrite) UITextField *nameTextField;
@property (readwrite) BOOL isNew;
@property (readwrite) UIButton *weiboyiSettings;

@end

@implementation ZBServerDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	
	if (_server) {
		self.title = [NSString stringWithFormat:@"%@:%@", _server.name, _server.outerIp];
	} else {
		self.title = @"新增";
		_isNew = YES;
		NSMutableDictionary *attributes = [@{} mutableCopy];
		attributes[@"active"] = @(NO);
		attributes[@"master"] = @(NO);
		attributes[@"innerIp"] = @"";
		attributes[@"outerIp"] = @"";
		attributes[@"name"] = @"";
		_server = [[ZBAntServer alloc] initWithAttribues:attributes];
	}
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
	[self.view addGestureRecognizer:tap];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	
	_options = [@{
				  kCRToastTextKey : @"设置成功",
				  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
				  kCRToastBackgroundColorKey : [UIColor greenColor],
				  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
				  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
				  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
				  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
				  } mutableCopy];
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:scrollView];
	
	CGRect originRect = CGRectMake(10, 30, 60, 40);
	CGRect rect = originRect;
	CGSize labelSize = CGSizeMake(320, 30);
	CGSize buttonSize = CGSizeMake(60, 40);
	CGSize textFieldSize = CGSizeMake(200, 40);
	
	
	rect.size = labelSize;
	rect.size = buttonSize;
	
	if (!_isNew) {
		_removeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_removeButton.frame = rect;
		[_removeButton setTitle:@"删除" forState:UIControlStateNormal];
		_removeButton.backgroundColor = [UIColor redColor];
		[_removeButton addTarget:self action:@selector(removeServer) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_removeButton];
	}
	
	rect.origin.x += 100;
	rect.size = labelSize;
	UILabel *activeLabel = [[UILabel alloc] initWithFrame:rect];
	activeLabel.text = @"active";
	[scrollView addSubview:activeLabel];

	rect.origin.y += 30;
	rect.size = buttonSize;
	_activeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_activeButton.frame = rect;
	[_activeButton setTitle:[ZBAntServer onOrOff:_server.active] forState:UIControlStateNormal];
	[_activeButton setTitleColor:[ZBAntServer colorOnOrOff:_server.active] forState:UIControlStateNormal];
	_activeButton.backgroundColor = [UIColor grayColor];
	[_activeButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:_activeButton];
	
	
	rect.origin.y = activeLabel.frame.origin.y;
	rect.origin.x += 100;
	rect.size = labelSize;
	UILabel *masterLabel = [[UILabel alloc] initWithFrame:rect];
	masterLabel.text = @"master";
	[scrollView addSubview:masterLabel];
	
	rect.origin.y += 30;
	rect.size = buttonSize;
	_masterButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_masterButton.frame = rect;
	[_masterButton setTitle:[ZBAntServer onOrOff:_server.master] forState:UIControlStateNormal];
	[_masterButton setTitleColor:[ZBAntServer colorOnOrOff:_server.master] forState:UIControlStateNormal];
	_masterButton.backgroundColor = [UIColor grayColor];
	[_masterButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:_masterButton];
	
	
	rect.origin.x = originRect.origin.x;
	rect.origin.y += 60;
	rect.size = labelSize;
	UILabel *innerIpLabel = [[UILabel alloc] initWithFrame:rect];
	innerIpLabel.text = @"innerIp";
	[scrollView addSubview:innerIpLabel];
	
	rect.origin.x += 80;
	rect.size = textFieldSize;
	_innerIpTextField = [[UITextField alloc] initWithFrame:rect];
	_innerIpTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	_innerIpTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_innerIpTextField.backgroundColor = [UIColor grayColor];
	_innerIpTextField.text = [NSString stringWithFormat:@"%@", _server.innerIp];
	[scrollView addSubview:_innerIpTextField];
	
	
	rect.origin.x = originRect.origin.x;
	rect.origin.y += 60;
	rect.size = labelSize;
	UILabel *outerIpLabel = [[UILabel alloc] initWithFrame:rect];
	outerIpLabel.text = @"outerIp";
	[scrollView addSubview:outerIpLabel];
	
	rect.origin.x += 80;
	rect.size = textFieldSize;
	_outerIpTextField = [[UITextField alloc] initWithFrame:rect];
	_outerIpTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	_outerIpTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_outerIpTextField.backgroundColor = [UIColor grayColor];
	_outerIpTextField.text = [NSString stringWithFormat:@"%@", _server.outerIp];
	[scrollView addSubview:_outerIpTextField];
	
	
	rect.origin.x = originRect.origin.x;
	rect.origin.y += 60;
	rect.size = labelSize;
	UILabel *nameLabel = [[UILabel alloc] initWithFrame:rect];
	nameLabel.text = @"name";
	[scrollView addSubview:nameLabel];
	
	rect.origin.x += 80;
	rect.size = textFieldSize;
	_nameTextField = [[UITextField alloc] initWithFrame:rect];
	_nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
	_nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
	_nameTextField.backgroundColor = [UIColor grayColor];
	_nameTextField.text = [NSString stringWithFormat:@"%@", _server.name];
	[scrollView addSubview:_nameTextField];
	
	//save button
	rect.origin.x = 0;
	rect.origin.y += 50;
	rect.size.width = self.view.bounds.size.width;
	rect.size.height = 50;
	UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
	saveButton.showsTouchWhenHighlighted = YES;
	saveButton.frame = rect;
	[saveButton setTitle:@"Save" forState:UIControlStateNormal];
	[saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	saveButton.backgroundColor = [UIColor orangeColor];
	[saveButton addTarget:self action:@selector(saveSettings) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:saveButton];
	
	if (!_isNew) {
		rect.origin.x = originRect.origin.x;
		rect.origin.y += 80;
		rect.size = buttonSize;
		_weiboyiSettings = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_weiboyiSettings.frame = rect;
		[_weiboyiSettings addTarget:self action:@selector(createWeiboyiSettings) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_weiboyiSettings];
	}

	[self refresh];
}

- (void)dismiss {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refresh {
	[self hasWeiboyiSettings];
}

- (void)toogleButton:(UIButton *)sender {
	NSNumber *value = NULL;
	if (sender == _activeButton) {
		_server.active = @(![_server.active boolValue]);
		value = _server.active;
	} else if (sender == _masterButton) {
		_server.master = @(![_server.master boolValue]);
		value = _server.master;
	}
	
	if (value) {
		[sender setTitle:[ZBAntServer onOrOff:value] forState:UIControlStateNormal];
		[sender setTitleColor:[ZBAntServer colorOnOrOff:value] forState:UIControlStateNormal];
	}
}

- (void)saveSettings {
	_server.innerIp = _innerIpTextField.text;
	_server.outerIp = _outerIpTextField.text;
	_server.name = _nameTextField.text;
	NSLog(@"name: %@", _server.name);
	if (!_server.name.length) {
		[self displayErrorWithMessage:@"检查输入是否合法"];
		return;
	}

	[[ZBHTTPManager shared] updateServer:[_server baseSettings] upsert:_isNew withBlock:^(id responseObject, NSError *error) {
		if (error || ![responseObject[@"error"] isEqual:@0]) {
			[self displayErrorWithMessage:nil];
		} else {
			[self displaySuccess];
		}
	}];
}

- (void)displayErrorWithMessage:(NSString *)message {
	_options[kCRToastTextKey] = message ?: @"失败";
	_options[kCRToastBackgroundColorKey] = [UIColor redColor];
	[CRToastManager showNotificationWithOptions:_options completionBlock:^{
	}];
}

- (void)displaySuccess {
	_options[kCRToastBackgroundColorKey] = [UIColor greenColor];
	[CRToastManager showNotificationWithOptions:_options completionBlock:^{
	}];
}

- (void)removeServer {
	[[ZBHTTPManager shared] removeServer:_server.name withBlock:^(id responseObject, NSError *error) {
		if (error) {
			[self displayErrorWithMessage:nil];
		} else {
			[self displaySuccess];
		}
	}];
}

- (void)hasWeiboyiSettings {
	[[ZBHTTPManager shared] server:_server.name hasWeiboyiSettingsWithBlock:^(id responseObject, NSError *error) {
		if (error) {
			[self displayErrorWithMessage:@"访问失败"];
			return;
		}
		if (responseObject[@"data"]) {
			NSString *name = responseObject[@"data"][@"name"];
			if (name.length) {
				_weiboyiSettings.backgroundColor = [UIColor greenColor];
				_weiboyiSettings.userInteractionEnabled = NO;
				[_weiboyiSettings setTitle:@"YES" forState:UIControlStateNormal];
			} else {
				_weiboyiSettings.backgroundColor = [UIColor grayColor];
				_weiboyiSettings.userInteractionEnabled = YES;
				[_weiboyiSettings setTitle:@"NO" forState:UIControlStateNormal];
			}
		}
	}];
}

- (void)createWeiboyiSettings {
	[[ZBHTTPManager shared] createWeiboyiBaseSettings:[_server baseSettings] withBlock:^(id responseObject, NSError *error) {
		if (error) {
			[self displayErrorWithMessage:nil];
		} else {
			[self displaySuccess];
		}
	}];
}


@end
