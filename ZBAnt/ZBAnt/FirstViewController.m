//
//  FirstViewController.m
//  ZBAnt
//
//  Created by zhangbin on 4/4/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController () <UIWebViewDelegate>

@property (nonatomic, readwrite) UIWebView *webView;

@end

@implementation FirstViewController

- (void)viewDidLoad {
	[super viewDidLoad];
//	_webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
//	_webView.delegate = self;
//	[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://weixin.sogou.com/weixin?type=1&query=%E5%88%9B%E4%B8%9A"]]];
//	[self.view addSubview:_webView];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end
