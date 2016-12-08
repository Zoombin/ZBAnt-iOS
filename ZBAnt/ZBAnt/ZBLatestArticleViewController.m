//
//  ZBLatestArticleViewController.m
//  ZBAnt
//
//  Created by zhangbin on 06/12/2016.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBLatestArticleViewController.h"
#import "ZBHTTPManager.h"
#import "ZBWebViewController.h"

@interface ZBLatestArticleViewController ()

@property (nonatomic, readwrite) UITextView *textView;
@property (nonatomic, readwrite) NSString *urlString;

@end

@implementation ZBLatestArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_textView = [[UITextView alloc] initWithFrame:self.view.bounds];
	_textView.editable = NO;
	[self.view addSubview:_textView];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openWebView)];
	[self.view addGestureRecognizer:tap];
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismiss)];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	[self refresh];
}

- (void)dismiss {
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)refresh {
	[[ZBHTTPManager shared] latestArticleWithBlock:^(id responseObject, NSError *error) {
		if (error) return;
		NSLog(@"responseObject: %@", responseObject);
		if (responseObject) {
			_urlString = responseObject[@"data"][@"url"];
			NSData *jsonData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil];
			NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
			_textView.text = jsonString;
		}
		
	}];
}

- (void)openWebView {
	if (_urlString.length) {
		ZBWebViewController *webViewController = [[ZBWebViewController alloc] init];
		webViewController.urlString = _urlString;
		[self.navigationController pushViewController:webViewController animated:YES];
	}
}

@end
