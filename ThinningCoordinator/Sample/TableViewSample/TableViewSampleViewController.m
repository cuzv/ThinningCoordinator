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
#import "Text.h"

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


    NSArray *data0 = @[@"Michael", @"Moch", @"KKKK"];
    TCSectionDataMetric *section0 = [[TCSectionDataMetric alloc] initWithItemsData:data0 dataForHeader:header dataForFooter:footer];

    NSArray *data1 = @[@"Kevin", @"Anna", text1,  @"Jack"];
    TCSectionDataMetric *section1 = [[TCSectionDataMetric alloc] initWithItemsData:data1];
    
    NSArray *data2 = @[text1, @"Anna", text2,  @"Jack", text3, text4];
    TCSectionDataMetric *section2 = [[TCSectionDataMetric alloc] initWithItemsData:data2];
    
    TCGlobalDataMetric *globalDataMetric = [[TCGlobalDataMetric alloc] initWithSectionDataMetrics:@[section0, section1, section2]];

    self.dataSource.globalDataMetric = globalDataMetric;
    [self.tableView reloadData];
}


- (IBAction)handleEdit:(UIBarButtonItem *)sender {
    self.tableView.editing = !self.tableView.editing;
}

- (IBAction)handleInsert:(UIBarButtonItem *)sender {
    [self.dataSource.globalDataMetric insert:@"Inserted" atIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    [self.tableView reloadData];
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
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
