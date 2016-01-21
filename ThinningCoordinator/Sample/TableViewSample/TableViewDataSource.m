//
//  TableViewDataSource.m
//  ThinningCoordinator
//
//  Created by Moch Xiao on 1/21/16.
//  Copyright © 2016 Moch. All rights reserved.
//

#import "TableViewDataSource.h"
#import "TableViewCell.h"
#import "NSObject+TCIdentifier.h"
#import "TableViewHeaderView.h"

@implementation TableViewDataSource

- (void)registerReusableCell {
    [self.tableView registerClass:TableViewCell.class forCellReuseIdentifier:TableViewCell.tc_identifier];
}

- (NSString *)reusableCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return TableViewCell.tc_identifier;
}

- (void)loadData:(id)data forReusableCell:(id)cell {
    TableViewCell *reusableCell = (TableViewCell *)cell;
    [reusableCell setupData:data];
}


- (void)registerReusableHeaderFooterView {
    [self.tableView registerClass:TableViewHeaderView.class forHeaderFooterViewReuseIdentifier:TableViewHeaderView.tc_identifier];
}

- (NSString *)reusableHeaderViewIdentifierInSection:(NSInteger)section {
    return TableViewHeaderView.tc_identifier;
}

- (NSString *)reusableFooterViewIdentifierInSection:(NSInteger)section {
    return TableViewHeaderView.tc_identifier;
}

- (void)loadData:(id)data forReusableHeaderView:(UITableViewHeaderFooterView *)headerView {
    TableViewHeaderView *reusableView = (TableViewHeaderView *)headerView;
    [reusableView setupData:data];
}

- (void)loadData:(id)data forReusableFooterView:(UITableViewHeaderFooterView *)footerView {
    TableViewHeaderView *reusableView = (TableViewHeaderView *)footerView;
    [reusableView setupData:data];
}


@end
