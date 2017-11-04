//
//  CollectionViewDataSource.m
//  ThinningCoordinator
//
//  Created by Roy Shaw on 1/21/16.
//  Copyright © 2016 Red Rain. All rights reserved.
//

#import "CollectionViewDataSource.h"
#import "CollectionViewCell.h"
#import "ThinningCoordinator.h"
#import "CollectionViewHeaderFooterView.h"

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


#pragma mark - TCCollectionSupplementaryViewibility

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    return [self viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

- (void)registerReusableSupplementaryView {
    [self.collectionView registerClass:CollectionViewHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CollectionViewHeaderFooterView.tc_identifier];
    [self.collectionView registerClass:CollectionViewHeaderFooterView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:CollectionViewHeaderFooterView.tc_identifier2];
}

- (nullable NSString *)reusableSupplementaryHeaderViewIdentifierForIndexPath:(nonnull NSIndexPath *)indexPath {
    return CollectionViewHeaderFooterView.tc_identifier;
}

- (void)loadData:(nonnull id)data forReusableSupplementaryHeaderView:(nonnull UICollectionReusableView *)reusableView {
    CollectionViewHeaderFooterView *headerView = (CollectionViewHeaderFooterView *)reusableView;
    [headerView setupData:data];
}

- (nullable NSString *)reusableSupplementaryFooterViewIdentifierForIndexPath:(nonnull NSIndexPath *)indexPath {
    return CollectionViewHeaderFooterView.tc_identifier2;
}

- (void)loadData:(nonnull id)data forReusableSupplementaryFooterView:(nonnull UICollectionReusableView *)reusableView {
    CollectionViewHeaderFooterView *footerView = (CollectionViewHeaderFooterView *)reusableView;
    [footerView setupData:data];
}

#pragma mark - TCTableViewCollectionViewMovable

- (BOOL)canMoveElementAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)moveElementAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSLog(@"%@", self.globalDataMetric);
}

@end
