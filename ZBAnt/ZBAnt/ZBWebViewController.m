//
//  ZBWebViewController.m
//  ZBAnt
//
//  Created by zhangbin on 9/19/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBWebViewController.h"
#import "ZBHTTPManager.h"

@interface ZBWebViewController ()

@end

@implementation ZBWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor lightTextColor];
	UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlString]]];
	[self.view addSubview:webView];
}

@end
