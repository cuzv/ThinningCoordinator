//
//  CollectionViewDataSource.m
//  ThinningCoordinator
//
//  Created by Moch Xiao on 1/21/16.
//  Copyright © 2016 Moch. All rights reserved.
//

#import "CollectionViewDataSource.h"
#import "CollectionViewCell.h"
#import "ThinningCoordinator.h"

@implementation CollectionViewDataSource


#pragma mark - TCDataSourceable

- (void)registerReusableCell {
    [self.collectionView registerClass:CollectionViewCell.class forCellWithReuseIdentifier:CollectionViewCell.tc_identifier];
}

- (NSString *)reusableCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    return CollectionViewCell.tc_identifier;
}

- (void)loadData:(id)data forReusableCell:(id)cell {
    CollectionViewCell *reusableCell = (CollectionViewCell *)cell;
    [reusableCell setupData:data];
}


#pragma mark - TCTableViewCollectionViewMovable

- (BOOL)canMoveElementAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)moveElementAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSLog(@"%@", self.globalDataMetric);
}

@end
