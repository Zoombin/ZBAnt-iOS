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
- (void)settingsWithBlock:(void (^)(id responseObject, NSError *error))block;
- (void)save:(NSString *)outerIp settings:(NSDictionary *)settings withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)captcha:(NSString *)outerIp withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)login:(NSString *)outerIp code:(NSString *)code withBlock:(void (^)(id responseObject, NSError *error))block;
- (NSString *)adminLoginUrlStringWithOuterIp:(NSString *)outerIp;

@end
