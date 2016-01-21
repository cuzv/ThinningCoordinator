//
//  CollectionViewDelegate.m
//  ThinningCoordinator
//
//  Created by Moch Xiao on 1/21/16.
//  Copyright © 2016 Moch. All rights reserved.
//

#import "CollectionViewDelegate.h"
#import "CollectionViewCell.h"
#import "CollectionViewHeaderFooterView.h"

@implementation CollectionViewDelegate


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGSize fittingSize = CGSizeMake(ceil(CGRectGetWidth(self.collectionView.bounds) - 20), UILayoutFittingExpandedSize.height);
    CGSize size = [self sizeForItemAtIndexPath:indexPath preferredLayoutSizeFittingSize:fittingSize cellType:CollectionViewCell.class];
    return size;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(8, 0, 8, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 8;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    CGSize fittingSize = CGSizeMake(CGRectGetWidth(collectionView.bounds), UILayoutFittingExpandedSize.height);
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize size = [self sizeForSupplementaryViewAtIndexPath:indexPath preferredLayoutSizeFittingSize:fittingSize cellType:CollectionViewHeaderFooterView.class ofKind:UICollectionElementKindSectionHeader];
    return size;

}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    CGSize fittingSize = CGSizeMake(CGRectGetWidth(collectionView.bounds), UILayoutFittingExpandedSize.height);
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:section];
    CGSize size = [self sizeForSupplementaryViewAtIndexPath:indexPath preferredLayoutSizeFittingSize:fittingSize cellType:CollectionViewHeaderFooterView.class ofKind:UICollectionElementKindSectionFooter];
    return size;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}


@end
