//
//  ZBServersViewController.m
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBServersViewController.h"
#import "ZBHTTPManager.h"
#import "ZBSettingsDetailsViewController.h"
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

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	[self refresh];
}

- (void)refresh {
	[[ZBHTTPManager shared] serversWithBlock:^(id responseObject, NSError *error) {
		if (error) return;
		NSLog(@"responseObject: %@", responseObject);
		_servers = [NSArray arrayWithArray:responseObject[@"data"]];
		[_tableView reloadData];
	}];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _servers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
	ZBAntServer *server = [[ZBAntServer alloc] initWithAttribues:_servers[indexPath.row]];
	NSMutableString *string = [NSMutableString string];
	[string appendString:server.name];
	[string appendString:@"\n"];
	[string appendFormat:@"outerIP: %@", server.outerIp];
	[string appendString:@"\n"];
	[string appendFormat:@"innerIp: %@", server.innerIp];
	[string appendString:@"\n"];
	[string appendFormat:@"active: %@", [ZBAntServer onOrOff:server.active]];
	[string appendString:@"\n"];
	[string appendFormat:@"master: %@", [ZBAntServer onOrOff:server.master]];
	cell.textLabel.text = string;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [UIFont systemFontOfSize:13];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//	ZBAntServer *server = [[ZBAntServer alloc] initWithDictionary:_channelData[indexPath.row] channel:_selectedChannel];
//	ZBSettingsDetailsViewController *settingsDetailsViewController = [[ZBSettingsDetailsViewController alloc] init];
//	settingsDetailsViewController.server = server;
//	settingsDetailsViewController.channel = _selectedChannel;
//	settingsDetailsViewController.hidesBottomBarWhenPushed = YES;
//	[self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:settingsDetailsViewController ] animated:YES completion:nil];
}

@end
