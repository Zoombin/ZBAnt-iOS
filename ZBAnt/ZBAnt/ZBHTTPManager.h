//
//  HTTPManager.h
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBHTTPManager : NSObject

+ (instancetype)shared;
- (void)statisticsWithBlock:(void (^)(id responseObject, NSError *error))block;

@end
