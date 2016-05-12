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
		_openId = dictionary[@"openId"];
		_url = dictionary[@"url"];
		
		_clickCode = dictionary[@"clickCode"];
		
		_nameCode = dictionary[@"nameCode"];
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
