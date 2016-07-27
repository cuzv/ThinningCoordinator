//
//  TCDataSource.m
//  ThinningCoordinator
//
//  Created by Moch Xiao on 8/24/15.
//  Copyright (c) 2015 Moch Xiao (https://github.com/cuzv).
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "TCDataSource.h"
#import "TCDelegate.h"
#import "TCDelegate+Private.h"
#import "TCGlobalDataMetric.h"
#import "TCGlobalDataMetric+Private.h"
#import "TCDataSourceProtocol.h"
#import "TCSectionDataMetric.h"
#import "TCHelper.h"
#import "TCDefaultSupplementaryView.h"
#import "NSObject+TCIdentifier.h"
#import "ResuableView+TCExtension.h"

@interface TCDataSource ()

@property (nonatomic, weak, readwrite) UITableView *tableView;
@property (nonatomic, weak, readwrite) UICollectionView *collectionView;

@property (nonatomic, weak, nullable) id<TCDataSourceable> sourceable;
//@property (nonatomic, weak, nullable, readwrite) id<TCImageLazyLoadable> lazyLoadable;
@property (nonatomic, weak, nullable) id<TCTableViewCollectionViewMovable> movable;

@property (nonatomic, weak, nullable) id<TCTableViewHeaderFooterViewibility> headerFooterViewibility;
@property (nonatomic, weak, nullable) id<TCCollectionSupplementaryViewibility> supplementaryViewibility;

@property (nonatomic, weak, nullable) id<TCTableViewEditable> editable;

@end

@implementation TCDataSource

#pragma mark - Initializer

- (nullable instancetype)init {
    [NSException raise:@"Use `initWithTableView:` or `initWithCollectionView:` instead." format:@""];
    return nil;
}

- (nullable instancetype)__init__ {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ([self conformsToProtocol:@protocol(TCDataSourceable)]) {
        self.sourceable = (id<TCDataSourceable>)self;
    } else {
        [NSException raise:@"Must conforms protocol `TCDataSourceable`." format:@""];
    }
    
    return self;
}

- (nullable instancetype)initWithTableView:(nonnull UITableView *)tableView {
    NSAssert(tableView, NSLocalizedString(@"Tableview can not be nil", nil));
    
    self = [self __init__];
    _tableView = tableView;
    [self registerTableViewReusableView];
    if ([self conformsToProtocol:@protocol(TCTableViewEditable)]) {
        self.editable = (id<TCTableViewEditable>)self;
    }
    if ([self conformsToProtocol:@protocol(TCTableViewCollectionViewMovable)]) {
        self.movable = (id<TCTableViewCollectionViewMovable>)self;
    }

    return self;
}

- (void)registerTableViewReusableView {
    [self.sourceable registerReusableCell];
    
    if ([self conformsToProtocol:@protocol(TCTableViewHeaderFooterViewibility)]) {
        id headerFooterViewibility = (id<TCTableViewHeaderFooterViewibility>)self;
        [headerFooterViewibility registerReusableHeaderFooterView];
        self.headerFooterViewibility = headerFooterViewibility;
    }
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    NSAssert(collectionView, NSLocalizedString(@"CollectionView can not be nil", nil));

    self = [self __init__];
    _collectionView = collectionView;
    [self registerCollectionViewReusableView];
    if ([self conformsToProtocol:@protocol(TCTableViewCollectionViewMovable)]) {
        self.movable = (id<TCTableViewCollectionViewMovable>)self;
    }
    
    return self;
}

- (void)registerCollectionViewReusableView {
    [self.sourceable registerReusableCell];
    
    if ([self conformsToProtocol:@protocol(TCCollectionSupplementaryViewibility)]) {
        id supplementaryViewibility = (id<TCCollectionSupplementaryViewibility>)self;
        [supplementaryViewibility registerReusableSupplementaryView];
        self.supplementaryViewibility = supplementaryViewibility;
        
        [self.collectionView registerClass:TCDefaultSupplementaryView.class forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TCDefaultSupplementaryView.tc_identifier];
        [self.collectionView registerClass:TCDefaultSupplementaryView.class forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TCDefaultSupplementaryView.tc_identifier];
    }
}

#pragma mark - Accessor

- (nullable TCDelegate *)delegate {
    if (self.tableView) {
        return (TCDelegate *)self.tableView.delegate;
    }
    else if (self.collectionView) {
        return (TCDelegate *)self.collectionView.delegate;
    }
    
    return nil;
}

#pragma mark - UITableViewDataSource

#pragma mark - TCDataSourceable

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.globalDataMetric numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.globalDataMetric numberOfItemsInSection:section];
}

/// http://stackoverflow.com/questions/25826383/when-to-use-dequeuereusablecellwithidentifier-vs-dequeuereusablecellwithidentifi
/// The most important difference is that the forIndexPath: version asserts (crashes) if you didn't register a class or nib for the identifier. The older (non-forIndexPath:) version returns nil in that case.
/// You register a class for an identifier by sending registerClass:forCellReuseIdentifier: to the table view. You register a nib for an identifier by sending registerNib:forCellReuseIdentifier: to the table view.
/// If you create your table view and your cell prototypes in a storyboard, the storyboard loader takes care of registering the cell prototypes that you defined in the storyboard.
/// Session 200 - What's New in Cocoa Touch from WWDC 2012 discusses the (then-new) forIndexPath: version starting around 8m30s. It says that “you will always get an initialized cell” (without mentioning that it will crash if you didn't register a class or nib).
/// The video also says that “it will be the right size for that index path”. Presumably this means that it will set the cell's size before returning it, by looking at the table view's own width and calling your delegate's tableView:heightForRowAtIndexPath: method (if defined). This is why it needs the index path.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.sourceable reusableCellIdentifierForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        [NSException raise:@"Must conforms protocol `TCDataSourceable`." format:@""];
    }
    [cell prepareForReuse];
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    if (data && !self.delegate.scrollingToTop) {
        [self.sourceable loadData:data forReusableCell:cell];
        
        if ([self conformsToProtocol:@protocol(TCImageLazyLoadable)]) {
            CGRect targetRect = self.delegate.targetRect.CGRectValue;
            if (CGRectIntersectsRect(targetRect, cell.frame)) {
                id lazyLoadable = (id<TCImageLazyLoadable>)self;
                [lazyLoadable lazyLoadImagesData:data forReusableCell:cell];
            }
        }
    }
    
    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


#pragma mark - Section Title

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.globalDataMetric titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.globalDataMetric titleForFooterInSection:section];
}


#pragma mark - Section Index

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.globalDataMetric sectionIndexTitles];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    return [[self.globalDataMetric sectionIndexTitles] indexOfObjectIdenticalTo:title];
}


#pragma mark - TCTableViewEditable

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    id editable = self.editable;
    if (!editable) {
        return NO;
    }

    return [editable canEditElementAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    id editable = self.editable;
    if (!editable) {
        return;
    }
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    if (!data) {
        return;
    }
    
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.globalDataMetric removeAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (UITableViewCellEditingStyleInsert == editingStyle) {
        // Duplicate last content item, in case reload data error, should not use it.
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.item + 1 inSection:indexPath.section];
        [self.globalDataMetric insert:data atIndexPath:newIndexPath];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    [editable commitEditingStyle:editingStyle forData:data];
}


#pragma mark - TCTableViewCollectionViewMovable

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    id moable = self.movable;
    if (!moable) {
        return NO;
    }
    
    return [moable canMoveElementAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id moable = self.movable;
    if (!moable) {
        return;
    }
    
    [self.globalDataMetric moveAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    [moable moveElementAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

#pragma mark - TCTableViewHeaderFooterViewibility

- (CGFloat)_heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [self.globalDataMetric cachedHeightForIndexPath:indexPath];
    if (height != UITableViewAutomaticDimension) {
        return height;
    }
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    if (!data) {
        return UITableViewAutomaticDimension;
    }
    
    NSString *identifier = [self.sourceable reusableCellIdentifierForIndexPath:indexPath];
    __weak typeof(self) weak_self = self;
    height = [self.tableView tc_heightForReusableCellByIdentifier:identifier dataConfigurationHandler:^(UITableViewCell * _Nonnull cell) {
        __strong typeof(weak_self) strong_self = weak_self;
        [strong_self.sourceable loadData:data forReusableCell:cell];
    }];
    [self.globalDataMetric cacheHeight:height forIndexPath:indexPath];
 
    return height;
}

- (CGFloat)_heightForHeaderInSection:(NSInteger)section {
    CGFloat height = [self.globalDataMetric cachedHeightForHeaderInSection:section];
    if (height != UITableViewAutomaticDimension) {
        return height;
    }
    
    id headerFooterViewibility = self.headerFooterViewibility;
    if (!headerFooterViewibility) {
        return 10.0f;
    }
    
    NSString *identifier = [headerFooterViewibility reusableHeaderViewIdentifierInSection:section];
    if (!identifier) {
        return 10.0f;
    }
    
    id data = [self.globalDataMetric dataForHeaderInSection:section];
    if (!data) {
        return 10.0f;
    }
    
    height = [self.tableView tc_heightForReusableHeaderFooterViewByIdentifier:identifier dataConfigurationHandler:^(UITableViewHeaderFooterView * _Nonnull reusableHeaderFooterView) {
        [headerFooterViewibility loadData:data forReusableHeaderView:reusableHeaderFooterView];
    }];
    [self.globalDataMetric cacheHeight:height forHeaderInSection:section];
    
    return height;
}

- (UIView *)_viewForHeaderInSection:(NSInteger)section {
    id headerFooterViewibility = self.headerFooterViewibility;
    if (!headerFooterViewibility) {
        return nil;
    }
    NSString *identifier = [headerFooterViewibility reusableHeaderViewIdentifierInSection:section];
    if (!identifier) {
        return nil;
    }
    UITableViewHeaderFooterView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        return nil;
    }
    id data = [self.globalDataMetric dataForHeaderInSection:section];
    if (!data) {
        return nil;
    }
    
    [headerView prepareForReuse];

    if (!self.delegate.scrollingToTop) {
        [headerFooterViewibility loadData:data forReusableHeaderView:headerView];
    }
    
    [headerView setNeedsUpdateConstraints];
    [headerView updateConstraintsIfNeeded];
    
    return headerView;
}

- (CGFloat)_heightForFooterInSection:(NSInteger)section {
    CGFloat height = [self.globalDataMetric cachedHeightForFooterInSection:section];
    if (height != UITableViewAutomaticDimension) {
        return height;
    }

    id headerFooterViewibility = self.headerFooterViewibility;
    if (!headerFooterViewibility) {
        return 10.0f;
    }
    
    NSString *identifier = [headerFooterViewibility reusableFooterViewIdentifierInSection:section];
    if (!identifier) {
        return 10.0f;
    }
    
    id data = [self.globalDataMetric dataForFooterInSection:section];
    if (!data) {
        return 10.0f;
    }

    height = [self.tableView tc_heightForReusableHeaderFooterViewByIdentifier:identifier dataConfigurationHandler:^(UITableViewHeaderFooterView * _Nonnull reusableHeaderFooterView) {
        [headerFooterViewibility loadData:data forReusableFooterView:reusableHeaderFooterView];
    }];
    [self.globalDataMetric cacheHeight:height forFooterInSection:section];
    
    return height;
}

- (UIView *)_viewForFooterInSection:(NSInteger)section {
    id headerFooterViewibility = self.headerFooterViewibility;
    if (!headerFooterViewibility) {
        return nil;
    }
    NSString *identifier = [headerFooterViewibility reusableFooterViewIdentifierInSection:section];
    if (!identifier) {
        return nil;
    }
    UITableViewHeaderFooterView *footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footerView) {
        return nil;
    }
    id data = [self.globalDataMetric dataForFooterInSection:section];
    if (!data) {
        return nil;
    }
    
    [footerView prepareForReuse];

    if (!self.delegate.scrollingToTop) {
        [headerFooterViewibility loadData:data forReusableFooterView:footerView];
    }
    
    [footerView setNeedsUpdateConstraints];
    [footerView updateConstraintsIfNeeded];
    
    return footerView;
}


#pragma mark - UICollectionViewDataSource

#pragma mark - TCDataSourceable

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.globalDataMetric numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.globalDataMetric numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.sourceable reusableCellIdentifierForIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell prepareForReuse];
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    if (data && !self.delegate.scrollingToTop) {
        [self.sourceable loadData:data forReusableCell:cell];
        
        if ([self conformsToProtocol:@protocol(TCImageLazyLoadable)]) {
            CGRect targetRect = self.delegate.targetRect.CGRectValue;
            if (CGRectIntersectsRect(targetRect, cell.frame)) {
                id lazyLoadable = (id<TCImageLazyLoadable>)self;
                [lazyLoadable lazyLoadImagesData:data forReusableCell:cell];
            }
        }
    }

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}


#pragma mark - TCTableViewCollectionViewMovable

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    id moable = self.movable;
    if (!moable) {
        return NO;
    }
    
    return [moable canMoveElementAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    id moable = self.movable;
    if (!moable) {
        return;
    }
    
    [self.globalDataMetric moveAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
    [moable moveElementAtIndexPath:sourceIndexPath toIndexPath:destinationIndexPath];
}

#pragma mark - TCCollectionSupplementaryViewibility

- (CGSize)_sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath preferredLayoutSizeFittingSize:(CGSize)fittingSize cellType:(nonnull Class)type {
    id sourceable = self.sourceable;
    if (!sourceable) {
        [NSException raise:@"FatalError" format:@"Must conforms protocol `TCCollectionSupplementaryViewibility`."];
    }
    
    CGSize size = [self.globalDataMetric cachedSizeForIndexPath:indexPath];
    if (!CGSizeEqualToSize(CGSizeZero, size)) {
        return size;
    }
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    if (!data) {
        return CGSizeZero;
    }
    
    size = [self.collectionView tc_sizeForReusableViewByClass:type preferredLayoutSizeFittingSize:fittingSize dataConfigurationHandler:^(UICollectionReusableView * _Nonnull reusableView) {
        [sourceable loadData:data forReusableCell:reusableView];
    }];
    [self.globalDataMetric cacheSize:size forIndexPath:indexPath];

    return size;
}

- (CGSize)_sizeForSupplementaryViewAtIndexPath:(nonnull NSIndexPath *)indexPath preferredLayoutSizeFittingSize:(CGSize)fittingSize cellType:(nonnull Class)type ofKind:(nonnull NSString *)kind {
    id sourceable = self.sourceable;
    if (!sourceable) {
        [NSException raise:@"FatalError" format:@"Must conforms protocol `TCCollectionSupplementaryViewibility`."];
    }
    
    NSInteger section = indexPath.section;
    id data = nil;
    CGSize size = CGSizeZero;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        size = [self.globalDataMetric cachedSizeForHeaderInSection:section];
        if (!CGSizeEqualToSize(CGSizeZero, size)) {
            return size;
        }
        
        data = [self.globalDataMetric dataForSupplementaryHeaderAtIndexPath:indexPath];
        if (data) {
            size = [self.collectionView tc_sizeForReusableViewByClass:type preferredLayoutSizeFittingSize:fittingSize dataConfigurationHandler:^(UICollectionReusableView * _Nonnull reusableView) {
                [sourceable loadData:data forReusableSupplementaryHeaderView:reusableView];
            }];
            [self.globalDataMetric cacheSize:size forHeaderInSection:section];
        }
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        size = [self.globalDataMetric cachedSizeForFooterInSection:section];
        if (!CGSizeEqualToSize(CGSizeZero, size)) {
            return size;
        }
        
        data = [self.globalDataMetric dataForSupplementaryFooterAtIndexPath:indexPath];
        if (data) {
            size = [self.collectionView tc_sizeForReusableViewByClass:type preferredLayoutSizeFittingSize:fittingSize dataConfigurationHandler:^(UICollectionReusableView * _Nonnull reusableView) {
                [sourceable loadData:data forReusableSupplementaryFooterView:reusableView];
            }];
            [self.globalDataMetric cacheSize:size forFooterInSection:section];
        }
    }
    
    return size;
}

- (nonnull UICollectionReusableView *)viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    id supplementaryViewibility = self.supplementaryViewibility;
    if (!supplementaryViewibility) {
        [NSException raise:@"FatalError" format:@"Must conforms protocol `TCCollectionSupplementaryViewibility`."];
    }
    
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        NSString *identifier = [supplementaryViewibility reusableSupplementaryHeaderViewIdentifierForIndexPath:indexPath];
        if (!identifier) {
            return [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TCDefaultSupplementaryView.tc_identifier forIndexPath:indexPath];
        }
        id data = [self.globalDataMetric dataForSupplementaryHeaderAtIndexPath:indexPath];
        if (!data) {
            return [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:TCDefaultSupplementaryView.tc_identifier forIndexPath:indexPath];
        }

        UICollectionReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:identifier forIndexPath:indexPath];
        if (!self.delegate.scrollingToTop) {
            [supplementaryViewibility loadData:data forReusableSupplementaryHeaderView:reusableView];
        }
        
        return reusableView;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]) {
        NSString *identifier = [supplementaryViewibility reusableSupplementaryFooterViewIdentifierForIndexPath:indexPath];
        if (!identifier) {
            return [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TCDefaultSupplementaryView.tc_identifier forIndexPath:indexPath];
        }
        id data = [self.globalDataMetric dataForSupplementaryFooterAtIndexPath:indexPath];
        if (!data) {
            return [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:TCDefaultSupplementaryView.tc_identifier forIndexPath:indexPath];
        }

        UICollectionReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:identifier forIndexPath:indexPath];
        if (!self.delegate.scrollingToTop) {
            [supplementaryViewibility loadData:data forReusableSupplementaryFooterView:reusableView];
        }

        return reusableView;
    }
    else {
        [NSException raise:@"FatalError" format:@"kind only support `UICollectionElementKindSectionHeader` adn `UICollectionElementKindSectionFooter` currently."];
        return nil;
    }
}

@end
