//
//  HTTPManager.m
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBHTTPManager.h"
#import "AFNetworking.h"
#import "NSString+AESCrypt.h"
#import "NSData+AESCrypt.h"


NSString * const SCHEME = @"http://";
NSString * const HOST = @"localhost";
NSString * const PORT = @"3000";
BOOL const NEED_CRYPT = NO;

//NSString * const SCHEME = @"https://";
//NSString * const HOST = @"ant.zoombin.com";
//NSString * const PORT = @"3008";
//BOOL const NEED_CRYPT = YES;

//NSString * const SCHEME = @"https://";
//NSString * const HOST = @"vultr-ant.zoombin.com";
//NSString * const PORT = @"4008";
//BOOL const NEED_CRYPT = YES;


NSString * const WEIBOYI = @"weiboyi";
NSString * const NEWRANK = @"newrank";
NSString * const GSDATA = @"gsdata";
NSString * const SECRET = @"18662606288";
NSString * const API_SECRET = @"4525df7a4b2111e68bab00ff8821fdcf";

static ZBHTTPManager *httpManager;
static AFURLSessionManager *manager;

@implementation ZBHTTPManager

+ (instancetype)shared {
	if (!httpManager) {
		httpManager = [[ZBHTTPManager alloc] init];
		NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
		manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
		manager.responseSerializer = [AFHTTPResponseSerializer serializer];
	}
	return httpManager;
}

- (NSString *)adminLoginUrlStringWithServer:(ZBAntServer *)server {
	NSString *urlString = [NSString stringWithFormat:@"%@%@:%@/admin/login", SCHEME, server.domain, PORT];
	NSLog(@"ping url: %@", urlString);
	return urlString;
}

- (id)decryptResponseObject:(id)responseObject {
	NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
	if (NEED_CRYPT) {
		string = [string AES256DecryptWithKey:API_SECRET];
	}
	NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
	NSLog(@"data: %@", data);
	id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
	return json;
}

- (void)startDataTaskWithUrlString:(NSString *)string params:(NSDictionary *)params andBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *urlString = NULL;
	if (NEED_CRYPT) {
		NSMutableDictionary *mParams = [[NSMutableDictionary alloc] initWithDictionary:params ?: @{}];
		mParams[@"secret"] = SECRET;
		NSData *jsonData = [NSJSONSerialization dataWithJSONObject:mParams options:0 error:nil];
		NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
		NSLog(@"jsonString: %@", jsonString);
		jsonString = [jsonString AES256EncryptWithKey:API_SECRET];
		NSString *encodedString = [jsonString stringByAddingPercentEncodingWithAllowedCharacters:[[NSCharacterSet characterSetWithCharactersInString:@"/+=\n"] invertedSet]];
		NSLog(@"encodedString: %@", encodedString);
		urlString = [NSString stringWithFormat:@"%@?edata=%@", string, encodedString];
	} else {
		NSMutableString *url = [NSMutableString stringWithString:string];
		[url appendString:@"?"];
		for (NSString *key in params) {
			NSString *value = params[key];
			[url appendFormat:@"%@=%@&", key, value];
		}
		[url appendFormat:@"secret=%@", SECRET];
		urlString = [NSString stringWithString:url];
		NSLog(@"urlString: %@", urlString);
	}
	
	
	NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
	NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
		NSLog(@"responseObject: %@", responseObject);
		if (error) {
			NSLog(@"error: %@", error);
			if (block) block(nil, error);
		} else {
			id json = [self decryptResponseObject:responseObject];
			NSLog(@"json: %@", json);
			if (block) block(json, nil);
		}
	}];
	[dataTask resume];
}

- (NSString *)baseUrlStringWithDomain:(NSString *)domain channel:(NSString *)channel prefix:(NSString *)prefix {
	domain = domain ?: HOST;
	prefix = prefix ?: @"";
	return [NSString stringWithFormat:@"%@%@:%@/%@/%@/%@", SCHEME, domain, PORT, @"api", channel, prefix];
}

- (void)statistics:(NSString *)channel type:(NSString *)type withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [self baseUrlStringWithDomain:nil channel:channel prefix:@"statistics"];
	[self startDataTaskWithUrlString:requestUrl params:@{@"type": type} andBlock:block];
}

- (void)settings:(NSString *)channel withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [self baseUrlStringWithDomain:nil channel:channel prefix:@"settings"];
	[self startDataTaskWithUrlString:requestUrl params:nil andBlock:block];
}

- (void)save:(NSString *)channel server:(ZBAntServer *)server settings:(NSDictionary *)settings withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [self baseUrlStringWithDomain:server.domain channel:channel prefix:@"saveSettings"];
	[self startDataTaskWithUrlString:requestUrl params:settings andBlock:block];
}

- (void)captcha:(ZBAntServer *)server withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [self baseUrlStringWithDomain:server.domain channel:WEIBOYI prefix:@"captcha"];
	[self startDataTaskWithUrlString:requestUrl params:nil andBlock:block];
}

- (void)login:(ZBAntServer *)server code:(NSString *)code withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [self baseUrlStringWithDomain:server.domain channel:WEIBOYI prefix:@"login"];
	[self startDataTaskWithUrlString:requestUrl params:@{@"captcha": code} andBlock:block];
}

- (void)serversWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@:%@/api/admin/servers", SCHEME, HOST, PORT];
	[self startDataTaskWithUrlString:requestUrl params:nil andBlock:block];
}

- (void)updateServer:(NSDictionary *)attributes upsert:(BOOL)upsert withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@:%@/api/admin/updateServer", SCHEME, HOST, PORT];
	if (upsert) {
		requestUrl = [NSString stringWithFormat:@"%@%@:%@/api/admin/addServer", SCHEME, HOST, PORT];
	}
	[self startDataTaskWithUrlString:requestUrl params:attributes andBlock:block];
}

- (void)removeServer:(NSString *)name withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@:%@/api/admin/removeServer", SCHEME, HOST, PORT];
	[self startDataTaskWithUrlString:requestUrl params:@{@"name": name} andBlock:block];
}

- (void)server:(NSString *)name hasWeiboyiSettingsWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@:%@/api/admin/serverHasWeiboyiSettings", SCHEME, HOST, PORT];
	[self startDataTaskWithUrlString:requestUrl params:@{@"name": name} andBlock:block];
}

- (void)createWeiboyiBaseSettings:(NSDictionary *)attributes withBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@:%@/api/weiboyi/createBaseSettings", SCHEME, HOST, PORT];
	[self startDataTaskWithUrlString:requestUrl params:attributes andBlock:block];
}

- (void)latestArticleWithBlock:(void (^)(id responseObject, NSError *error))block {
	NSString *requestUrl = [NSString stringWithFormat:@"%@%@:%@/api/latestArticle", SCHEME, HOST, PORT];
	[self startDataTaskWithUrlString:requestUrl params:nil andBlock:block];
}

@end
