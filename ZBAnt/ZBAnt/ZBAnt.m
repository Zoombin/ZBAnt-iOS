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
//NSString * const HOME_URL_STRING = @"http://112.124.98.9:3030/admin/";

@interface ZBAnt () <UIWebViewDelegate>

@property (nonatomic, readwrite) UIWebView *webView;
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
	if (!_webView) {
		_webView = [[UIWebView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		_webView.delegate = self;
	}
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
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"articleTitle"] = _task.resultTitle ?: @"";
	parameters[@"articleUrl"] = _task.resultURLString ?: @"";
	parameters[@"articleContent"] = _task.resultSummary ?: @"";
	parameters[@"articleUnixTime"] = _task.resultTimestamp ?: @"";
	parameters[@"articleImage"] = _task.resultImage ?: @"";
	parameters[@"url"] = _task.URLString;
	parameters[@"id"] = _task.ID;
	
	[[self manager] POST:@"dopostdatasingle" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
		if (block) block(responseObject, nil);
	} failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
		if (block) block(nil, error);
	}];
}

- (void)start {
	[self fetchTaskWithBlock:^(id responseObject, NSError *error) {
		if (!error) {
			NSLog(@"response: %@", responseObject);
			NSNumber *error = responseObject[@"error"];
			if (error.integerValue == 0) {
				_task = [[ZBAntTask alloc] initWithDictionary:responseObject[@"data"]];
				[[self webView] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_task.URLString]]];
			} else {
				NSLog(@"task error: %@", responseObject[@"msg"]);
			}
		}
	}];
}

- (void)autoClick {
	NSLog(@"autoClick");
	
	NSString *titleCode = @"document.getElementById('sogou_vr_11002601_title_0').innerHTML";
	_task.resultTitle = [[self webView] stringByEvaluatingJavaScriptFromString:titleCode];
	
	NSString *summaryCode = @"document.getElementById('sogou_vr_11002601_summary_0').innerHTML";
	_task.resultSummary = [[self webView] stringByEvaluatingJavaScriptFromString:summaryCode];
	
	NSString *timestampCode = @"document.getElementById('sogou_vr_11002601_box_0').getElementsByTagName('div')[1].getElementsByTagName('div')[0].getAttribute('t')";
	_task.resultTimestamp = [[self webView] stringByEvaluatingJavaScriptFromString:timestampCode];

	NSString *imageCode = @"document.getElementById('sogou_vr_11002601_img_0').getElementsByTagName('img')[0].src";
	_task.resultImage = [[self webView] stringByEvaluatingJavaScriptFromString:imageCode];
	
	NSString *clickCode = @"document.getElementById('sogou_vr_11002601_title_0').click()";
	[[self webView] stringByEvaluatingJavaScriptFromString:clickCode];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"webview error: %@", error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if ([webView.request.URL.absoluteString containsString:@"weixin.sogou.com"]) {
		_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoClick) userInfo:nil repeats:NO];
	}
	
	if ([webView.request.URL.absoluteString containsString:@"weixin.qq.com"]) {
		_task.resultURLString = webView.request.URL.absoluteString;
		
		NSLog(@"title: %@, summary: %@, image: %@, timestamp: %@, url: %@", _task.resultTitle, _task.resultSummary, _task.resultImage, _task.resultTimestamp, _task.resultURLString);
		
		if (_task.resultURLString.length) {
			[self submitTask:webView.request.URL.absoluteString withBlock:^(id responseObject, NSError *error) {
				if (error) {
					NSLog(@"submit task error: %@", error);
				} else {
					NSLog(@"submit success");
				}
			}];
		}
	}
}


@end
