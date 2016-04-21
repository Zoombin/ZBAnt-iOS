//
//  ZBAnt.m
//  Facechat
//
//  Created by zhangbin on 12/29/15.
//  Copyright © 2015 zoombin. All rights reserved.
//

#import "ZBAnt.h"
#import "ZBAntTask.h"
#import "NSString+HTML.h"

NSString * const HOME_URL_STRING = @"http://localhost:3000/api/";
//NSString * const HOME_URL_STRING = @"http://112.124.98.9:3030/admin/";
NSString * const TASK_TYPE = @"task";

@interface ZBAnt () <UIWebViewDelegate>

@property (nonatomic, readwrite) UIWebView *webView;
@property (nonatomic, readwrite) NSTimer *timer;
@property (nonatomic, readwrite) ZBAntTask *task;

@end

@implementation ZBAnt

- (void)taskWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOME_URL_STRING, TASK_TYPE]];
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

- (void)start {
	_webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
	_webView.delegate = self;
	
	[self taskWithBlock:^(id responseObject, NSError *error) {
		if (!error) {
			NSLog(@"response: %@", responseObject);
			NSNumber *error = responseObject[@"error"];
			if (error.integerValue == 0) {
				_task = [[ZBAntTask alloc] initWithDictionary:responseObject[@"data"]];
				if (_task.Id.length && _task.url.length && _task.openId.length) {
					[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_task.url]]];
				}
			} else {
				NSLog(@"task error: %@", responseObject[@"message"]);
			}
		}
	}];
}

- (void)autoClickWeixin {
	NSLog(@"autoClickWeixin");
	[_webView stringByEvaluatingJavaScriptFromString:_task.clickCode];
}

- (void)autoClick {
	NSLog(@"autoClick");
	_task.name = [[_webView stringByEvaluatingJavaScriptFromString:_task.nameCode] stringByStrippingHTML];
	_task.name = [_task.name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	_task.name = [_task.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	_task.name = [_task.name stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	_task.thumb = [[_webView stringByEvaluatingJavaScriptFromString:_task.thumbCode] stringByStrippingHTML];
	_task.summary = [[_webView stringByEvaluatingJavaScriptFromString:_task.summaryCode] stringByStrippingHTML];
	_task.owner = [[_webView stringByEvaluatingJavaScriptFromString:_task.ownerCode] stringByStrippingHTML];
	
	_task.articleTitle = [[_webView stringByEvaluatingJavaScriptFromString:_task.articleTitleCode] stringByStrippingHTML];
	_task.articleTitle = [_task.articleTitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	_task.articleTitle = [_task.articleTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	_task.articleTitle = [_task.articleTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	_task.articleSummary = [[_webView stringByEvaluatingJavaScriptFromString:_task.articleSummaryCode] stringByStrippingHTML];
	_task.articleTimestamp = [[_webView stringByEvaluatingJavaScriptFromString:_task.articleTimestampCode] stringByStrippingHTML];
	_task.articleThumb = [[_webView stringByEvaluatingJavaScriptFromString:_task.articleThumbCode] stringByStrippingHTML];
	
	[_webView stringByEvaluatingJavaScriptFromString:_task.articleClickCode];
}

- (void)postTaskWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	
	parameters[@"id"] = _task.Id;
	parameters[@"openId"] = _task.openId;
	
	parameters[@"name"] = _task.name ?: @"";
	parameters[@"thumb"] = _task.thumb ?: @"";
	parameters[@"summary"] = _task.summary ?: @"";
	parameters[@"owner"] = _task.owner ?: @"";

	parameters[@"articleTitle"] = _task.articleTitle ?: @"";
	parameters[@"articleSummary"] = _task.articleSummary ?: @"";
	parameters[@"articleTimestamp"] = _task.articleTimestamp ?: @"";
	parameters[@"articleThumb"] = _task.articleThumb ?: @"";
	
	parameters[@"articleUrl"] = _task.articleUrl ?: @"";
	
	NSLog(@"articleTitle: %@", _task.articleTitle);
	NSLog(@"name: %@", _task.name);
	NSLog(@"articleSummary: %@", _task.articleSummary);
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOME_URL_STRING, TASK_TYPE]];
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

- (void)postAntispiderWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"id"] = _task.Id;
	parameters[@"openId"] = _task.openId;
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOME_URL_STRING, @"antispider"]];
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


#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"webview error: %@", error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSString *urlString = webView.request.URL.absoluteString;
	NSLog(@"did finish load: %@", urlString);
	
	if ([urlString containsString:@"antispider"]) {
		[self postAntispiderWithBlock:^(id responseObject, NSError *error) {
			
		}];
		return;
	}
	
	if ([urlString containsString:@"weixin.sogou.com/weixin?type=1&query="]) {//微信公众号查询
		[self autoClickWeixin];
	} else if ([urlString containsString:@"mp.weixin.qq.com/profile"]) {//微信公众号的页面（文章列表页）
		[self autoClick];
	} else if ([urlString containsString:@"mp.weixin.qq.com/s"]) {//图文页
		_task.articleUrl = urlString;
		[self postTaskWithBlock:^(id responseObject, NSError *error) {
			if (error) {
				NSLog(@"submit error: %@", error);
			} else {
				NSLog(@"submit success");
			}
		}];
	}
}


@end
