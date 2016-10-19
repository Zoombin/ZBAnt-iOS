//
//  HTTPManager.m
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBHTTPManager.h"
#import "AFNetworking.h"

NSString * const HOST = @"http://localhost";
NSString * const PORT = @"3000";
//NSString * const HOST = @"http://ant.zoombin.com";
//NSString * const PORT = @"3008";

NSString * const WEIBOYI = @"weiboyi";
NSString * const NEWRANK = @"newrank";
NSString * const GSDATA = @"gsdata";

static ZBHTTPManager *httpManager;
static AFHTTPRequestOperationManager *manager;
static NSString *BASE_URL_STRING;

@implementation ZBHTTPManager

+ (instancetype)shared {
	if (!httpManager) {
		httpManager = [[ZBHTTPManager alloc] init];
		manager = [AFHTTPRequestOperationManager manager];
		BASE_URL_STRING = [NSString stringWithFormat:@"%@:%@/api/", HOST, PORT];
	}
	return httpManager;
}

- (void)statistics:(NSString *)channel type:(NSString *)type withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@%@?type=%@", BASE_URL_STRING, WEIBOYI, @"/statistics", type];
	if ([channel isEqualToString:NEWRANK]) {
		requestUrl = [NSString stringWithFormat:@"%@%@%@?type=%@", BASE_URL_STRING, NEWRANK, @"/statistics", type];
	}
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

- (void)settings:(NSString *)channel withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@%@", BASE_URL_STRING, WEIBOYI, @"/settings"];
	if ([channel isEqualToString:NEWRANK]) {
		requestUrl = [NSString stringWithFormat:@"%@%@%@", BASE_URL_STRING, NEWRANK, @"/settings"];
	} else if ([channel isEqualToString:GSDATA]) {
		requestUrl = [NSString stringWithFormat:@"%@%@%@", BASE_URL_STRING, GSDATA, @"/settings"];
	}
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

- (void)save:(NSString *)channel outerIp:(NSString *)outerIp settings:(NSDictionary *)settings withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *baseUrlString = [NSString stringWithFormat:@"http://%@:%@/api/weiboyi", outerIp, PORT];
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@", baseUrlString, @"/settings"];
	if ([channel isEqualToString:NEWRANK]) {
		baseUrlString = [NSString stringWithFormat:@"http://%@:%@/api/newrank", outerIp, PORT];
		requestUrl = [NSString stringWithFormat:@"%@%@", baseUrlString, @"/settings"];
	} else if ([channel isEqualToString:GSDATA]) {
		baseUrlString = [NSString stringWithFormat:@"http://%@:%@/api/gsdata", outerIp, PORT];
		requestUrl = [NSString stringWithFormat:@"%@%@", baseUrlString, @"/settings"];
	}

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
		NSLog(@"responseObject: %@", responseObject);
		if (block) {
			block(responseObject, nil);
		}
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"captcha error: %@", error);
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

- (NSString *)adminLoginUrlStringWithOuterIp:(NSString *)outerIp {
	NSString *urlString = [NSString stringWithFormat:@"http://%@:%@/admin/login", outerIp, PORT];
	return urlString;
}


@end
