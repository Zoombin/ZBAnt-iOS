//
//  ZBAntTask.h
//  ZBAnt
//
//  Created by zhangbin on 4/4/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZBAntTask : NSObject

@property (nonatomic, strong) NSNumber *error;
@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *URLString;
@property (nonatomic, strong) NSString *number;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

@end
