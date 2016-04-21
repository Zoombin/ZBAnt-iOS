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
		_Id = dictionary[@"id"];
		_url = dictionary[@"url"];
		_openId = dictionary[@"openId"];
		_type = dictionary[@"type"];
		
		if ([_type.lowercaseString isEqualToString:@"weixin"]) {
			_taskType = ZBAntTaskTypeWeixin;
			_nameCode = dictionary[@"nameCode"];
			_thumbCode = dictionary[@"thumbCode"];
			_openIdCode = dictionary[@"openIdCode"];
			_summaryCode = dictionary[@"summaryCode"];
			_ownerCode = dictionary[@"ownerCode"];
			_clickCode = dictionary[@"clickCode"];
		} else {
			_taskType = ZBAntTaskTypeArticle;
			_articleTitleCode = dictionary[@"articleTitleCode"];
			_articleThumbCode = dictionary[@"articleThumbCode"];
			_articleSummaryCode = dictionary[@"articleSummaryCode"];
			_articleTimestampCode = dictionary[@"articleTimestampCode"];
			_articleClickCode = dictionary[@"articleClickCode"];
		}
	}
	return self;
}

@end
