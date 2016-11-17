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
@property (nonatomic, readwrite) NSString *selectedChannel;
@property (nonatomic, readwrite) NSArray *channelData;
@end

@implementation ZBServersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh)];
	
	UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[WEIBOYI, NEWRANK, GSDATA]];
	segmentedControl.selectedSegmentIndex = 0;
	self.navigationItem.titleView = segmentedControl;
	[segmentedControl addTarget:self action:@selector(changeChannel:) forControlEvents:UIControlEventValueChanged];
	
	_selectedChannel = WEIBOYI;
	[self loadData:_selectedChannel];
}

- (void)refresh {
	[self loadData:_selectedChannel];
}

- (void)changeChannel:(UISegmentedControl *)segmentedControl {
	if (segmentedControl.selectedSegmentIndex == 0) {
		_selectedChannel = WEIBOYI;
	} else if (segmentedControl.selectedSegmentIndex == 1) {
		_selectedChannel = NEWRANK;
	} else if (segmentedControl.selectedSegmentIndex == 2) {
		_selectedChannel = GSDATA;
	}
	[self loadData:_selectedChannel];
}

- (void)loadData:(NSString *)channel {
	[[ZBHTTPManager shared] settings:channel withBlock:^(id responseObject, NSError *error) {
		if (error) return;
		NSLog(@"responseObject: %@", responseObject);
		_channelData = [NSArray arrayWithArray:responseObject[@"data"]];
		[_tableView reloadData];
	}];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 160;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _channelData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
	NSMutableString *string = [NSMutableString string];
	ZBAntServer *server = [[ZBAntServer alloc] initWithDictionary:_channelData[indexPath.row] channel:_selectedChannel];
	[string appendString:server.name];
	[string appendString:@"    "];
	if ([_selectedChannel isEqualToString:WEIBOYI]) {
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
	} else if ([_selectedChannel isEqualToString:NEWRANK]) {
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
		[string appendString:@"\n"];
	} else if ([_selectedChannel isEqualToString:GSDATA]) {
		[string appendFormat:@"gsGrabRank: %@", [ZBAntServer onOrOff:server.gsGrabRankJobOn]];
		[string appendString:GAP];
		[string appendFormat:@"interval: %@", server.gsGrabRankJobInterval];
		[string appendString:@"\n"];
		[string appendFormat:@"gsReloadRank: %@", [ZBAntServer onOrOff:server.gsInchargeOfReloadRankTasks]];
		[string appendString:@"\n"];
		[string appendFormat:@"gsProcessRank: %@", [ZBAntServer onOrOff:server.gsProcessRankJobOn]];
		[string appendString:GAP];
		[string appendFormat:@"interval: %@", server.gsProcessRankJobInterval];
		[string appendString:@"\n"];
	}
	cell.textLabel.text = string;
	cell.textLabel.numberOfLines = 0;
	cell.textLabel.font = [UIFont systemFontOfSize:13];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	ZBAntServer *server = [[ZBAntServer alloc] initWithDictionary:_channelData[indexPath.row] channel:_selectedChannel];
	ZBServerSettingsViewController *serverSettingsViewController = [[ZBServerSettingsViewController alloc] init];
	serverSettingsViewController.server = server;
	serverSettingsViewController.channel = _selectedChannel;
	serverSettingsViewController.hidesBottomBarWhenPushed = YES;
	[self.navigationController presentViewController:[[UINavigationController alloc] initWithRootViewController:serverSettingsViewController ] animated:YES completion:nil];
}

@end
