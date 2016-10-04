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

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSNumber *status;
@property (nonatomic, copy) NSString *innerIp;
@property (nonatomic, copy) NSString *outerIp;
@property (nonatomic, copy) NSNumber *inChargeOfReloadTasks;
@property (nonatomic, copy) NSNumber *inChargeOfReloadTasksDeep;
@property (nonatomic, copy) NSNumber *masterJobOn;
@property (nonatomic, copy) NSNumber *masterJobInterval;
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


- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)settings;
- (NSDictionary *)settings2;
- (void)setNewrankData:(NSDictionary *)data;
+ (NSString *)onOrOff:(NSNumber *)onOrOff;
+ (UIColor *)colorOnOrOff:(NSNumber *)onOrOff;

@end
