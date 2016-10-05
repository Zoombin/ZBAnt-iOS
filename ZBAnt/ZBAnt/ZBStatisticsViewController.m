//
//  ZBWeiboyiStatisticsViewController.m
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBStatisticsViewController.h"
#import "ZBHTTPManager.h"

@interface ZBStatisticsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, readwrite) UITableView *tableView;
@property (nonatomic, readwrite) NSArray *types;
@property (nonatomic, readwrite) NSMutableDictionary *counts;

@end

@implementation ZBStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	self.title = _channel;
	_types = @[@"phpsessids", @"weixins", @"articles", @"articlesToday", @"tasks", @"tasksDeep", @"grabbed", @"weixinsNotProcessed", @"articlesNotProcessed"];
	if ([_channel isEqualToString:NEWRANK]) {
		_types = @[@"settings", @"tasksDetails", @"tasksArticles", @"weixins", @"articles", @"grabbed", @"detailsNotProcessed", @"articlesNotProcessed"];
	}
	
	_counts = [NSMutableDictionary dictionary];
	
	_tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
}

- (void)loadData:(NSString *)type {
	[[ZBHTTPManager shared] statistics:_channel type:type withBlock:^(id responseObject, NSError *error) {
		if (!error) {
			NSDictionary *tmp = responseObject[@"data"];
			if (tmp) {
				NSString *name = tmp[@"name"];
				NSNumber *count = tmp[@"count"];
				_counts[name] = count;
				[_tableView reloadData];
			}
		}
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return _types.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:[NSString stringWithFormat:@"%ld", (long)indexPath.row]];
	NSString *type = _types[indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@: %@", type, _counts[type]];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self loadData:_types[indexPath.row]];
}


@end
