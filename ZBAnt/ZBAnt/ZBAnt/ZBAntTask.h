//
//  ZBAntTask.h
//  ZBAnt
//
//  Created by zhangbin on 4/4/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBAntTask : NSObject

@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *URLString;
@property (nonatomic, strong) NSString *number;
#pragma mark - result data
@property (nonatomic, strong) NSString *resultTitle;
@property (nonatomic, strong) NSString *resultSummary;
@property (nonatomic, strong) NSString *resultTimestamp;
@property (nonatomic, strong) NSString *resultImage;
@property (nonatomic, strong) NSString *resultURLString;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
