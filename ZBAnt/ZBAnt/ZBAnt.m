//
//  ZBAnt.m
//  Facechat
//
//  Created by zhangbin on 12/29/15.
//  Copyright © 2015 zoombin. All rights reserved.
//

#import "ZBAnt.h"
#import "ZBAntTask.h"
#import "AFNetworking.h"

NSString * const HOME_URL_STRING = @"http://localhost:3030/admin/";

@interface ZBAnt () <UIWebViewDelegate>

@property (nonatomic, readwrite) NSTimer *timer;
@property (nonatomic, readwrite) ZBAntTask *task;

@end

@implementation ZBAnt

- (AFHTTPSessionManager *)manager {
	static AFHTTPSessionManager *_manager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:HOME_URL_STRING]];
		_manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
	});
	
	return _manager;
}

- (UIWebView *)webView {
	static UIWebView *_webView = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
		_webView.delegate = self;
	});
	
	return _webView;
}

- (void)fetchTaskWithBlock:(void (^)(id responseObject, NSError *error))block {
	[[self manager] GET:@"gettask" parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		if (block) block(responseObject, nil);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		if (block) block(nil, error);
	}];
}

- (void)submitTask:(NSString *)string withBlock:(void (^)(id responseObject, NSError *error))block {
//	[[self manager] POST:@"" parameters:NULL success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
//		
//	} failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
//		
//	}];
}

- (void)start {
	[self fetchTaskWithBlock:^(id responseObject, NSError *error) {
		if (!error) {
			NSLog(@"response: %@", responseObject);
			_task = [[ZBAntTask alloc] initWithDictionary:responseObject];
			[[self webView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_task.URLString]]];
		}
	}];
}

- (void)autoClick {
	NSLog(@"autoClick");
	//TODO 这里要写一下dom的id

	NSString *titleCode = @"document.getElementById('sogou_vr_11002601_title_0').innerHTML";
	NSString *title = [[self webView] stringByEvaluatingJavaScriptFromString:titleCode];
	NSLog(@"title: %@", title);
	
	NSString *code = @"document.getElementById('sogou_vr_11002601_title_0').click()";
	[[self webView] stringByEvaluatingJavaScriptFromString:code];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if ([webView.request.URL.absoluteString containsString:@"weixin.sogou.com"]) {
		_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoClick) userInfo:nil repeats:NO];
	}
	
	if ([webView.request.URL.absoluteString containsString:@"weixin.qq.com"]) {
		NSLog(@"url: %@", webView.request.URL.absoluteString);
		[self submitTask:webView.request.URL.absoluteString withBlock:^(id responseObject, NSError *error) {
			if (error) {
				NSLog(@"submit task error: %@", error);
			} else {
				NSLog(@"submit success");
			}
		}];
	}
}


@end
