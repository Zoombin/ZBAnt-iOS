//
//  ZBAntTask.m
//  ZBAnt
//
//  Created by zhangbin on 4/4/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBAntTask.h"

@implementation ZBAntTask

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
	self = [super init];
	if (self) {
		_ID = dictionary[@"id"];
		_url = dictionary[@"url"];
		_number = dictionary[@"number"];
		_type = dictionary[@"type"];
		if ([_type.lowercaseString isEqualToString:@"wechat"]) {
			_taskType = ZBAntTaskTypeWechat;
		} else {
			_taskType = ZBAntTaskTypeArticle;
		}
	}
	return self;
}

@end
