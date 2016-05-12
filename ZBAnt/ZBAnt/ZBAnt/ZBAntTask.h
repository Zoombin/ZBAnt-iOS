//
//  ZBAntTask.h
//  ZBAnt
//
//  Created by zhangbin on 4/4/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBAntTask : NSObject

#pragma mark - base
@property (nonatomic, strong) NSString *Id;
@property (nonatomic, strong) NSString *openId;
@property (nonatomic, strong) NSString *url;

#pragma mark - weixin

@property (nonatomic, strong) NSString *clickCode;

@property (nonatomic, strong) NSString *nameCode;
@property (nonatomic, strong) NSString *thumbCode;
@property (nonatomic, strong) NSString *summaryCode;
@property (nonatomic, strong) NSString *ownerCode;

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *thumb;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *owner;

#pragma mark - article

@property (nonatomic, strong) NSString *articleClickCode;
@property (nonatomic, strong) NSString *articleReadCountCode;

@property (nonatomic, strong) NSString *articleTitleCode;
@property (nonatomic, strong) NSString *articleSummaryCode;
@property (nonatomic, strong) NSString *articleTimestampCode;
@property (nonatomic, strong) NSString *articleThumbCode;

@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *articleSummary;
@property (nonatomic, strong) NSString *articleTimestamp;
@property (nonatomic, strong) NSString *articleThumb;

@property (nonatomic, strong) NSString *articleUrl;
@property (nonatomic, strong) NSString *articleReadCount;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
