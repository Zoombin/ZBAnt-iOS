//
//  ZBWeiboyiStatisticsViewController.m
//  ZBAnt
//
//  Created by zhangbin on 9/16/16.
//  Copyright © 2016 Zoombin. All rights reserved.
//

#import "ZBStatisticsViewController.h"
#import "ZBHTTPManager.h"

@interface ZBStatisticsViewController ()

@property (nonatomic, readwrite) UITextView *textView;

@end

@implementation ZBStatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	_textView = [[UITextView alloc] initWithFrame:self.view.frame];
	_textView.editable = NO;
	_textView.font = [UIFont systemFontOfSize:25];
	[self.view addSubview:_textView];

	
	[self loadData];
}

- (void)loadData {
	[[ZBHTTPManager shared] statisticsWithBlock:^(id responseObject, NSError *error) {
		if (!error) {
			if (responseObject[@"data"]) {
				NSArray *data = [NSArray arrayWithArray:responseObject[@"data"]];
				NSMutableString *string = [NSMutableString string];
				for (int i = 0; i < data.count; i++) {
					NSDictionary *dict = data[i];
					[string appendFormat:@"%@: %@", dict[@"name"], dict[@"count"]];
					[string appendString:@"\n"];
				}
				_textView.text = string;
			}
		}
	}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
