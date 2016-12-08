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
- (NSString *)adminLoginUrlStringWithServer:(ZBAntServer *)server;
- (void)statistics:(NSString *)channel type:(NSString *)type withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)settings:(NSString *)channel withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)save:(NSString *)channel server:(ZBAntServer *)server settings:(NSDictionary *)settings withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)captcha:(ZBAntServer *)server withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)login:(ZBAntServer *)server code:(NSString *)code withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)serversWithBlock:(void (^)(id responseObject, NSError *error))block;
- (void)updateServer:(NSDictionary *)attributes upsert:(BOOL)upsert withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)server:(NSString *)name hasWeiboyiSettingsWithBlock:(void (^)(id responseObject, NSError *error))block;
- (void)createWeiboyiBaseSettings:(NSDictionary *)attributes withBlock:(void (^)(id responseObject, NSError *error))block;
- (void)latestArticleWithBlock:(void (^)(id responseObject, NSError *error))block;

@end
