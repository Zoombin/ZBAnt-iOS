//
//  ZBAntServer.m
//  ZBAnt
//
//  Created by zhangbin on 9/18/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBAntServer.h"
#import "ZBHTTPManager.h"

@implementation ZBAntServer

- (instancetype)initWithDictionary:(NSDictionary *)dictionary channel:(NSString *)channel {
	self = [super init];
	if (self) {
		if ([channel isEqualToString:WEIBOYI]) {
			_status = dictionary[@"status"];
			_innerIp = dictionary[@"innerIp"];
			_outerIp = dictionary[@"outerIp"];
			_inChargeOfReloadTasks = dictionary[@"inChargeOfReloadTasks"];
			_inChargeOfReloadTasksDeep = dictionary[@"inChargeOfReloadTasksDeep"];
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
			_grabArticlesDeepJobOn = dictionary[@"grabArticlesDeepJobOn"];
			_grabArticlesDeepJobInterval = dictionary[@"grabArticlesDeepJobInterval"];
			_sjArticlesDeepVar = dictionary[@"sjArticlesDeepVar"];
		} else if ([channel isEqualToString:NEWRANK]) {
			_nkGrabArticlesJobInterval = dictionary[@"grabArticlesJobInterval"];
			_nkGrabArticlesJobOn = dictionary[@"grabArticlesJobOn"];
			_nkGrabDetailsJobInterval = dictionary[@"grabDetailsJobInterval"];
			_nkGrabDetailsJobOn = dictionary[@"grabDetailsJobOn"];
			_nkProcessArticlesJobInterval = dictionary[@"processArticlesJobInterval"];
			_nkProcessArticlesJobOn = dictionary[@"processArticlesJobOn"];
			_nkProcessDetailsJobInterval = dictionary[@"processDetailsJobInterval"];
			_nkProcessDetailsJobOn = dictionary[@"processDetailsJobOn"];
			_nkInChargeOfReloadArticlesTasks = dictionary[@"inChargeOfReloadArticlesTasks"];
			_nkInChargeOfReloadDetailsTasks = dictionary[@"inChargeOfReloadDetailsTasks"];
		} else if ([channel isEqualToString:GSDATA]) {
			_gsGrabRankJobOn = dictionary[@"grabRankJobOn"];
			_gsGrabRankJobInterval = dictionary[@"grabRankJobInterval"];
			_gsInchargeOfReloadRankTasks = dictionary[@"inChargeOfReloadRankTasks"];
			_gsProcessRankJobOn = dictionary[@"processRankJobOn"];
			_gsProcessRankJobInterval = dictionary[@"processRankJobInterval"];
		}
	}
	return self;
}

- (NSDictionary *)settings {
	NSMutableDictionary *settings = [@{} mutableCopy];
	
	settings[@"inChargeOfReloadTasks"] = [self trueOrFalseString:_inChargeOfReloadTasks];
	settings[@"inChargeOfReloadTasksDeep"] = [self trueOrFalseString:_inChargeOfReloadTasksDeep];
	
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

	settings[@"grabArticlesDeepJobOn"] = [self trueOrFalseString:_grabArticlesDeepJobOn];
	settings[@"grabArticlesDeepJobInterval"] = _grabArticlesDeepJobInterval;
	return settings;
}

- (NSDictionary *)settings2 {
	NSMutableDictionary *settings2 = [@{} mutableCopy];
	settings2[@"processArticlesJobOn"] = [self trueOrFalseString:_nkProcessArticlesJobOn];
	settings2[@"processArticlesJobInterval"] = _nkProcessArticlesJobInterval;
	
	settings2[@"processDetailsJobOn"] = [self trueOrFalseString:_nkProcessDetailsJobOn];
	settings2[@"processDetailsJobInterval"] = _nkProcessDetailsJobInterval;
	
	settings2[@"grabArticlesJobOn"] = [self trueOrFalseString:_nkGrabArticlesJobOn];
	settings2[@"grabArticlesJobInterval"] = _nkGrabArticlesJobInterval;
	
	settings2[@"grabDetailsJobOn"] = [self trueOrFalseString:_nkGrabDetailsJobOn];
	settings2[@"grabDetailsJobInterval"] = _nkGrabDetailsJobInterval;
	
	settings2[@"inChargeOfReloadArticlesTasks"] = [self trueOrFalseString:_nkInChargeOfReloadArticlesTasks];
	settings2[@"inChargeOfReloadDetailsTasks"] = [self trueOrFalseString:_nkInChargeOfReloadDetailsTasks];
	return settings2;
}

- (NSDictionary *)settings3 {
	NSMutableDictionary *settings3 = [@{} mutableCopy];
	settings3[@"grabRankJobOn"] = [self trueOrFalseString:_gsGrabRankJobOn];
	settings3[@"grabRankJobInterval"] = _gsGrabRankJobInterval;
	settings3[@"inChargeOfReloadRankTasks"] = [self trueOrFalseString:_gsInchargeOfReloadRankTasks];
	settings3[@"processRankJobOn"] = [self trueOrFalseString:_gsProcessRankJobOn];
	settings3[@"processRankJobInterval"] = _gsProcessRankJobInterval;
	return settings3;

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
	} else if ([outerIp isEqualToString:@"115.29.145.52"]) {
		return @"ant7";
	} else if ([outerIp isEqualToString:@"115.29.138.228"]) {
		return @"ant8";
	} else if ([outerIp isEqualToString:@"139.196.33.46"]) {
		return @"ant9";
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
