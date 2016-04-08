//
//  NSString+HTML.m
//  ZBAnt
//
//  Created by zhangbin on 4/8/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "NSString+HTML.h"

@implementation NSString (HTML)

- (NSString *)stringByStrippingHTML {
	NSRange r;
	NSString *s = [self copy];
	while ((r = [s rangeOfString:@"<[^>]+>" options:NSRegularExpressionSearch]).location != NSNotFound)
		s = [s stringByReplacingCharactersInRange:r withString:@""];
	return s;
}

@end
