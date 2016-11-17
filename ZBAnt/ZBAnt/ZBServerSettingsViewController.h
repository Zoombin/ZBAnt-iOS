//
//  ZBServerSettingsViewController.h
//  ZBAnt
//
//  Created by zhangbin on 9/18/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZBAntServer.h"

@interface ZBServerSettingsViewController : UIViewController

@property (nonatomic, readwrite) ZBAntServer *server;
@property (nonatomic, readwrite) NSString *channel;

@end
