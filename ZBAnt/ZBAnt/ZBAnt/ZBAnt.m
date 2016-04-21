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
				if (_task.Id && _task.url) {
					[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_task.url]]];
				}
			} else {
				NSLog(@"task error: %@", responseObject[@"message"]);
			}
		}
	}];
}

- (void)autoClick {
	NSLog(@"autoClick");
	if (_task.taskType == ZBAntTaskTypeWeixin) {
		_task.wechatName = [[_webView stringByEvaluatingJavaScriptFromString:_task.nameCode] stringByStrippingHTML];
		_task.wechatThumb = [_webView stringByEvaluatingJavaScriptFromString:_task.thumbCode];
		_task.wechatSummary = [[_webView stringByEvaluatingJavaScriptFromString:_task.summaryCode] stringByStrippingHTML];
		_task.openId = [[_webView stringByEvaluatingJavaScriptFromString:_task.openIdCode] stringByStrippingHTML];
		_task.wechatOwner = [[_webView stringByEvaluatingJavaScriptFromString:_task.ownerCode] stringByStrippingHTML];
		[_webView stringByEvaluatingJavaScriptFromString:_task.clickCode];
	} else if (_task.taskType == ZBAntTaskTypeArticle) {
		_task.articleTitle = [_webView stringByEvaluatingJavaScriptFromString:_task.articleTitleCode];
		_task.articleSummary = [_webView stringByEvaluatingJavaScriptFromString:_task.articleSummaryCode];
		_task.articleTimestamp = [_webView stringByEvaluatingJavaScriptFromString:_task.articleTimestampCode];
		_task.articleThumb = [_webView stringByEvaluatingJavaScriptFromString:_task.articleThumbCode];
		[_webView stringByEvaluatingJavaScriptFromString:_task.articleClickCode];
	}
}

- (void)postTaskWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"type"] = _task.type;
	
	if (_task.taskType == ZBAntTaskTypeWeixin) {
		parameters[@"openId"] = _task.openId ?: @"";
		parameters[@"name"] = _task.wechatName ?: @"";
		parameters[@"thumb"] = _task.wechatThumb ?: @"";
		parameters[@"summary"] = _task.wechatSummary ?: @"";
		parameters[@"owner"] = _task.wechatOwner ?: @"";
		parameters[@"url"] = _task.wechatUrl ?: @"";
		parameters[@"id"] = _task.Id;
	} else {
		parameters[@"openId"] = _task.openId;
		parameters[@"articleTitle"] = _task.articleTitle ?: @"";
		parameters[@"articleUrl"] = _task.articleUrl ?: @"";
		parameters[@"articleSummary"] = _task.articleSummary ?: @"";
		parameters[@"articleTimestamp"] = _task.articleTimestamp ?: @"";
		parameters[@"articleThumb"] = _task.articleThumb ?: @"";
		parameters[@"url"] = _task.url;
		parameters[@"id"] = _task.Id;
	}
	
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
	parameters[@"type"] = _task.type;
	parameters[@"id"] = _task.Id;
	parameters[@"openId"] = _task.openId ?: @"";
	
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
	
	if (_task.taskType == ZBAntTaskTypeWeixin) {
		if ([urlString containsString:@"weixin.sogou.com/weixin"]) {//微信公众号信息页
			_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoClick) userInfo:nil repeats:NO];
		} else if ([urlString containsString:@"mp.weixin.qq.com/profile"]) {//微信公众号的页面（文章列表页）
			_task.wechatUrl = urlString;
			[self postTaskWithBlock:^(id responseObject, NSError *error) {
				if (error) {
					NSLog(@"submit error: %@", error);
				} else {
					NSLog(@"submit success");
				}
			}];
		}
	} else if (_task.taskType == ZBAntTaskTypeArticle) {
		if ([urlString containsString:@"mp.weixin.qq.com/profile"]) {
			_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoClick) userInfo:nil repeats:NO];
		} else if ([urlString containsString:@"mp.weixin.qq.com"]) {//微信公众号图文页
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
}


@end
