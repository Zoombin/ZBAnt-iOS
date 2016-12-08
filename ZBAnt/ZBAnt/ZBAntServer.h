//
//  ZBAntServer.h
//  ZBAnt
//
//  Created by zhangbin on 9/18/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZBAntServer : NSObject

@property (nonatomic, copy) NSString *domain;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *innerIp;
@property (nonatomic, copy) NSString *outerIp;
@property (nonatomic, copy) NSNumber *active;
@property (nonatomic, copy) NSNumber *master;

@property (nonatomic, copy) NSNumber *inChargeOfReloadTasks;
@property (nonatomic, copy) NSNumber *inChargeOfReloadTasksDeep;
@property (nonatomic, copy) NSNumber *grabWeixinsJobOn;
@property (nonatomic, copy) NSNumber *grabWeixinsJobInterval;
@property (nonatomic, copy) NSNumber *grabArticlesJobOn;
@property (nonatomic, copy) NSNumber *grabArticlesJobInterval;
@property (nonatomic, copy) NSNumber *processWeixinsJobOn;
@property (nonatomic, copy) NSNumber *processWeixinsJobInterval;
@property (nonatomic, copy) NSNumber *processArticlesJobOn;
@property (nonatomic, copy) NSNumber *processArticlesJobInterval;
@property (nonatomic, copy) NSNumber *sjMasterVar;
@property (nonatomic, copy) NSNumber *sjWeixinsVar;
@property (nonatomic, copy) NSNumber *sjArticlesVar;
@property (nonatomic, copy) NSNumber *sjProcessWeixinsVar;
@property (nonatomic, copy) NSNumber *sjProcessArticlesVar;

@property (nonatomic, copy) NSNumber *grabArticlesDeepJobOn;
@property (nonatomic, copy) NSNumber *grabArticlesDeepJobInterval;
@property (nonatomic, copy) NSNumber *sjArticlesDeepVar;

//newrank
@property (nonatomic, copy) NSNumber *nkGrabArticlesJobInterval;
@property (nonatomic, copy) NSNumber *nkGrabArticlesJobOn;
@property (nonatomic, copy) NSNumber *nkGrabDetailsJobInterval;
@property (nonatomic, copy) NSNumber *nkGrabDetailsJobOn;
@property (nonatomic, copy) NSNumber *nkProcessArticlesJobInterval;
@property (nonatomic, copy) NSNumber *nkProcessArticlesJobOn;
@property (nonatomic, copy) NSNumber *nkProcessDetailsJobInterval;
@property (nonatomic, copy) NSNumber *nkProcessDetailsJobOn;
@property (nonatomic, copy) NSNumber *nkInChargeOfReloadArticlesTasks;
@property (nonatomic, copy) NSNumber *nkInChargeOfReloadDetailsTasks;

//gsdata
@property (nonatomic, copy) NSNumber *gsGrabRankJobOn;
@property (nonatomic, copy) NSNumber *gsGrabRankJobInterval;
@property (nonatomic, copy) NSNumber *gsInchargeOfReloadRankTasks;
@property (nonatomic, copy) NSNumber *gsProcessRankJobOn;
@property (nonatomic, copy) NSNumber *gsProcessRankJobInterval;

- (instancetype)initWithAttribues:(NSDictionary *)dictionary;
- (instancetype)initWithDictionary:(NSDictionary *)dictionary channel:(NSString *)channel;
- (NSDictionary *)baseSettings;
- (NSDictionary *)settings;
- (NSDictionary *)settings2;
- (NSDictionary *)settings3;
+ (NSString *)onOrOff:(NSNumber *)onOrOff;
+ (UIColor *)colorOnOrOff:(NSNumber *)onOrOff;

@end
