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

NSString *header = @"Section header text!  Section header text! Section header text! Section header text Section header text!  Section header text! Section header text! Section header text";
NSString *footer = @"Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! Section footer text! ";


NSString *text1 = @"The Swift Package Manager and its build system needs to understand how to compile your source code. To do this, it uses a convention-based approach which uses the organization of your source code in the file system to determine what you mean, but allows you to fully override and customize these details. A simple example could be:";
NSString *text2 = @"Package.swift is the manifest file that contains metadata about your package. For simple projects an empty file is OK, however the file must still exist. Package.swift is documented in a later section.";
NSString *text3 = @"Of course, the package manager is used to build itself, so its own source files are laid out following these conventions as well.";
NSString *text4 = @"Please note that currently we only build static libraries. In general this has benefits, however we understand the need for dynamic libraries and support for this will be added in due course.";

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
