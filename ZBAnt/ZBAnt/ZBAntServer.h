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

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;
- (NSDictionary *)settings;
+ (NSString *)onOrOff:(NSNumber *)onOrOff;
+ (UIColor *)colorOnOrOff:(NSNumber *)onOrOff;

@end
