//
//  ZBAntTask.h
//  ZBAnt
//
//  Created by zhangbin on 4/4/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ZBAntTaskType) {
	ZBAntTaskTypeWeixin,
	ZBAntTaskTypeArticle
};

@interface ZBAntTask : NSObject

@property(nonatomic, assign) ZBAntTaskType taskType;

#pragma mark - base
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *type;

#pragma mark - query data

@property (nonatomic, strong) NSString *nameCode;
@property (nonatomic, strong) NSString *thumbCode;
@property (nonatomic, strong) NSString *openIdCode;
@property (nonatomic, strong) NSString *summaryCode;
@property (nonatomic, strong) NSString *ownerCode;
@property (nonatomic, strong) NSString *clickCode;

@property (nonatomic, strong) NSString *wechatOpenId;
@property (nonatomic, strong) NSString *wechatName;
@property (nonatomic, strong) NSString *wechatThumb;
@property (nonatomic, strong) NSString *wechatSummary;
@property (nonatomic, strong) NSString *wechatOwner;
@property (nonatomic, strong) NSString *wechatUrl;

#pragma mark - article data

@property (nonatomic, strong) NSString *articleTitleCode;
@property (nonatomic, strong) NSString *articleSummaryCode;
@property (nonatomic, strong) NSString *articleTimestampCode;
@property (nonatomic, strong) NSString *articleThumbCode;
@property (nonatomic, strong) NSString *articleClickCode;

@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleSummary;
@property (nonatomic, strong) NSString *articleTimestamp;
@property (nonatomic, strong) NSString *articleThumb;
@property (nonatomic, strong) NSString *articleUrl;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
