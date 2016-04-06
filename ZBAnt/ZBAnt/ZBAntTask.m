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
		_URLString = dictionary[@"url"];
		_number = dictionary[@"number"];
	}
	return self;
}

@end
