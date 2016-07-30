//
//  ZBAnt.m
//  Facechat
//
//  Created by zhangbin on 12/29/15.
//  Copyright © 2015 zoombin. All rights reserved.
//

#import "ZBAnt.h"

//NSString * const HOME_URL_STRING = @"http://localhost:3000/api/";
NSString * const HOME_URL_STRING = @"http://ant.zoombin.com:3008/api/";
NSString * const TASK = @"task";
NSString * const VERSION = @"2";
BOOL const OPEN_LOG = NO;


#pragma mark - ZBAntTask

@interface ZBAntTask : NSObject

#pragma mark - base
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *openId;//服务器指派过来的
@property (nonatomic, strong) NSString *url;

#pragma mark - weixin

@property (nonatomic, strong) NSString *clickCode;

@property (nonatomic, strong) NSString *nameCode;
@property (nonatomic, strong) NSString *openIdStringCode;
@property (nonatomic, strong) NSString *thumbCode;
@property (nonatomic, strong) NSString *summaryCode;
@property (nonatomic, strong) NSString *ownerCode;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *openIdString;//抓到的
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *owner;

#pragma mark - article

@property (nonatomic, strong) NSString *articleClickCode;
@property (nonatomic, strong) NSString *articleReadCountCode;

@property (nonatomic, strong) NSString *articleTitleCode;
@property (nonatomic, strong) NSString *articleSummaryCode;
@property (nonatomic, strong) NSString *articleTimestampCode;
@property (nonatomic, strong) NSString *articleThumbCode;

@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleSummary;
@property (nonatomic, strong) NSString *articleTimestamp;
@property (nonatomic, strong) NSString *articleThumb;

@property (nonatomic, strong) NSString *articleUrl;
@property (nonatomic, strong) NSString *articleReadCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end

@implementation ZBAntTask

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		_Id = dictionary[@"id"];
		_openId = dictionary[@"openId"];
		_url = dictionary[@"url"];
		
		_clickCode = dictionary[@"clickCode"];
		
		_nameCode = dictionary[@"nameCode"];
		_openIdStringCode = dictionary[@"openIdStringCode"];
		_thumbCode = dictionary[@"thumbCode"];
		_summaryCode = dictionary[@"summaryCode"];
		_ownerCode = dictionary[@"ownerCode"];
		
		_articleClickCode = dictionary[@"articleClickCode"];
		_articleReadCountCode = dictionary[@"articleReadCountCode"];
		
		_articleTitleCode = dictionary[@"articleTitleCode"];
		_articleThumbCode = dictionary[@"articleThumbCode"];
		_articleSummaryCode = dictionary[@"articleSummaryCode"];
		_articleTimestampCode = dictionary[@"articleTimestampCode"];
	}
	return self;
}

@end

#pragma mark - ZBAnt



@interface ZBAnt () <UIWebViewDelegate>

@property (nonatomic, readwrite) UIWebView *webView;
@property (nonatomic, readwrite) NSTimer *timer;
@property (nonatomic, readwrite) ZBAntTask *task;

@end

@implementation ZBAnt


- (void)taskWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
	
	NSMutableString *urlString = [NSMutableString stringWithFormat:@"%@%@", HOME_URL_STRING, TASK];
	[urlString appendString:@"?"];
	[urlString appendString:@"&"];
	[urlString appendFormat:@"bundleId=%@", bundleId ?: @""];
	[urlString appendString:@"&"];
	[urlString appendFormat:@"version=%@", VERSION];
	
	NSURL *url = [NSURL URLWithString:urlString];
	
	NSURLSessionDataTask *getTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		if (!error) {
			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			if (OPEN_LOG) NSLog(@"get task response object: %@", json);
			NSNumber *error = json[@"error"];
			if (error.integerValue == 0) {
				_task = [[ZBAntTask alloc] initWithDictionary:json[@"data"]];
				if (_task.Id.length && _task.url.length && _task.openId.length) {
					[_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_task.url]]];
				}
			} else {
				if (OPEN_LOG) NSLog(@"task error: %@", json[@"message"]);
			}
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
	}];
}

- (void)autoClickWeixin {
	if (OPEN_LOG) NSLog(@"autoClickWeixin");
	[_webView stringByEvaluatingJavaScriptFromString:_task.clickCode];
}

- (void)autoClick {
	if (OPEN_LOG) NSLog(@"autoClick");
	_task.name = [self stringByStrippingHTML: [_webView stringByEvaluatingJavaScriptFromString:_task.nameCode]];
	_task.name = [_task.name stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	_task.name = [_task.name stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	_task.name = [_task.name stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	_task.openIdString = [self stringByStrippingHTML: [_webView stringByEvaluatingJavaScriptFromString:_task.openIdStringCode]];
	_task.thumb = [self stringByStrippingHTML: [_webView stringByEvaluatingJavaScriptFromString:_task.thumbCode]];
	_task.summary = [self stringByStrippingHTML: [_webView stringByEvaluatingJavaScriptFromString:_task.summaryCode]];
	_task.owner = [self stringByStrippingHTML: [_webView stringByEvaluatingJavaScriptFromString:_task.ownerCode]];
	
	_task.articleTitle = [self stringByStrippingHTML: [_webView stringByEvaluatingJavaScriptFromString:_task.articleTitleCode]];
	_task.articleTitle = [_task.articleTitle stringByReplacingOccurrencesOfString:@"\n" withString:@""];
	_task.articleTitle = [_task.articleTitle stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	_task.articleTitle = [_task.articleTitle stringByReplacingOccurrencesOfString:@" " withString:@""];
	
	_task.articleSummary = [self stringByStrippingHTML: [_webView stringByEvaluatingJavaScriptFromString:_task.articleSummaryCode]];
	_task.articleTimestamp = [self stringByStrippingHTML: [_webView stringByEvaluatingJavaScriptFromString:_task.articleTimestampCode]];
	_task.articleThumb = [self stringByStrippingHTML: [_webView stringByEvaluatingJavaScriptFromString:_task.articleThumbCode]];
	
	[_webView stringByEvaluatingJavaScriptFromString:_task.articleClickCode];
}

- (void)postTaskWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	parameters[@"id"] = _task.Id;
	parameters[@"openId"] = _task.openId;
	
	parameters[@"name"] = _task.name ?: @"";
	parameters[@"openIdString"] = _task.openIdString ?: @"";
	parameters[@"thumb"] = _task.thumb ?: @"";
	parameters[@"summary"] = _task.summary ?: @"";
	parameters[@"owner"] = _task.owner ?: @"";

	parameters[@"articleTitle"] = _task.articleTitle ?: @"";
	parameters[@"articleSummary"] = _task.articleSummary ?: @"";
	parameters[@"articleTimestamp"] = _task.articleTimestamp ?: @"";
	parameters[@"articleThumb"] = _task.articleThumb ?: @"";
	parameters[@"articleUrl"] = _task.articleUrl ?: @"";
	parameters[@"articleReadCount"] = _task.articleReadCount ?: @"";
	
	parameters[@"version"] = VERSION;
	
	if (OPEN_LOG) NSLog(@"submit params: %@", parameters);
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", HOME_URL_STRING, TASK]];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
	request.HTTPMethod = @"POST";
	[request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
	NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:0 error:nil];
	[request setHTTPBody:postData];
	
	NSURLSessionDataTask *postTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		if (!error) {
			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
			if (OPEN_LOG) NSLog(@"post task response: %@", json);
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
	if (OPEN_LOG) NSLog(@"webview error: %@", error);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	NSString *urlString = webView.request.URL.absoluteString;
//	NSLog(@"did finish load: %@", urlString);
	
	if ([urlString containsString:@"antispider"]) {
		[self postAntispiderWithBlock:^(id responseObject, NSError *error) {
			
		}];
		return;
	}
	
	if ([urlString containsString:@"weixin.sogou.com/weixin?type=1&query="]) {//微信公众号查询
		[self performSelector:@selector(autoClickWeixin) withObject:NULL afterDelay:1];
	} else if ([urlString containsString:@"mp.weixin.qq.com/profile"]) {//微信公众号的页面（文章列表页）
		[self performSelector:@selector(autoClick) withObject:NULL afterDelay:1];
	} else if ([urlString containsString:@"mp.weixin.qq.com/s"]) {//图文页
		_task.articleUrl = urlString;
		[self performSelector:@selector(readCount) withObject:NULL afterDelay:1];
		[self performSelector:@selector(doPostTask) withObject:NULL afterDelay:1.5];
	}
}

- (void)readCount {
	_task.articleReadCount = [_webView stringByEvaluatingJavaScriptFromString:_task.articleReadCountCode];
	if (OPEN_LOG) NSLog(@"read count: %@", _task.articleReadCount);
}

- (void)doPostTask {
	[self postTaskWithBlock:^(id responseObject, NSError *error) {
		if (error) {
			if (OPEN_LOG) NSLog(@"submit error: %@", error);
		} else {
			if (OPEN_LOG) NSLog(@"ant data submit success");
		}
	}];
}

#pragma mark - HTML method

- (NSString *)stringByStrippingHTML:(NSString *)string {
	NSRange r;
	NSString *s = [string copy];
	while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
		s = [s stringByReplacingCharactersInRange:r withString:@""];
	return s;
}

@end
