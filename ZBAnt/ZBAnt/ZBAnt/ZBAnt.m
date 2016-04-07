//
//  ZBAnt.m
//  Facechat
//
//  Created by zhangbin on 12/29/15.
//  Copyright © 2015 zoombin. All rights reserved.
//

#import "ZBAnt.h"
#import "ZBAntTask.h"

//NSString * const HOME_URL_STRING = @"http://localhost:3030/admin/";
NSString * const HOME_URL_STRING = @"http://112.124.98.9:3030/admin/";

@interface ZBAnt () <UIWebViewDelegate>

@property (nonatomic, readwrite) UIWebView *webView;
@property (nonatomic, readwrite) NSTimer *timer;
@property (nonatomic, readwrite) ZBAntTask *task;

@end

@implementation ZBAnt

- (void)fetchTaskWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOME_URL_STRING, @"gettask"]];
	NSURLSessionDataTask *getTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		if (!error) {
			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			if (block) block(json, nil);
		} else {
			if (block) block(nil, error);
		}
	}];
	[getTask resume];
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
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOME_URL_STRING, @"dopostdatasingle"]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.HTTPMethod = @"POST";
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
	[request setHTTPBody:postData];

	NSURLSessionDataTask *postTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (!error) {
			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			if (block) block(json, nil);
		} else {
			if (block) block(nil, error);
		}
	}];
	[postTask resume];
}

- (void)start {
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	_webView.delegate = self;
	
	[self fetchTaskWithBlock:^(id responseObject, NSError *error) {
		if (!error) {
			NSLog(@"response: %@", responseObject);
			NSNumber *error = responseObject[@"error"];
			if (error.integerValue == 0) {
				_task = [[ZBAntTask alloc] initWithDictionary:responseObject[@"data"]];
				[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_task.URLString]]];
			} else {
				NSLog(@"task error: %@", responseObject[@"msg"]);
			}
		}
	}];
}

- (void)autoClick {
	NSLog(@"autoClick");
	
	NSString *titleCode = @"document.getElementById('sogou_vr_11002601_title_0').innerHTML";
	_task.resultTitle = [_webView stringByEvaluatingJavaScriptFromString:titleCode];
	
	NSString *summaryCode = @"document.getElementById('sogou_vr_11002601_summary_0').innerHTML";
	_task.resultSummary = [_webView stringByEvaluatingJavaScriptFromString:summaryCode];
	
	NSString *timestampCode = @"document.getElementById('sogou_vr_11002601_box_0').getElementsByTagName('div')[1].getElementsByTagName('div')[0].getAttribute('t')";
	_task.resultTimestamp = [_webView stringByEvaluatingJavaScriptFromString:timestampCode];

	NSString *imageCode = @"document.getElementById('sogou_vr_11002601_img_0').getElementsByTagName('img')[0].src";
	_task.resultImage = [_webView stringByEvaluatingJavaScriptFromString:imageCode];
	
	NSString *clickCode = @"document.getElementById('sogou_vr_11002601_title_0').click()";
	[_webView stringByEvaluatingJavaScriptFromString:clickCode];
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
		
		if (_task.ID && _task.URLString) {
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
