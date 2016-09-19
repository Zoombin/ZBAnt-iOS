//
//  ZBServerSettingsViewController.m
//  ZBAnt
//
//  Created by zhangbin on 9/18/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBServerSettingsViewController.h"
#import "ZBHTTPManager.h"
#import "ZBLoginViewController.h"
#import "CRToast.h"
#import "ZBPingViewController.h"

@interface ZBServerSettingsViewController ()

@property (readwrite) UIButton *masterJobButton;
@property (readwrite) UIButton *inChargeOfReloadTasksButton;
@property (readwrite) UIButton *grabWeixinsJobButton;
@property (readwrite) UIButton *grabArticlesJobButton;
@property (readwrite) UIButton *processWeixinsJobButton;
@property (readwrite) UIButton *processArticlesJobButton;

@property (readwrite) UITextField *masterJobIntervalTextField;
@property (readwrite) UITextField *grabWeixinsJobIntervalTextField;
@property (readwrite) UITextField *grabArticlesJobIntervalTextField;
@property (readwrite) UITextField *processWeixinsJobIntervalTextField;
@property (readwrite) UITextField *processArticlesJobIntervalTextField;

@property (readwrite) NSMutableDictionary *options;

@end

@implementation ZBServerSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor whiteColor];
	self.title = [NSString stringWithFormat:@"%@:%@", _server.name, _server.outerIp];
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.view action:@selector(endEditing:)];
	[self.view addGestureRecognizer:tap];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(ping)];
	
	_options = [@{
				  kCRToastTextKey : @"设置成功",
				  kCRToastTextAlignmentKey : @(NSTextAlignmentCenter),
				  kCRToastBackgroundColorKey : [UIColor greenColor],
				  kCRToastAnimationInTypeKey : @(CRToastAnimationTypeGravity),
				  kCRToastAnimationOutTypeKey : @(CRToastAnimationTypeGravity),
				  kCRToastAnimationInDirectionKey : @(CRToastAnimationDirectionLeft),
				  kCRToastAnimationOutDirectionKey : @(CRToastAnimationDirectionRight)
				  } mutableCopy];
	
	CGRect rect = CGRectMake(10, 70, 60, 40);
	CGSize labelSize = CGSizeMake(320, 30);
	CGSize buttonSize = CGSizeMake(60, 40);
	CGSize textFieldSize = CGSizeMake(80, 40);
	
	rect.size = labelSize;
	UILabel *masterJobLabel = [[UILabel alloc] initWithFrame:rect];
	masterJobLabel.text = @"masterJobOn";
	[self.view addSubview:masterJobLabel];
	
	rect.origin.y += 30;
	rect.size = buttonSize;
	_masterJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_masterJobButton.frame = rect;
	[_masterJobButton setTitle:[ZBAntServer onOrOff:_server.masterJobOn] forState:UIControlStateNormal];
	[_masterJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.masterJobOn] forState:UIControlStateNormal];
	_masterJobButton.backgroundColor = [UIColor grayColor];
	[_masterJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_masterJobButton];
	
	rect.origin.x += 80;
	rect.size = textFieldSize;
	_masterJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
	_masterJobIntervalTextField.backgroundColor = [UIColor grayColor];
	_masterJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.masterJobInterval];
	[self.view addSubview:_masterJobIntervalTextField];
	
	
	rect.origin.x += 100;
	rect.origin.y = 70;
	rect.size = labelSize;
	UILabel *inChargeOfReloadTasksLabel = [[UILabel alloc] initWithFrame:rect];
	inChargeOfReloadTasksLabel.text = @"inChargeOfReloadTasks";
	[self.view addSubview:inChargeOfReloadTasksLabel];
	
	rect.origin.y += 30;
	rect.size = buttonSize;
	_inChargeOfReloadTasksButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_inChargeOfReloadTasksButton.frame = rect;
	[_inChargeOfReloadTasksButton setTitle:[ZBAntServer onOrOff:_server.inChargeOfReloadTasks] forState:UIControlStateNormal];
	[_inChargeOfReloadTasksButton setTitleColor:[ZBAntServer colorOnOrOff:_server.inChargeOfReloadTasks] forState:UIControlStateNormal];
	_inChargeOfReloadTasksButton.backgroundColor = [UIColor grayColor];
	[_inChargeOfReloadTasksButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_inChargeOfReloadTasksButton];
	
	
	
	rect.origin.x = 10;
	rect.origin.y += 50;
	rect.size = labelSize;
	UILabel *grabWeixinsJobLabel = [[UILabel alloc] initWithFrame:rect];
	grabWeixinsJobLabel.text = @"grabWeixinsJobOn";
	[self.view addSubview:grabWeixinsJobLabel];
	
	rect.origin.y += 30;
	rect.size = buttonSize;
	_grabWeixinsJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_grabWeixinsJobButton.frame = rect;
	[_grabWeixinsJobButton setTitle:[ZBAntServer onOrOff:_server.grabWeixinsJobOn] forState:UIControlStateNormal];
	[_grabWeixinsJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.grabWeixinsJobOn] forState:UIControlStateNormal];
	_grabWeixinsJobButton.backgroundColor = [UIColor grayColor];
	[_grabWeixinsJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_grabWeixinsJobButton];
	
	rect.origin.x += 80;
	rect.size = textFieldSize;
	_grabWeixinsJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
	_grabWeixinsJobIntervalTextField.backgroundColor = [UIColor grayColor];
	_grabWeixinsJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.grabWeixinsJobInterval];
	[self.view addSubview:_grabWeixinsJobIntervalTextField];
	
	
	
	rect.origin.x = 10;
	rect.origin.y += 50;
	rect.size = labelSize;
	UILabel *grabArticlesJobLabel = [[UILabel alloc] initWithFrame:rect];
	grabArticlesJobLabel.text = @"grabArticlesJobOn";
	[self.view addSubview:grabArticlesJobLabel];
	
	rect.origin.y += 30;
	rect.size = buttonSize;
	_grabArticlesJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_grabArticlesJobButton.frame = rect;
	[_grabArticlesJobButton setTitle:[ZBAntServer onOrOff:_server.grabArticlesJobOn] forState:UIControlStateNormal];
	[_grabArticlesJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.grabArticlesJobOn] forState:UIControlStateNormal];
	_grabArticlesJobButton.backgroundColor = [UIColor grayColor];
	[_grabArticlesJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_grabArticlesJobButton];
	
	rect.origin.x += 80;
	rect.size = textFieldSize;
	_grabArticlesJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
	_grabArticlesJobIntervalTextField.backgroundColor = [UIColor grayColor];
	_grabArticlesJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.grabArticlesJobInterval];
	[self.view addSubview:_grabArticlesJobIntervalTextField];
	
	
	
	rect.origin.x = 10;
	rect.origin.y += 50;
	rect.size = labelSize;
	UILabel *processWeixinsJobLabel = [[UILabel alloc] initWithFrame:rect];
	processWeixinsJobLabel.text = @"processWeixinsJobOn";
	[self.view addSubview:processWeixinsJobLabel];
	
	rect.origin.y += 30;
	rect.size = buttonSize;
	_processWeixinsJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_processWeixinsJobButton.frame = rect;
	[_processWeixinsJobButton setTitle:[ZBAntServer onOrOff:_server.processWeixinsJobOn] forState:UIControlStateNormal];
	[_processWeixinsJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.processWeixinsJobOn] forState:UIControlStateNormal];
	_processWeixinsJobButton.backgroundColor = [UIColor grayColor];
	[_processWeixinsJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_processWeixinsJobButton];
	
	rect.origin.x += 80;
	rect.size = textFieldSize;
	_processWeixinsJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
	_processWeixinsJobIntervalTextField.backgroundColor = [UIColor grayColor];
	_processWeixinsJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.processWeixinsJobInterval];
	[self.view addSubview:_processWeixinsJobIntervalTextField];
	
	
	
	rect.origin.x = 10;
	rect.origin.y += 50;
	rect.size = labelSize;
	UILabel *processArticlesJobLabel = [[UILabel alloc] initWithFrame:rect];
	processArticlesJobLabel.text = @"processArticlesJobOn";
	[self.view addSubview:processArticlesJobLabel];
	
	rect.origin.y += 30;
	rect.size = buttonSize;
	_processArticlesJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_processArticlesJobButton.frame = rect;
	[_processArticlesJobButton setTitle:[ZBAntServer onOrOff:_server.processArticlesJobOn] forState:UIControlStateNormal];
	[_processArticlesJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.processArticlesJobOn] forState:UIControlStateNormal];
	_processArticlesJobButton.backgroundColor = [UIColor grayColor];
	[_processArticlesJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:_processArticlesJobButton];
	
	rect.origin.x += 80;
	rect.size = textFieldSize;
	_processArticlesJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
	_processArticlesJobIntervalTextField.backgroundColor = [UIColor grayColor];
	_processArticlesJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.processArticlesJobInterval];
	[self.view addSubview:_processArticlesJobIntervalTextField];
	
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
	[self.view addSubview:saveButton];
	
	rect.origin.y += 70;
	UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
	loginButton.showsTouchWhenHighlighted = YES;
	loginButton.frame = rect;
	[loginButton setTitle:@"Login" forState:UIControlStateNormal];
	[loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	loginButton.backgroundColor = [UIColor greenColor];
	[loginButton addTarget:self action:@selector(pushToLogin) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:loginButton];
}

- (void)dismiss {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toogleButton:(UIButton *)sender {
	NSNumber *value = NULL;
	if (sender == _masterJobButton) {
		_server.masterJobOn = @(![_server.masterJobOn boolValue]);
		value = _server.masterJobOn;
	} else if (sender == _grabWeixinsJobButton) {
		_server.grabWeixinsJobOn = @(![_server.grabWeixinsJobOn boolValue]);
		value = _server.grabWeixinsJobOn;
	} else if (sender == _grabArticlesJobButton) {
		_server.grabArticlesJobOn = @(![_server.grabArticlesJobOn boolValue]);
		value = _server.grabArticlesJobOn;
	} else if (sender == _processWeixinsJobButton) {
		_server.processWeixinsJobOn = @(![_server.processWeixinsJobOn boolValue]);
		value = _server.processWeixinsJobOn;
	} else if (sender == _processArticlesJobButton) {
		_server.processArticlesJobOn = @(![_server.processArticlesJobOn boolValue]);
		value = _server.processArticlesJobOn;
	} else if (sender == _inChargeOfReloadTasksButton) {
		_server.inChargeOfReloadTasks = @(![_server.inChargeOfReloadTasks boolValue]);
		value = _server.inChargeOfReloadTasks;
	}
	if (value) {
		[sender setTitle:[ZBAntServer onOrOff:value] forState:UIControlStateNormal];
		[sender setTitleColor:[ZBAntServer colorOnOrOff:value] forState:UIControlStateNormal];
	}
}

- (void)saveSettings {
	_server.masterJobInterval = @([_masterJobIntervalTextField.text integerValue]);
	_server.grabWeixinsJobInterval = @([_grabWeixinsJobIntervalTextField.text integerValue]);
	_server.grabArticlesJobInterval = @([_grabArticlesJobIntervalTextField.text integerValue]);
	_server.processWeixinsJobInterval = @([_processWeixinsJobIntervalTextField.text integerValue]);
	_server.processArticlesJobInterval = @([_processArticlesJobIntervalTextField.text integerValue]);
	
	[[ZBHTTPManager shared] save:_server.outerIp settings:[_server settings] withBlock:^(id responseObject, NSError *error) {
		if (error) {
			_options[kCRToastTextKey] = @"设置失败!";
			_options[kCRToastBackgroundColorKey] = [UIColor redColor];
		}
		
		if (![responseObject[@"error"] isEqual:@0]) {
			_options[kCRToastTextKey] = @"设置失败!";
			_options[kCRToastBackgroundColorKey] = [UIColor redColor];
		}
		
		[CRToastManager showNotificationWithOptions:_options completionBlock:^{
		}];
	}];
}

- (void)pushToLogin {
	ZBLoginViewController *loginViewController = [[ZBLoginViewController alloc] init];
	loginViewController.server = _server;
	[self.navigationController pushViewController:loginViewController animated:YES];
}

- (void)ping {
	ZBPingViewController *pingViewController = [[ZBPingViewController alloc] init];
	pingViewController.server = _server;
	[self.navigationController pushViewController:pingViewController animated:YES];
}


@end
