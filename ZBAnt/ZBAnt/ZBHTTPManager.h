//
//  HTTPManager.h
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZBAntServer.h"

@interface ZBHTTPManager : NSObject


extern NSString * const WEIBOYI;
extern NSString * const NEWRANK;
extern NSString * const GSDATA;

+ (instancetype)shared;
- (void)statistics:(NSString *)channel type:(NSString *)type withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)settings:(NSString *)channel withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)save:(NSString *)channel server:(ZBAntServer *)server settings:(NSDictionary *)settings withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)captcha:(ZBAntServer *)server withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)login:(ZBAntServer *)server code:(NSString *)code withBlock:(void (^)(id responseObject, NSError *error))block;
- (NSString *)adminLoginUrlStringWithServer:(ZBAntServer *)server;

@end
