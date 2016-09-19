//
//  ZBAntServer.m
//  ZBAnt
//
//  Created by zhangbin on 9/18/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBAntServer.h"

@implementation ZBAntServer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		_status = dictionary[@"status"];
		_innerIp = dictionary[@"innerIp"];
		_outerIp = dictionary[@"outerIp"];
		_inChargeOfReloadTasks = dictionary[@"inChargeOfReloadTasks"];
		_masterJobOn = dictionary[@"masterJobOn"];
		_masterJobInterval = dictionary[@"masterJobInterval"];
		_grabWeixinsJobOn = dictionary[@"grabWeixinsJobOn"];
		_grabWeixinsJobInterval = dictionary[@"grabWeixinsJobInterval"];
		_grabArticlesJobOn = dictionary[@"grabArticlesJobOn"];
		_grabArticlesJobInterval = dictionary[@"grabArticlesJobInterval"];
		_processWeixinsJobOn = dictionary[@"processWeixinsJobOn"];
		_processWeixinsJobInterval = dictionary[@"processWeixinsJobInterval"];
		_processArticlesJobOn = dictionary[@"processArticlesJobOn"];
		_processArticlesJobInterval = dictionary[@"processArticlesJobInterval"];
		_sjMasterVar = dictionary[@"sjMasterVar"];
		_sjWeixinsVar = dictionary[@"sjWeixinsVar"];
		_sjArticlesVar = dictionary[@"sjArticlesVar"];
		_sjProcessWeixinsVar = dictionary[@"sjProcessWeixinsVar"];
		_sjProcessArticlesVar = dictionary[@"sjProcessArticlesVar"];
		_name = [self nameWithOuterIp:_outerIp];
	}
	return self;
}

- (NSDictionary *)settings {
	NSMutableDictionary *settings = [@{} mutableCopy];
	
	settings[@"inChargeOfReloadTasks"] = [self trueOrFalseString:_inChargeOfReloadTasks];
	
	settings[@"masterJobOn"] = [self trueOrFalseString:_masterJobOn];
	settings[@"masterJobInterval"] = _masterJobInterval;
	
	settings[@"grabWeixinsJobOn"] = [self trueOrFalseString:_grabWeixinsJobOn];
	settings[@"grabWeixinsJobInterval"] = _grabWeixinsJobInterval;
	
	settings[@"grabArticlesJobOn"] = [self trueOrFalseString:_grabArticlesJobOn];
	settings[@"grabArticlesJobInterval"] = _grabArticlesJobInterval;
	
	settings[@"processWeixinsJobOn"] = [self trueOrFalseString:_processWeixinsJobOn];
	settings[@"processWeixinsJobInterval"] = _processWeixinsJobInterval;
	
	settings[@"processArticlesJobOn"] = [self trueOrFalseString:_processArticlesJobOn];
	settings[@"processArticlesJobInterval"] = _processArticlesJobInterval;
	return settings;
}

- (NSString *)trueOrFalseString:(NSNumber *)number {
	return [number boolValue] ? @"true" : @"false";
}

- (NSString *)nameWithOuterIp:(NSString *)outerIp {
	if ([outerIp isEqualToString:@"121.199.29.134"]) {
		return @"ant1";
	} else if ([outerIp isEqualToString:@"139.196.185.42"]) {
		return @"ant2";
	} else if ([outerIp isEqualToString:@"139.224.72.238"]) {
		return @"ant3";
	} else if ([outerIp isEqualToString:@"139.224.72.56"]) {
		return @"ant4";
	} else if ([outerIp isEqualToString:@"115.28.202.112"]) {
		return @"ant5";
	} else if ([outerIp isEqualToString:@"115.29.136.212"]) {
		return @"ant6";
	}
	return outerIp;
}

+ (NSString *)onOrOff:(NSNumber *)number {
	return [number boolValue] ? @"On" : @"Off";
}

+ (UIColor *)colorOnOrOff:(NSNumber *)number {
	return [number boolValue] ? [UIColor greenColor] : [UIColor redColor];
}


@end
