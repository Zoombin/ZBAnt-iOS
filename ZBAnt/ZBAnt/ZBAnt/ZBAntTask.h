//
//  ZBAntTask.h
//  ZBAnt
//
//  Created by zhangbin on 4/4/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZBAntTaskType) {
	ZBAntTaskTypeWechat,
	ZBAntTaskTypeArticle
};

@interface ZBAntTask : NSObject

@property(nonatomic, assign) ZBAntTaskType taskType;

#pragma mark - base
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *type;

#pragma mark - query data
@property (nonatomic, strong) NSString *wechatIdentifier;
@property (nonatomic, strong) NSString *wechatName;
@property (nonatomic, strong) NSString *wechatImage;
@property (nonatomic, strong) NSString *wechatSummary;
@property (nonatomic, strong) NSString *wechatAuthentication;
@property (nonatomic, strong) NSString *wechatUrl;

#pragma mark - article data
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleSummary;
@property (nonatomic, strong) NSString *articleTimestamp;
@property (nonatomic, strong) NSString *articleImage;
@property (nonatomic, strong) NSString *articleUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
