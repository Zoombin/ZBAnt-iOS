//
//  HTTPManager.m
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBHTTPManager.h"
#import "AFNetworking.h"

NSString * const SECRET_KV = @"secret=18662606288";

//NSString * const SCHEME = @"http://";
//NSString * const HOST = @"localhost";
//NSString * const PORT = @"3000";

NSString * const SCHEME = @"https://";
NSString * const HOST = @"ant.zoombin.com";
NSString * const PORT = @"3008";

//NSString * const SCHEME = @"https://";
//NSString * const HOST = @"ant.zoombin.com";
//NSString * const PORT = @"4008";


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
		BASE_URL_STRING = [NSString stringWithFormat:@"%@%@:%@/api/", SCHEME, HOST, PORT];
	}
	return httpManager;
}

- (void)statistics:(NSString *)channel type:(NSString *)type withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@%@?type=%@&%@", BASE_URL_STRING, WEIBOYI, @"/statistics", type, SECRET_KV];
	if ([channel isEqualToString:NEWRANK]) {
		requestUrl = [NSString stringWithFormat:@"%@%@%@?type=%@&%@", BASE_URL_STRING, NEWRANK, @"/statistics", type, SECRET_KV];
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
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@%@?%@", BASE_URL_STRING, WEIBOYI, @"/settings", SECRET_KV];
	if ([channel isEqualToString:NEWRANK]) {
		requestUrl = [NSString stringWithFormat:@"%@%@%@?%@", BASE_URL_STRING, NEWRANK, @"/settings", SECRET_KV	];
	} else if ([channel isEqualToString:GSDATA]) {
		requestUrl = [NSString stringWithFormat:@"%@%@%@?%@", BASE_URL_STRING, GSDATA, @"/settings", SECRET_KV];
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

- (void)save:(NSString *)channel server:(ZBAntServer *)server settings:(NSDictionary *)settings withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *baseUrlString = [NSString stringWithFormat:@"%@%@:%@/api/weiboyi", SCHEME, server.domain, PORT];
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@?%@", baseUrlString, @"/settings", SECRET_KV];
	if ([channel isEqualToString:NEWRANK]) {
		baseUrlString = [NSString stringWithFormat:@"%@%@:%@/api/newrank", SCHEME, server.domain, PORT];
		requestUrl = [NSString stringWithFormat:@"%@%@?%@", baseUrlString, @"/settings", SECRET_KV];
	} else if ([channel isEqualToString:GSDATA]) {
		baseUrlString = [NSString stringWithFormat:@"%@%@:%@/api/gsdata", SCHEME, server.domain, PORT];
		requestUrl = [NSString stringWithFormat:@"%@%@?%@", baseUrlString, @"/settings", SECRET_KV];
	}
	
	NSLog(@"requestUrl: %@", requestUrl);
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

- (void)captcha:(ZBAntServer *)server withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *baseUrlString = [NSString stringWithFormat:@"%@%@:%@/api/weiboyi/", SCHEME, server.domain, PORT];
	NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@%@?isApi=true&%@", baseUrlString, @"captcha", SECRET_KV];
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

- (void)login:(ZBAntServer *)server code:(NSString *)code withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *baseUrlString = [NSString stringWithFormat:@"%@%@:%@/api/weiboyi/", SCHEME, server.domain, PORT];
	NSMutableString *requestUrl = [NSMutableString stringWithFormat:@"%@%@?captcha=%@&%@", baseUrlString, @"login", code, SECRET_KV];
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

- (NSString *)adminLoginUrlStringWithServer:(ZBAntServer *)server {
	NSString *urlString = [NSString stringWithFormat:@"%@%@:%@/admin/login?%@", SCHEME, server.domain, PORT, SECRET_KV];
	return urlString;
}


@end
