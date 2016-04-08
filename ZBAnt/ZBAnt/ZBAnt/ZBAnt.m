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
			//NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];

			//TODO test data
			NSString *url = @"http://weixin.sogou.com/weixin?type=1&query=cydd0415";
			url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
			NSDictionary *data = @{@"url" : url, @"type": @"wechat", @"id": @"123123"};
			NSDictionary *json = @{@"data": data, @"error": @(0), @"msg": @""};
			
			if (block) block(json, nil);
		} else {
			if (block) block(nil, error);
		}
	}];
	[getTask resume];
}



- (void)submitTask:(NSString *)string withBlock:(void (^)(id responseObject, NSError *error))block {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"articleTitle"] = _task.articleTitle ?: @"";
	parameters[@"articleUrl"] = _task.articleUrl ?: @"";
	parameters[@"articleContent"] = _task.articleSummary ?: @"";
	parameters[@"articleUnixTime"] = _task.articleTimestamp ?: @"";
	parameters[@"articleImage"] = _task.articleImage ?: @"";
	parameters[@"url"] = _task.url;
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
				if (_task.ID && _task.url) {
					[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_task.url]]];
				}
			} else {
				NSLog(@"task error: %@", responseObject[@"msg"]);
			}
		}
	}];
}

- (void)autoClick {
	NSLog(@"autoClick");
	
	if (_task.taskType == ZBAntTaskTypeWechat) {
		NSString *nameCode = @"document.getElementById('sogou_vr_11002301_box_0').getElementsByTagName('div')[1].getElementsByTagName('h3')[0].innerHTML";
		NSString *name = [[_webView stringByEvaluatingJavaScriptFromString:nameCode] stringByStrippingHTML];
		NSLog(@"name: %@", name);
		
		NSString *imageCode = @"document.getElementById('sogou_vr_11002301_box_0').getElementsByTagName('div')[0].getElementsByTagName('img')[0].src";
		NSString *image = [_webView stringByEvaluatingJavaScriptFromString:imageCode];
		NSLog(@"image: %@", image);
		
		NSString *identifierCode = @"document.getElementById('sogou_vr_11002301_box_0').getElementsByTagName('div')[1].getElementsByTagName('h4')[0].getElementsByTagName('span')[0]. getElementsByTagName('label')[0].innerHTML";
		NSString *identifier = [_webView stringByEvaluatingJavaScriptFromString:identifierCode];
		NSLog(@"identifier: %@", identifier);
		
		NSString *summaryCode = @"document.getElementById('sogou_vr_11002301_box_0').getElementsByTagName('div')[1].getElementsByTagName('p')[0].getElementsByTagName('span')[1].innerHTML";
		NSString *summary = [[_webView stringByEvaluatingJavaScriptFromString:summaryCode] stringByStrippingHTML];
		NSLog(@"summary: %@", summary);
		
		NSString *authenticationCode = @"document.getElementById('sogou_vr_11002301_box_0').getElementsByTagName('div')[1].getElementsByTagName('p')[1].getElementsByTagName('span')[1].innerHTML";
		NSString *authentication = [_webView stringByEvaluatingJavaScriptFromString:authenticationCode];
		NSLog(@"authentication: %@", authentication);
		
		_task.wechatName = name;
		_task.wechatImage = image;
		_task.wechatSummary = summary;
		_task.wechatIdentifier = identifier;
		_task.wechatAuthentication = authentication;
		
		if (_task.wechatName.length) {
			NSString *clickCode = @"document.getElementById('sogou_vr_11002301_box_0').click()";
			[_webView stringByEvaluatingJavaScriptFromString:clickCode];
		}
	} else {
		NSString *titleCode = @"document.getElementById('sogou_vr_11002601_title_0').innerHTML";
		_task.articleTitle = [_webView stringByEvaluatingJavaScriptFromString:titleCode];
	
		NSString *summaryCode = @"document.getElementById('sogou_vr_11002601_summary_0').innerHTML";
		_task.articleSummary = [_webView stringByEvaluatingJavaScriptFromString:summaryCode];
	
		NSString *timestampCode = @"document.getElementById('sogou_vr_11002601_box_0').getElementsByTagName('div')[1].getElementsByTagName('div')[0].getAttribute('t')";
		_task.articleTimestamp = [_webView stringByEvaluatingJavaScriptFromString:timestampCode];
	
		NSString *imageCode = @"document.getElementById('sogou_vr_11002601_img_0').getElementsByTagName('img')[0].src";
		_task.articleImage = [_webView stringByEvaluatingJavaScriptFromString:imageCode];
		
		if (_task.articleTitle.length) {
			NSString *clickCode = @"document.getElementById('sogou_vr_11002601_title_0').click()";
			[_webView stringByEvaluatingJavaScriptFromString:clickCode];
		} else {//如果获取失败也需要返回给服务器
			[self submitTask:_webView.request.URL.absoluteString withBlock:^(id responseObject, NSError *error) {
				if (error) {
					NSLog(@"submit task error: %@", error);
				} else {
					NSLog(@"submit success");
				}
			}];
		}
	}
	

}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
	NSLog(@"webview error: %@", error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	if ([webView.request.URL.absoluteString containsString:@"weixin.sogou.com"]) {
		_timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoClick) userInfo:nil repeats:NO];
	}
	
	if ([webView.request.URL.absoluteString containsString:@"http://weixin.sogou.com/gzh?openid="]) {
		NSLog(@"openid url: %@", webView.request.URL.absoluteString);
	}
	
//	if ([webView.request.URL.absoluteString containsString:@"weixin.qq.com"]) {
//		_task.resultURLString = webView.request.URL.absoluteString;
//		
//		NSLog(@"title: %@, summary: %@, image: %@, timestamp: %@, url: %@", _task.resultTitle, _task.resultSummary, _task.resultImage, _task.resultTimestamp, _task.resultURLString);
//		
//		[self submitTask:_webView.request.URL.absoluteString withBlock:^(id responseObject, NSError *error) {
//			if (error) {
//				NSLog(@"submit task error: %@", error);
//			} else {
//				NSLog(@"submit success");
//			}
//		}];
//	}
}


@end
