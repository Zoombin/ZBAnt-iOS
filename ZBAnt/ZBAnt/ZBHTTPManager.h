//
//  HTTPManager.h
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBHTTPManager : NSObject


extern NSString * const WEIBOYI;
extern NSString * const NEWRANK;
extern NSString * const GSDATA;

+ (instancetype)shared;
- (void)statistics:(NSString *)channel type:(NSString *)type withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)settings:(NSString *)channel withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)save:(NSString *)channel outerIp:(NSString *)outerIp settings:(NSDictionary *)settings withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)captcha:(NSString *)outerIp withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)login:(NSString *)outerIp code:(NSString *)code withBlock:(void (^)(id responseObject, NSError *error))block;
- (NSString *)adminLoginUrlStringWithOuterIp:(NSString *)outerIp;

@end
