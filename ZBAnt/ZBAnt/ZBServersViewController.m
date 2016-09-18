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
@property (nonatomic, readwrite) NSArray *servers;

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

- (void)loadData {
	[[ZBHTTPManager shared] settingsWithBlock:^(id responseObject, NSError *error) {
		if (!error) {
			if (responseObject[@"data"]) {
				_servers = [NSArray arrayWithArray:responseObject[@"data"]];
				[_tableView reloadData];
			}
		}
	}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 130;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _servers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
	ZBAntServer *server = [[ZBAntServer alloc] initWithDictionary:_servers[indexPath.row]];
	NSMutableString *string = [NSMutableString string];
	[string appendString:server.name];
	[string appendString:@"    "];
	
	[string appendFormat:@"status: %@", [server.status boolValue] ? @"正常" : @"异常"];
	cell.textLabel.textColor = [server.status boolValue] ? [UIColor blackColor] : [UIColor orangeColor];
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
	cell.textLabel.text = string;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [UIFont systemFontOfSize:13];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ZBAntServer *server = [[ZBAntServer alloc] initWithDictionary:_servers[indexPath.row]];
	ZBServerSettingsViewController *serverSettingsViewController = [[ZBServerSettingsViewController alloc] init];
	serverSettingsViewController.server = server;
	serverSettingsViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:serverSettingsViewController ] animated:YES completion:nil];
}

@end
