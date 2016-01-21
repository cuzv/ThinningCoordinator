//
//  ViewController.m
//  ThinningCoordinator
//
//  Created by Moch Xiao on 1/20/16.
//  Copyright © 2016 Moch. All rights reserved.
//

#import "TableViewSampleViewController.h"
#import "ThinningCoordinator.h"
#import <Masonry/Masonry.h>
#import "TableViewDelegate.h"
#import "TableViewDataSource.h"

@interface TableViewSampleViewController ()
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) TableViewDataSource *dataSource;
@property (nonatomic, strong) TableViewDelegate *delegate;
@end

@implementation TableViewSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self.delegate;
        _tableView.dataSource = self.dataSource;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.estimatedRowHeight = 44;
        if ([_tableView respondsToSelector:@selector(layoutMargins)]) {
            _tableView.layoutMargins = UIEdgeInsetsZero;
        }
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    return _tableView;
}

- (TableViewDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[TableViewDataSource alloc] initWithTableView:self.tableView];
    }
    return _dataSource;
}

- (TableViewDelegate *)delegate {
    if (!_delegate) {
        _delegate = [[TableViewDelegate alloc] initWithTableView:self.tableView];
    }
    return _delegate;
}


@end
