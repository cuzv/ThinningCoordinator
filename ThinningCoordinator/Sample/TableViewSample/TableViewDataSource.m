//
//  TableViewDataSource.m
//  ThinningCoordinator
//
//  Created by Roy Shaw on 1/21/16.
//  Copyright © 2016 Red Rain. All rights reserved.
//

#import "TableViewDataSource.h"
#import "TableViewCell.h"
#import "NSObject+TCIdentifier.h"
#import "TableViewHeaderFooterView.h"

@implementation TableViewDataSource

#pragma mark - TCDataSourceable

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

#pragma mark - TCTableViewHeaderFooterViewibility

- (void)registerReusableHeaderFooterView {
    [self.tableView registerClass:TableViewHeaderFooterView.class forHeaderFooterViewReuseIdentifier:TableViewHeaderFooterView.tc_identifier];
}

- (NSString *)reusableHeaderViewIdentifierInSection:(NSInteger)section {
    return TableViewHeaderFooterView.tc_identifier;
}

- (NSString *)reusableFooterViewIdentifierInSection:(NSInteger)section {
    return TableViewHeaderFooterView.tc_identifier;
}

- (void)loadData:(id)data forReusableHeaderView:(UITableViewHeaderFooterView *)headerView {
    TableViewHeaderFooterView *reusableView = (TableViewHeaderFooterView *)headerView;
    [reusableView setupData:data];
}

- (void)loadData:(id)data forReusableFooterView:(UITableViewHeaderFooterView *)footerView {
    TableViewHeaderFooterView *reusableView = (TableViewHeaderFooterView *)footerView;
    [reusableView setupData:data];
}

#pragma mark - TCTableViewEditable

- (BOOL)canEditElementAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)commitEditingStyle:(UITableViewCellEditingStyle)style forData:(id)data {
    NSLog(@"%@", self.globalDataMetric);
}

#pragma mark - TCTableViewCollectionViewMovable

- (BOOL)canMoveElementAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)moveElementAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSLog(@"%@", self.globalDataMetric);
}

@end
