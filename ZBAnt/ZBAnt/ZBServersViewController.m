//
//  ZBServersViewController.m
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBServersViewController.h"
#import "ZBHTTPManager.h"
#import "ZBServerSettingsViewController.h"
#import "ZBAntServer.h"

static NSString *GAP = @"\t";

@interface ZBServersViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readwrite) UITableView *tableView;
@property (nonatomic, readwrite) NSArray *weiboyis;
@property (nonatomic, readwrite) NSArray *newranks;

@end

@implementation ZBServersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	[self loadData];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(loadData)];
}

- (NSDictionary *)newrankDataWithSameInnerIp:(NSString *)innerIp {
	for (int i = 0; i < _newranks.count; i++) {
		NSDictionary *dict = _newranks[i];
		if ([dict[@"innerIp"] isEqualToString:innerIp]) {
			return dict;
		}
	}
	return @{};
}

- (void)loadData {
	[[ZBHTTPManager shared] settings:WEIBOYI withBlock:^(id responseObject, NSError *error) {
		if (!error) {
			if (responseObject[@"data"]) {
				_weiboyis = [NSArray arrayWithArray:responseObject[@"data"]];
			}
			[[ZBHTTPManager shared] settings:NEWRANK withBlock:^(id responseObject, NSError *error) {
				if (!error) {
					if (responseObject[@"data"]) {
						_newranks = [NSArray arrayWithArray:responseObject[@"data"]];
						[_tableView reloadData];
					}
				}
			}];
		}
	}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 250;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _weiboyis.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
	ZBAntServer *server = [[ZBAntServer alloc] initWithDictionary:_weiboyis[indexPath.row]];
	NSDictionary *data = [self newrankDataWithSameInnerIp:server.innerIp];
	[server setNewrankData:data];
	
	NSMutableString *string = [NSMutableString string];
	[string appendString:server.name];
	[string appendString:@"    "];
	
	[string appendFormat:@"status: %@", [server.status boolValue] ? @"正常" : @"异常"];
	cell.textLabel.textColor = [server.status boolValue] ? [UIColor blackColor] : [UIColor orangeColor];
	[string appendString:@"    "];
	if ([server.inChargeOfReloadTasks boolValue]) {
		[string appendFormat:@"inChargeOfReloadTasks: %@", [ZBAntServer onOrOff:server.inChargeOfReloadTasks]];
	}
	if ([server.inChargeOfReloadTasksDeep boolValue]) {
		[string appendFormat:@"ReloadDeepTasks: %@", [ZBAntServer onOrOff:server.inChargeOfReloadTasksDeep]];
	}
	[string appendString:@"\n"];
	
	[string appendFormat:@"outerIP: %@", server.outerIp];
	[string appendString:@"    "];
	[string appendFormat:@"innerIp: %@", server.innerIp];
	[string appendString:@"\n"];
	
	[string appendFormat:@"masterJob: %@", [ZBAntServer onOrOff:server.masterJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"var: %@",  [ZBAntServer onOrOff:server.sjMasterVar]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.masterJobInterval];
	[string appendString:GAP];
	[string appendString:@"\n"];
	
	[string appendFormat:@"weixinsJob: %@", [ZBAntServer onOrOff:server.grabWeixinsJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"var: %@",  [ZBAntServer onOrOff:server.sjWeixinsVar]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.grabWeixinsJobInterval];
	[string appendString:@"\n"];
	
	[string appendFormat:@"articlesJob: %@", [ZBAntServer onOrOff:server.grabArticlesJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"var: %@",  [ZBAntServer onOrOff:server.sjArticlesVar]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.grabArticlesJobInterval];
	[string appendString:@"\n"];
	
	[string appendFormat:@"pWeixinsJob: %@", [ZBAntServer onOrOff:server.processWeixinsJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"var: %@",  [ZBAntServer onOrOff:server.sjProcessWeixinsVar]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.processWeixinsJobInterval];
	[string appendString:@"\n"];
	
	[string appendFormat:@"pArticlesJob: %@", [ZBAntServer onOrOff:server.processArticlesJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"var: %@",  [ZBAntServer onOrOff:server.sjProcessArticlesVar]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.processArticlesJobInterval];
	[string appendString:@"\n"];
	
	[string appendFormat:@"articlesDeep: %@", [ZBAntServer onOrOff:server.grabArticlesDeepJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"var: %@",  [ZBAntServer onOrOff:server.sjArticlesDeepVar]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.grabArticlesDeepJobInterval];
	[string appendString:@"\n"];
	[string appendString:@"\n"];
	

	//newrank
	[string appendFormat:@"nkGrabArticles: %@", [ZBAntServer onOrOff:server.nkGrabArticlesJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.nkGrabArticlesJobInterval];
	[string appendString:@"\n"];
	
	[string appendFormat:@"nkGrabDetails: %@", [ZBAntServer onOrOff:server.nkGrabDetailsJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.nkGrabDetailsJobInterval];
	[string appendString:@"\n"];
	
	[string appendFormat:@"nkProcessArticles: %@", [ZBAntServer onOrOff:server.nkProcessArticlesJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.nkProcessArticlesJobInterval];
	[string appendString:@"\n"];
	
	[string appendFormat:@"nkProcessDetails: %@", [ZBAntServer onOrOff:server.nkProcessDetailsJobOn]];
	[string appendString:GAP];
	[string appendFormat:@"interval: %@", server.nkProcessDetailsJobInterval];
	[string appendString:@"\n"];
	
	[string appendFormat:@"nkReloadArticles: %@", [ZBAntServer onOrOff:server.nkInChargeOfReloadArticlesTasks]];
	[string appendString:GAP];
	[string appendFormat:@"nkReloadDetails: %@", [ZBAntServer onOrOff:server.nkInChargeOfReloadDetailsTasks]];
	[string appendString:@"\n"];
	
	cell.textLabel.text = string;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [UIFont systemFontOfSize:13];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ZBAntServer *server = [[ZBAntServer alloc] initWithDictionary:_weiboyis[indexPath.row]];
	NSDictionary *data = [self newrankDataWithSameInnerIp:server.innerIp];
	[server setNewrankData:data];
	ZBServerSettingsViewController *serverSettingsViewController = [[ZBServerSettingsViewController alloc] init];
	serverSettingsViewController.server = server;
	serverSettingsViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:serverSettingsViewController ] animated:YES completion:nil];
}

@end
