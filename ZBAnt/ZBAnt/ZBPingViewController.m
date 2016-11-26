//
//  ZBPingViewController.m
//  ZBAnt
//
//  Created by zhangbin on 9/19/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBPingViewController.h"
#import "ZBHTTPManager.h"

@interface ZBPingViewController ()

@end

@implementation ZBPingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor lightTextColor];
	UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	NSString *urlString = [[ZBHTTPManager shared] adminLoginUrlStringWithServer:_server];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
	[self.view addSubview:webView];
}

@end
