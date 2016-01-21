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

@implementation TableViewDataSource

- (void)registerReusableCell {
    [self.tableView registerClass:TableViewCell.class forCellReuseIdentifier:TableViewCell.tc_identifier];
}

- (NSString *)reusableCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return TableViewCell.tc_identifier;
}

- (void)loadData:(id)data forReusableCell:(id)cell {
    
}

@end
