//
//  HTTPManager.m
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBHTTPManager.h"
#import "AFNetworking.h"

NSString * const BASE_URL_STRING = @"http://localhost:3000/api/weiboyi/";
//NSString * const BASE_URL_STRING = @"http://ant.zoombin.com:3008/api/weiboyi/";

static ZBHTTPManager *httpManager;
static AFHTTPRequestOperationManager *manager;

@implementation ZBHTTPManager

+ (instancetype)shared {
	if (!httpManager) {
		httpManager = [[ZBHTTPManager alloc] init];
		manager = [AFHTTPRequestOperationManager manager];
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

//	NSURLSessionDataTask *getTask = [[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//		if (!error) {
//			NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//			if (block) block(json, nil);
//		} else {
//			if (block) block(nil, error);
//		}
//	}];
//	[getTask resume];
}

@end
