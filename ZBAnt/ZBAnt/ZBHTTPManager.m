//
//  HTTPManager.m
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBHTTPManager.h"
#import "AFNetworking.h"

//NSString * const HOST = @"http://localhost";
//NSString * const PORT = @"3000";
NSString * const HOST = @"http://ant.zoombin.com";
NSString * const PORT = @"3008";

static ZBHTTPManager *httpManager;
static AFHTTPRequestOperationManager *manager;
static NSString *BASE_URL_STRING;

@implementation ZBHTTPManager

+ (instancetype)shared {
	if (!httpManager) {
		httpManager = [[ZBHTTPManager alloc] init];
		manager = [AFHTTPRequestOperationManager manager];
		BASE_URL_STRING = [NSString stringWithFormat:@"%@:%@/api/weiboyi/", HOST, PORT];
	}
	return httpManager;
}

- (void)statisticsWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@%@", BASE_URL_STRING, @"statistics"];
	[manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (block) {
			block(responseObject, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)settingsWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@%@", BASE_URL_STRING, @"settings"];
	[manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (block) {
			block(responseObject, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)save:(NSString *)outerIp settings:(NSDictionary *)settings withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *baseUrlString = [NSString stringWithFormat:@"http://%@:%@/api/weiboyi/", outerIp, PORT];
	NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@%@", baseUrlString, @"settings"];
	[manager POST:requestUrl parameters:settings success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (block) {
			block(responseObject, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)captcha:(NSString *)outerIp withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *baseUrlString = [NSString stringWithFormat:@"http://%@:%@/api/weiboyi/", outerIp, PORT];
	NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@%@?isApi=true", baseUrlString, @"captcha"];
	[manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (block) {
			block(responseObject, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}

- (void)login:(NSString *)outerIp code:(NSString *)code withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *baseUrlString = [NSString stringWithFormat:@"http://%@:%@/api/weiboyi/", outerIp, PORT];
	NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@%@?captcha=%@", baseUrlString, @"login", code];
	[manager GET:requestUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
		if (block) {
			block(responseObject, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		if (block) {
			block(nil, error);
		}
	}];
}


@end
