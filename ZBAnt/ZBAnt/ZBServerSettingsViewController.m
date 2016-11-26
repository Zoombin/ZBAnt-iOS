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

@property (readwrite) UIButton *inChargeOfReloadTasksButton;
@property (readwrite) UIButton *inChargeOfReloadTasksDeepButton;
@property (readwrite) UIButton *grabWeixinsJobButton;
@property (readwrite) UIButton *grabArticlesJobButton;
@property (readwrite) UIButton *processWeixinsJobButton;
@property (readwrite) UIButton *processArticlesJobButton;
@property (readwrite) UIButton *grabArticlesDeepJobButton;

@property (readwrite) UITextField *grabWeixinsJobIntervalTextField;
@property (readwrite) UITextField *grabArticlesJobIntervalTextField;
@property (readwrite) UITextField *processWeixinsJobIntervalTextField;
@property (readwrite) UITextField *processArticlesJobIntervalTextField;
@property (readwrite) UITextField *grabArticlesDeepJobIntervalTextField;

@property (readwrite) NSMutableDictionary *options;

//newrank
@property (readwrite) UIButton *nkGrabArticlesJobButton;
@property (readwrite) UITextField *nkGrabArticlesJobIntervalTextField;
@property (readwrite) UIButton *nkGrabDetailsJobButton;
@property (readwrite) UITextField *nkGrabDetailsJobIntervalTextField;
@property (readwrite) UIButton *nkProcessArticlesJobButton;
@property (readwrite) UITextField *nkProcessArticlesJobIntervalTextField;
@property (readwrite) UIButton *nkProcessDetailsJobButton;
@property (readwrite) UITextField *nkProcessDetailsJobIntervalTextField;
@property (readwrite) UIButton *nkInChargeOfReloadArticlesTasksButton;
@property (readwrite) UIButton *nkInChargeOfReloadDetailsTasksButton;
//gsdata
@property (readwrite) UIButton *gsGrabRankJobButton;
@property (readwrite) UITextField *gsGrabRankIntervalTextField;
@property (readwrite) UIButton *gsInChargeOfReloadRankTasksButton;
@property (readwrite) UIButton *gsProcessRankJobButton;
@property (readwrite) UITextField *gsProcessRankJobIntervalTextField;

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
	
	UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
	[self.view addSubview:scrollView];
	
	CGRect originRect = CGRectMake(10, 70, 60, 40);
	CGRect rect = originRect;
	CGSize labelSize = CGSizeMake(320, 30);
	CGSize buttonSize = CGSizeMake(60, 40);
	CGSize textFieldSize = CGSizeMake(80, 40);
	
	
	if ([_channel isEqualToString:WEIBOYI]) {
		rect.size = labelSize;
		rect.origin.y += 30;
		rect.size = buttonSize;
		
		rect.origin.x += 100;
		rect.origin.y = 70;
		rect.size = labelSize;
		UILabel *inChargeOfReloadTasksLabel = [[UILabel alloc] initWithFrame:rect];
		inChargeOfReloadTasksLabel.text = @"ReTasks";
		[scrollView addSubview:inChargeOfReloadTasksLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_inChargeOfReloadTasksButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_inChargeOfReloadTasksButton.frame = rect;
		[_inChargeOfReloadTasksButton setTitle:[ZBAntServer onOrOff:_server.inChargeOfReloadTasks] forState:UIControlStateNormal];
		[_inChargeOfReloadTasksButton setTitleColor:[ZBAntServer colorOnOrOff:_server.inChargeOfReloadTasks] forState:UIControlStateNormal];
		_inChargeOfReloadTasksButton.backgroundColor = [UIColor grayColor];
		[_inChargeOfReloadTasksButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_inChargeOfReloadTasksButton];
		
		
		rect.origin.x += 80;
		rect.origin.y = inChargeOfReloadTasksLabel.frame.origin.y;
		rect.size = labelSize;
		UILabel *inChargeOfReloadTasksDeepLabel = [[UILabel alloc] initWithFrame:rect];
		inChargeOfReloadTasksDeepLabel.text = @"TasksDeep";
		[scrollView addSubview:inChargeOfReloadTasksDeepLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_inChargeOfReloadTasksDeepButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_inChargeOfReloadTasksDeepButton.frame = rect;
		[_inChargeOfReloadTasksDeepButton setTitle:[ZBAntServer onOrOff:_server.inChargeOfReloadTasksDeep] forState:UIControlStateNormal];
		[_inChargeOfReloadTasksDeepButton setTitleColor:[ZBAntServer colorOnOrOff:_server.inChargeOfReloadTasksDeep] forState:UIControlStateNormal];
		_inChargeOfReloadTasksDeepButton.backgroundColor = [UIColor grayColor];
		[_inChargeOfReloadTasksDeepButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_inChargeOfReloadTasksDeepButton];
		
		
		rect.origin.x = 10;
		rect.origin.y += 50;
		rect.size = labelSize;
		UILabel *grabWeixinsJobLabel = [[UILabel alloc] initWithFrame:rect];
		grabWeixinsJobLabel.text = @"grabWeixinsJobOn";
		[scrollView addSubview:grabWeixinsJobLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_grabWeixinsJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_grabWeixinsJobButton.frame = rect;
		[_grabWeixinsJobButton setTitle:[ZBAntServer onOrOff:_server.grabWeixinsJobOn] forState:UIControlStateNormal];
		[_grabWeixinsJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.grabWeixinsJobOn] forState:UIControlStateNormal];
		_grabWeixinsJobButton.backgroundColor = [UIColor grayColor];
		[_grabWeixinsJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_grabWeixinsJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_grabWeixinsJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_grabWeixinsJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_grabWeixinsJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.grabWeixinsJobInterval];
		[scrollView addSubview:_grabWeixinsJobIntervalTextField];
		
		
		
		rect.origin.x += 100;
		rect.origin.y = grabWeixinsJobLabel.frame.origin.y;
		rect.size = labelSize;
		UILabel *processWeixinsJobLabel = [[UILabel alloc] initWithFrame:rect];
		processWeixinsJobLabel.text = @"processWeixinsJobOn";
		[scrollView addSubview:processWeixinsJobLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_processWeixinsJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_processWeixinsJobButton.frame = rect;
		[_processWeixinsJobButton setTitle:[ZBAntServer onOrOff:_server.processWeixinsJobOn] forState:UIControlStateNormal];
		[_processWeixinsJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.processWeixinsJobOn] forState:UIControlStateNormal];
		_processWeixinsJobButton.backgroundColor = [UIColor grayColor];
		[_processWeixinsJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_processWeixinsJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_processWeixinsJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_processWeixinsJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_processWeixinsJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.processWeixinsJobInterval];
		[scrollView addSubview:_processWeixinsJobIntervalTextField];
		
		
		
		rect.origin.x = 10;
		rect.origin.y += 50;
		rect.size = labelSize;
		UILabel *grabArticlesJobLabel = [[UILabel alloc] initWithFrame:rect];
		grabArticlesJobLabel.text = @"grabArticlesJobOn";
		[scrollView addSubview:grabArticlesJobLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_grabArticlesJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_grabArticlesJobButton.frame = rect;
		[_grabArticlesJobButton setTitle:[ZBAntServer onOrOff:_server.grabArticlesJobOn] forState:UIControlStateNormal];
		[_grabArticlesJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.grabArticlesJobOn] forState:UIControlStateNormal];
		_grabArticlesJobButton.backgroundColor = [UIColor grayColor];
		[_grabArticlesJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_grabArticlesJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_grabArticlesJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_grabArticlesJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_grabArticlesJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.grabArticlesJobInterval];
		[scrollView addSubview:_grabArticlesJobIntervalTextField];
		
		
		
		rect.origin.x += 100;
		rect.origin.y = grabArticlesJobLabel.frame.origin.y;
		rect.size = labelSize;
		UILabel *processArticlesJobLabel = [[UILabel alloc] initWithFrame:rect];
		processArticlesJobLabel.text = @"processArticlesJobOn";
		[scrollView addSubview:processArticlesJobLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_processArticlesJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_processArticlesJobButton.frame = rect;
		[_processArticlesJobButton setTitle:[ZBAntServer onOrOff:_server.processArticlesJobOn] forState:UIControlStateNormal];
		[_processArticlesJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.processArticlesJobOn] forState:UIControlStateNormal];
		_processArticlesJobButton.backgroundColor = [UIColor grayColor];
		[_processArticlesJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_processArticlesJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_processArticlesJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_processArticlesJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_processArticlesJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.processArticlesJobInterval];
		[scrollView addSubview:_processArticlesJobIntervalTextField];
		
		
		
		rect.origin.x = grabArticlesJobLabel.frame.origin.x;
		rect.origin.y += 50;
		rect.size = labelSize;
		UILabel *grabArticlesDeepLabel = [[UILabel alloc] initWithFrame:rect];
		grabArticlesDeepLabel.text = @"articlesDeep";
		[scrollView addSubview:grabArticlesDeepLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_grabArticlesDeepJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_grabArticlesDeepJobButton.frame = rect;
		[_grabArticlesDeepJobButton setTitle:[ZBAntServer onOrOff:_server.grabArticlesDeepJobOn] forState:UIControlStateNormal];
		[_grabArticlesDeepJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.grabArticlesDeepJobOn] forState:UIControlStateNormal];
		_grabArticlesDeepJobButton.backgroundColor = [UIColor grayColor];
		[_grabArticlesDeepJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_grabArticlesDeepJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_grabArticlesDeepJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_grabArticlesDeepJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_grabArticlesDeepJobIntervalTextField.text = [NSString stringWithFormat:@"%@",_server.grabArticlesDeepJobInterval];
		[scrollView addSubview:_grabArticlesDeepJobIntervalTextField];
		
		
		//save button
		rect.origin.x = 0;
		rect.origin.y += 50;
		rect.size.width = self.view.bounds.size.width / 2;
		rect.size.height = 50;
		UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
		saveButton.showsTouchWhenHighlighted = YES;
		saveButton.frame = rect;
		[saveButton setTitle:@"Save" forState:UIControlStateNormal];
		[saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		saveButton.backgroundColor = [UIColor orangeColor];
		[saveButton addTarget:self action:@selector(saveSettings) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:saveButton];
		
		//login button
		rect.origin.x += self.view.bounds.size.width / 2;
		UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
		loginButton.showsTouchWhenHighlighted = YES;
		loginButton.frame = rect;
		[loginButton setTitle:@"Login" forState:UIControlStateNormal];
		[loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		loginButton.backgroundColor = [UIColor greenColor];
		[loginButton addTarget:self action:@selector(pushToLogin) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:loginButton];
		
	} else if ([_channel isEqualToString:NEWRANK]) {
		rect = originRect;
		rect.size = labelSize;
		UILabel *nkGrabArticlesLabel = [[UILabel alloc] initWithFrame:rect];
		nkGrabArticlesLabel.text = @"nkArticlesJob";
		[scrollView addSubview:nkGrabArticlesLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_nkGrabArticlesJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_nkGrabArticlesJobButton.frame = rect;
		[_nkGrabArticlesJobButton setTitle:[ZBAntServer onOrOff:_server.nkGrabArticlesJobOn] forState:UIControlStateNormal];
		[_nkGrabArticlesJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.nkGrabArticlesJobOn] forState:UIControlStateNormal];
		_nkGrabArticlesJobButton.backgroundColor = [UIColor grayColor];
		[_nkGrabArticlesJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_nkGrabArticlesJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_nkGrabArticlesJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_nkGrabArticlesJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_nkGrabArticlesJobIntervalTextField.text = [NSString stringWithFormat:@"%@", _server.nkGrabArticlesJobInterval];
		[scrollView addSubview:_nkGrabArticlesJobIntervalTextField];
		
		
		rect.origin.x += 100;
		rect.origin.y = nkGrabArticlesLabel.frame.origin.y;
		rect.size = labelSize;
		UILabel *nkGrabDetailsLabel = [[UILabel alloc] initWithFrame:rect];
		nkGrabDetailsLabel.text = @"nkDetailsJob";
		[scrollView addSubview:nkGrabDetailsLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_nkGrabDetailsJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_nkGrabDetailsJobButton.frame = rect;
		[_nkGrabDetailsJobButton setTitle:[ZBAntServer onOrOff:_server.nkGrabDetailsJobOn] forState:UIControlStateNormal];
		[_nkGrabDetailsJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.nkGrabDetailsJobOn] forState:UIControlStateNormal];
		_nkGrabDetailsJobButton.backgroundColor = [UIColor grayColor];
		[_nkGrabDetailsJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_nkGrabDetailsJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_nkGrabDetailsJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_nkGrabDetailsJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_nkGrabDetailsJobIntervalTextField.text = [NSString stringWithFormat:@"%@", _server.nkGrabDetailsJobInterval];
		[scrollView addSubview:_nkGrabDetailsJobIntervalTextField];
		
		
		rect.origin.x = originRect.origin.x;
		rect.origin.y += 50;
		rect.size = labelSize;
		UILabel *nkProcessArticlesLabel = [[UILabel alloc] initWithFrame:rect];
		nkProcessArticlesLabel.text = @"nkProcessArticles";
		[scrollView addSubview:nkProcessArticlesLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_nkProcessArticlesJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_nkProcessArticlesJobButton.frame = rect;
		[_nkProcessArticlesJobButton setTitle:[ZBAntServer onOrOff:_server.nkProcessArticlesJobOn] forState:UIControlStateNormal];
		[_nkProcessArticlesJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.nkProcessArticlesJobOn] forState:UIControlStateNormal];
		_nkProcessArticlesJobButton.backgroundColor = [UIColor grayColor];
		[_nkProcessArticlesJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_nkProcessArticlesJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_nkProcessArticlesJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_nkProcessArticlesJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_nkProcessArticlesJobIntervalTextField.text = [NSString stringWithFormat:@"%@", _server.nkProcessArticlesJobInterval];
		[scrollView addSubview:_nkProcessArticlesJobIntervalTextField];
		
		
		
		rect.origin.x += 100;
		rect.origin.y = nkProcessArticlesLabel.frame.origin.y;
		rect.size = labelSize;
		UILabel *nkProcessDetailsLabel = [[UILabel alloc] initWithFrame:rect];
		nkProcessDetailsLabel.text = @"nkProcessDetails";
		[scrollView addSubview:nkProcessDetailsLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_nkProcessDetailsJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_nkProcessDetailsJobButton.frame = rect;
		[_nkProcessDetailsJobButton setTitle:[ZBAntServer onOrOff:_server.nkProcessDetailsJobOn] forState:UIControlStateNormal];
		[_nkProcessDetailsJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.nkProcessDetailsJobOn] forState:UIControlStateNormal];
		_nkProcessDetailsJobButton.backgroundColor = [UIColor grayColor];
		[_nkProcessDetailsJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_nkProcessDetailsJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_nkProcessDetailsJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_nkProcessDetailsJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_nkProcessDetailsJobIntervalTextField.text = [NSString stringWithFormat:@"%@", _server.nkProcessDetailsJobInterval];
		[scrollView addSubview:_nkProcessDetailsJobIntervalTextField];
		
		
		rect.origin.x = originRect.origin.x;
		rect.origin.y += 50;
		rect.size = labelSize;
		UILabel *nkInChargeOfReloadArticlesTasksLabel = [[UILabel alloc] initWithFrame:rect];
		nkInChargeOfReloadArticlesTasksLabel.text = @"nkReloadArticles";
		[scrollView addSubview:nkInChargeOfReloadArticlesTasksLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_nkInChargeOfReloadArticlesTasksButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_nkInChargeOfReloadArticlesTasksButton.frame = rect;
		[_nkInChargeOfReloadArticlesTasksButton setTitle:[ZBAntServer onOrOff:_server.nkInChargeOfReloadArticlesTasks] forState:UIControlStateNormal];
		[_nkInChargeOfReloadArticlesTasksButton setTitleColor:[ZBAntServer colorOnOrOff:_server.nkInChargeOfReloadArticlesTasks] forState:UIControlStateNormal];
		_nkInChargeOfReloadArticlesTasksButton.backgroundColor = [UIColor grayColor];
		[_nkInChargeOfReloadArticlesTasksButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_nkInChargeOfReloadArticlesTasksButton];

		
		rect.origin.x = nkProcessDetailsLabel.frame.origin.x;
		rect.origin.y = nkInChargeOfReloadArticlesTasksLabel.frame.origin.y;
		rect.size = labelSize;
		UILabel *nkInChargeOfReloadDetailsTasksLabel = [[UILabel alloc] initWithFrame:rect];
		nkInChargeOfReloadDetailsTasksLabel.text = @"nkReloadDetails";
		[scrollView addSubview:nkInChargeOfReloadDetailsTasksLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_nkInChargeOfReloadDetailsTasksButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_nkInChargeOfReloadDetailsTasksButton.frame = rect;
		[_nkInChargeOfReloadDetailsTasksButton setTitle:[ZBAntServer onOrOff:_server.nkInChargeOfReloadDetailsTasks] forState:UIControlStateNormal];
		[_nkInChargeOfReloadDetailsTasksButton setTitleColor:[ZBAntServer colorOnOrOff:_server.nkInChargeOfReloadDetailsTasks] forState:UIControlStateNormal];
		_nkInChargeOfReloadDetailsTasksButton.backgroundColor = [UIColor grayColor];
		[_nkInChargeOfReloadDetailsTasksButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_nkInChargeOfReloadDetailsTasksButton];
		
		
		//save button
		rect.origin.x = 0;
		rect.origin.y += 50;
		rect.size.width = self.view.bounds.size.width;
		rect.size.height = 50;
		UIButton *saveButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
		saveButton2.showsTouchWhenHighlighted = YES;
		saveButton2.frame = rect;
		[saveButton2 setTitle:@"Save2" forState:UIControlStateNormal];
		[saveButton2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		saveButton2.backgroundColor = [UIColor orangeColor];
		[saveButton2 addTarget:self action:@selector(saveSettings2) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:saveButton2];
	} else if ([_channel isEqualToString:GSDATA]) {
		rect = originRect;
		rect.size = labelSize;
		UILabel *gsGrabRankLabel = [[UILabel alloc] initWithFrame:rect];
		gsGrabRankLabel.text = @"gsRankJob";
		[scrollView addSubview:gsGrabRankLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_gsGrabRankJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_gsGrabRankJobButton.frame = rect;
		[_gsGrabRankJobButton setTitle:[ZBAntServer onOrOff:_server.gsGrabRankJobOn] forState:UIControlStateNormal];
		[_gsGrabRankJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.gsGrabRankJobOn] forState:UIControlStateNormal];
		_gsGrabRankJobButton.backgroundColor = [UIColor grayColor];
		[_gsGrabRankJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_gsGrabRankJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_gsGrabRankIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_gsGrabRankIntervalTextField.backgroundColor = [UIColor grayColor];
		_gsGrabRankIntervalTextField.text = [NSString stringWithFormat:@"%@", _server.gsGrabRankJobInterval];
		[scrollView addSubview:_gsGrabRankIntervalTextField];
		
		
		rect.origin.x = originRect.origin.x;
		rect.origin.y += 50;
		rect.size = labelSize;
		UILabel *gsInchargeReloadRankTasksLabel = [[UILabel alloc] initWithFrame:rect];
		gsInchargeReloadRankTasksLabel.text = @"gsReloadRank";
		[scrollView addSubview:gsInchargeReloadRankTasksLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_gsInChargeOfReloadRankTasksButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_gsInChargeOfReloadRankTasksButton.frame = rect;
		[_gsInChargeOfReloadRankTasksButton setTitle:[ZBAntServer onOrOff:_server.gsInchargeOfReloadRankTasks] forState:UIControlStateNormal];
		[_gsInChargeOfReloadRankTasksButton setTitleColor:[ZBAntServer colorOnOrOff:_server.gsInchargeOfReloadRankTasks] forState:UIControlStateNormal];
		_gsInChargeOfReloadRankTasksButton.backgroundColor = [UIColor grayColor];
		[_gsInChargeOfReloadRankTasksButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_gsInChargeOfReloadRankTasksButton];
		
		
		rect.origin.x = originRect.origin.x;
		rect.origin.y += 50;
		rect.size = labelSize;
		UILabel *gsProcessRankLabel = [[UILabel alloc] initWithFrame:rect];
		gsProcessRankLabel.text = @"gsProcessRank";
		[scrollView addSubview:gsProcessRankLabel];
		
		rect.origin.y += 30;
		rect.size = buttonSize;
		_gsProcessRankJobButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		_gsProcessRankJobButton.frame = rect;
		[_gsProcessRankJobButton setTitle:[ZBAntServer onOrOff:_server.gsProcessRankJobOn] forState:UIControlStateNormal];
		[_gsProcessRankJobButton setTitleColor:[ZBAntServer colorOnOrOff:_server.gsProcessRankJobOn] forState:UIControlStateNormal];
		_gsProcessRankJobButton.backgroundColor = [UIColor grayColor];
		[_gsProcessRankJobButton addTarget:self action:@selector(toogleButton:) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:_gsProcessRankJobButton];
		
		rect.origin.x += 80;
		rect.size = textFieldSize;
		_gsProcessRankJobIntervalTextField = [[UITextField alloc] initWithFrame:rect];
		_gsProcessRankJobIntervalTextField.backgroundColor = [UIColor grayColor];
		_gsProcessRankJobIntervalTextField.text = [NSString stringWithFormat:@"%@", _server.gsProcessRankJobInterval];
		[scrollView addSubview:_gsProcessRankJobIntervalTextField];

		
		//save button
		rect.origin.x = 0;
		rect.origin.y += 50;
		rect.size.width = self.view.bounds.size.width;
		rect.size.height = 50;
		UIButton *saveButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
		saveButton3.showsTouchWhenHighlighted = YES;
		saveButton3.frame = rect;
		[saveButton3 setTitle:@"Save3" forState:UIControlStateNormal];
		[saveButton3 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
		saveButton3.backgroundColor = [UIColor orangeColor];
		[saveButton3 addTarget:self action:@selector(saveSettings3) forControlEvents:UIControlEventTouchUpInside];
		[scrollView addSubview:saveButton3];
	}
	scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, 1200);
}

- (void)dismiss {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)toogleButton:(UIButton *)sender {
	NSNumber *value = NULL;
	if (sender == _grabWeixinsJobButton) {
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
	} else if (sender == _inChargeOfReloadTasksDeepButton) {
		_server.inChargeOfReloadTasksDeep = @(![_server.inChargeOfReloadTasksDeep boolValue]);
		value = _server.inChargeOfReloadTasksDeep;
	} else if (sender == _grabArticlesDeepJobButton) {
		_server.grabArticlesDeepJobOn = @(![_server.grabArticlesDeepJobOn boolValue]);
		value = _server.grabArticlesDeepJobOn;
	} else if (sender == _nkGrabArticlesJobButton) {
		_server.nkGrabArticlesJobOn = @(![_server.nkGrabArticlesJobOn boolValue]);
		value = _server.nkGrabArticlesJobOn;
	} else if (sender == _nkGrabDetailsJobButton) {
		_server.nkGrabDetailsJobOn = @(![_server.nkGrabDetailsJobOn boolValue]);
		value = _server.nkGrabDetailsJobOn;
	} else if (sender == _nkProcessArticlesJobButton) {
		_server.nkProcessArticlesJobOn = @(![_server.nkProcessArticlesJobOn boolValue]);
		value = _server.nkProcessArticlesJobOn;
	} else if (sender == _nkProcessDetailsJobButton) {
		_server.nkProcessDetailsJobOn = @(![_server.nkProcessDetailsJobOn boolValue]);
		value = _server.nkProcessDetailsJobOn;
	} else if (sender == _nkInChargeOfReloadArticlesTasksButton) {
		_server.nkInChargeOfReloadArticlesTasks = @(![_server.nkInChargeOfReloadArticlesTasks boolValue]);
		value = _server.nkInChargeOfReloadArticlesTasks;
	} else if (sender == _nkInChargeOfReloadDetailsTasksButton) {
		_server.nkInChargeOfReloadDetailsTasks = @(![_server.nkInChargeOfReloadDetailsTasks boolValue]);
		value = _server.nkInChargeOfReloadDetailsTasks;
	} else if (sender == _gsGrabRankJobButton) {
		_server.gsGrabRankJobOn = @(![_server.gsGrabRankJobOn boolValue]);
		value = _server.gsGrabRankJobOn;
	} else if (sender == _gsInChargeOfReloadRankTasksButton) {
		_server.gsInchargeOfReloadRankTasks = @(![_server.gsInchargeOfReloadRankTasks boolValue]);
		value = _server.gsInchargeOfReloadRankTasks;
	} else if (sender == _gsProcessRankJobButton) {
		_server.gsProcessRankJobOn = @(![_server.gsProcessRankJobOn boolValue]);
		value = _server.gsProcessRankJobOn;
	}
	if (value) {
		[sender setTitle:[ZBAntServer onOrOff:value] forState:UIControlStateNormal];
		[sender setTitleColor:[ZBAntServer colorOnOrOff:value] forState:UIControlStateNormal];
	}
}

- (void)saveSettings {
	_server.grabWeixinsJobInterval = @([_grabWeixinsJobIntervalTextField.text integerValue]);
	_server.grabArticlesJobInterval = @([_grabArticlesJobIntervalTextField.text integerValue]);
	_server.processWeixinsJobInterval = @([_processWeixinsJobIntervalTextField.text integerValue]);
	_server.processArticlesJobInterval = @([_processArticlesJobIntervalTextField.text integerValue]);
	_server.grabArticlesDeepJobInterval = @([_grabArticlesDeepJobIntervalTextField.text integerValue]);
	
	[[ZBHTTPManager shared] save:WEIBOYI server:_server settings:[_server settings] withBlock:^(id responseObject, NSError *error) {
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

- (void)saveSettings2 {
	_server.nkGrabArticlesJobInterval = @([_nkGrabArticlesJobIntervalTextField.text integerValue]);
	_server.nkGrabDetailsJobInterval = @([_nkGrabDetailsJobIntervalTextField.text integerValue]);
	_server.nkProcessArticlesJobInterval = @([_nkProcessArticlesJobIntervalTextField.text integerValue]);
	_server.nkProcessDetailsJobInterval = @([_nkProcessDetailsJobIntervalTextField.text integerValue]);
	
	[[ZBHTTPManager shared] save:NEWRANK server:_server settings:[_server settings2] withBlock:^(id responseObject, NSError *error) {
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

- (void)saveSettings3 {
	_server.gsGrabRankJobInterval = @([_gsGrabRankIntervalTextField.text integerValue]);
	_server.gsProcessRankJobInterval = @([_gsProcessRankJobIntervalTextField.text integerValue]);
	[[ZBHTTPManager shared] save:GSDATA server:_server settings:[_server settings3] withBlock:^(id responseObject, NSError *error) {
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
