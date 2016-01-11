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
#import "TCGlobalDataMetric.h"
#import "TCDataSourceProtocol.h"
#import "TCSectionDataMetric.h"
#import "TCHelper.h"

@interface TCDataSource ()
@property (nonatomic, weak, readwrite) UITableView *tableView;
@property (nonatomic, weak, readwrite) UICollectionView *collectionView;
@property (nonatomic, weak, readwrite) id <TCDataSourceProtocol> subclass;
@end

@implementation TCDataSource

- (instancetype)init {
    NSAssert(NO, NSLocalizedString(@"Use designed initializer instead!", nil));
    return nil;
}

- (instancetype)__init__ {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ([self conformsToProtocol:@protocol(TCDataSourceProtocol)]) {
        self.subclass = (id <TCDataSourceProtocol>) self;
    } else {
        NSAssert(NO, NSLocalizedString(@"subclass must conforms TCDataSourceProtocol!", nil));
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [self __init__];

    NSAssert(tableView, NSLocalizedString(@"Tableview can not be nil", nil));
    _tableView = tableView;
    [self registerTableViewReusableView];

    return self;
}

- (void)registerTableViewReusableView {
    [self.subclass registerReusableCell];
    if ([self.subclass respondsToSelector:@selector(registerReusableHeaderFooterView)]) {
        [self.subclass registerReusableHeaderFooterView];
    }
}

#pragma mark -

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
    NSString *identifier = [self.subclass reusableCellIdentifierForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    [cell prepareForReuse];
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    [self.subclass loadData:data forReusableCell:cell];
    
    // The first time load tableView, tableview will not draggin or decelerating
    // But need load images anyway, so perform load action manual
    // Note that see the collectionView logic in the same where
    if (!self.tableView.dragging &&
        !self.tableView.decelerating &&
        CGRectContainsPoint(self.tableView.frame, cell.frame.origin)) {
        [self _lazyLoadImagesData:data forReusableCell:cell];
    }

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.globalDataMetric titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.globalDataMetric titleForFooterInSection:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *indexTitles = [NSMutableArray new];
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(indexTitleForSectionDataMetric:)];
    if (!respondsToSelector) {
        return nil;
    }

    // If titles contains nil will crash
    __block BOOL valid = YES;
    [[self.globalDataMetric allSectionDataMetrics] enumerateObjectsUsingBlock:^(TCSectionDataMetric *obj, NSUInteger idx, BOOL *stop) {
        NSString *title = [self.subclass indexTitleForSectionDataMetric:obj];
        if (!title) {
            valid = NO;
            *stop = YES;
        }
        [indexTitles addObject:title];
    }];

    if (!valid) {
        return nil;
    }
    
    return indexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSArray *sectionIndexTitles = [self sectionIndexTitlesForTableView:self.tableView];
    return [sectionIndexTitles indexOfObjectIdenticalTo:title];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(canEditItemAtIndexPath:)];
    if (!respondsToSelector) {
        return respondsToSelector;
    }
    
    return [self.subclass canEditItemAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(commitEditingData:atIndexPath:)];
    if (!respondsToSelector) {
        return;
    }
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.globalDataMetric removeDataAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (UITableViewCellEditingStyleInsert == editingStyle) {
        // Duplicate last content item, in case reload data error, should not use it.
        if (!data) {
            NSLog(NSLocalizedString(@"Array index cross the bounds", nil));
            return;
        }
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.item + 1 inSection:indexPath.section];
        [self.globalDataMetric insertData:@[data] atIndexPath:newIndexPath];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    [self.subclass commitEditingData:data atIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(canMoveItemAtIndexPath:)];
    if (!respondsToSelector) {
        return respondsToSelector;
    }
    
    return [self.subclass canMoveItemAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    TCSectionDataMetric *sourceSectionDataMetric = [[self.globalDataMetric allSectionDataMetrics] objectAtIndex:sourceIndexPath.section];
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [sourceSectionDataMetric exchangeDataAtIndex:sourceIndexPath.item withDataAtIndex:destinationIndexPath.item];
    } else {
        // Take out the source data
        id data = [sourceSectionDataMetric dataAtIndex:sourceIndexPath.item];
        [sourceSectionDataMetric removeDataForItemAtIndex:sourceIndexPath.item];

        // Insert to desitination position
        TCSectionDataMetric *destinationSectionDataMetric = [[self.globalDataMetric allSectionDataMetrics] objectAtIndex:destinationIndexPath.section];
        [destinationSectionDataMetric insertItemsDataFromArray:@[data] atIndex:destinationIndexPath.item];
    }    
}

#pragma mark - UITableView delegate helper methods

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (TCCollectionViewSupportsConstraintsProperty()) {
        return UITableViewAutomaticDimension;
    }
    
    UITableViewCell *cell = [self tableView:self.tableView cellForRowAtIndexPath:indexPath];
    
    // Give the initialize bounds
    cell.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(cell.bounds));
    // break iOS7 issue
    cell.contentView.frame = cell.bounds;
    CGFloat height = [cell.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height + 1;
    
    [cell removeFromSuperview];
 
    return height;
}

/// TCDelegate subclass UITableViewDelegate require footer view, simple return this method
- (UIView *)viewForHeaderInSection:(NSInteger)section {
    if (![self.subclass respondsToSelector:@selector(reusableHeaderViewIdentifierInSection:)]) {
        return [UIView new];
    }
    
    NSString *identifier = [self.subclass reusableHeaderViewIdentifierInSection:section];
    if (!identifier || !identifier.length) {
        return [UIView new];
    }
    
    UITableViewHeaderFooterView *headerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerView) {
        return [UIView new];
    }
    
    [headerView prepareForReuse];

    id headerData = [self.globalDataMetric dataForHeaderInSection:section];
    [self.subclass loadData:headerData forReusableHeaderView:headerView];
    
    [headerView setNeedsUpdateConstraints];
    [headerView updateConstraintsIfNeeded];
    
    return headerView;
}

/// TCDelegate subclass UITableViewDelegate require footer view, simple return this method
- (UIView *)viewForFooterInSection:(NSInteger)section {
    if (![self.subclass respondsToSelector:@selector(reusableFooterViewIdentifierInSection:)]) {
        return [UIView new];
    }
    
    NSString *identifier = [self.subclass reusableFooterViewIdentifierInSection:section];
    if (!identifier || !identifier.length) {
        return [UIView new];
    }
    
    UITableViewHeaderFooterView *footerView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!footerView) {
        return [UIView new];
    }
    
    [footerView prepareForReuse];

    id footerData = [self.globalDataMetric dataForFooterInSection:section];
    [self.subclass loadData:footerData forReusableFooterView:footerView];
    
    [footerView setNeedsUpdateConstraints];
    [footerView updateConstraintsIfNeeded];
    
    return footerView;
}

/// Deprecated
- (UIView *)viewForHeaderFooterInSection:(NSInteger)section isHeader:(BOOL)isHeader {
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(reusableHeaderFooterViewIdentifierInSection:isHeader:)];
    if (!respondsToSelector) {
        return [UIView new];
    }
    
    NSString *identifier = [self.subclass reusableHeaderFooterViewIdentifierInSection:section isHeader:isHeader];
    if (!identifier || !identifier.length) {
        return [UIView new];
    }

    UITableViewHeaderFooterView *headerFooterView = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!headerFooterView) {
        return [UIView new];
    }

    [headerFooterView prepareForReuse];
    
    if (isHeader) {
        id headerData = [self.globalDataMetric dataForHeaderInSection:section];
        if ([self.subclass respondsToSelector:@selector(loadData:forReusableHeaderView:)]) {
            [self.subclass loadData:headerData forReusableHeaderView:headerFooterView];
        }
    } else {
        id footerData = [self.globalDataMetric dataForFooterInSection:section];
        if ([self.subclass respondsToSelector:@selector(loadData:forReusableFooterView:)]) {
            [self.subclass loadData:footerData forReusableFooterView:headerFooterView];
        }
    }
    
    [headerFooterView setNeedsUpdateConstraints];
    [headerFooterView updateConstraintsIfNeeded];
    
    return headerFooterView;
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    UIView *view = [self viewForHeaderInSection:section];
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return 10;
    }
    if (![self.subclass respondsToSelector:@selector(loadData:forReusableHeaderView:)]) {
        return 10;
    }
    
    UITableViewHeaderFooterView *headerView = (UITableViewHeaderFooterView *)view;
    // Give the initialize bounds
    headerView.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(headerView.bounds));
    // break iOS7 issue
    headerView.contentView.frame = headerView.bounds;
    CGFloat height = [headerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [headerView removeFromSuperview];

    return height;
}

- (CGFloat)heightForFooterInSection:(NSInteger)section {
    UIView *view = [self viewForFooterInSection:section];
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return 10;
    }
    if (![self.subclass respondsToSelector:@selector(loadData:forReusableFooterView:)]) {
        return 10;
    }
    
    UITableViewHeaderFooterView *footerView = (UITableViewHeaderFooterView *)view;
    // Give the initialize bounds
    footerView.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(footerView.bounds));
    // break iOS7 issue
    footerView.contentView.frame = footerView.bounds;
    CGFloat height = [footerView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;
    [footerView removeFromSuperview];
    
    return height;
}

/// Deprecated
- (CGFloat)heightForHeaderFooterInSection:(NSInteger)section isHeader:(BOOL)isHeader {
    UIView *view = [self viewForHeaderFooterInSection:section isHeader:isHeader];
    if (![view isKindOfClass:[UITableViewHeaderFooterView class]]) {
        return 10;
    }
    
    BOOL respondsHeader = [self.subclass respondsToSelector:@selector(loadData:forReusableHeaderView:)];
    BOOL respondsFooter = [self.subclass respondsToSelector:@selector(loadData:forReusableFooterView:)];
    if (!respondsHeader && !respondsFooter) {
        return 10.0f;
    }
    
    UITableViewHeaderFooterView *headerFooterView = (UITableViewHeaderFooterView *)view;
    // Give the initialize bounds
    headerFooterView.bounds = CGRectMake(0.0f, 0.0f, CGRectGetWidth(self.tableView.bounds), CGRectGetHeight(headerFooterView.bounds));
    // break iOS7 issue
    headerFooterView.contentView.frame = headerFooterView.bounds;

    CGFloat height = [headerFooterView.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize].height;

    [headerFooterView removeFromSuperview];
    
    return height;
}


#pragma mark - UICollectionViewDataSource

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [self __init__];

    NSAssert(collectionView, NSLocalizedString(@"CollectionView can not be nil", nil));
    _collectionView = collectionView;
    
    [self registerCollectionViewReusableView];
    
    return self;
}

- (void)registerCollectionViewReusableView {
    [self.subclass registerReusableCell];
    if ([self.subclass respondsToSelector:@selector(registerReusableSupplementaryView)]) {
        [self.subclass registerReusableSupplementaryView];
    }
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.globalDataMetric numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.globalDataMetric numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.subclass reusableCellIdentifierForIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell prepareForReuse];
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    [self.subclass loadData:data forReusableCell:cell];
    
    // The first time load collectionView, collectionView will not draggin or decelerating
    // But need load images anyway, so perform load action manual
    // First time. I try to add condiition `[[self.collectionView indexPathsForVisibleItems] containsObject:indexPath]`
    // But finally found that collectionView can not get the indexPath in `indexPathsForVisibleItems` before
    // you really can see it on the screen
    if (!self.collectionView.dragging &&
        !self.collectionView.decelerating &&
        CGRectContainsPoint(self.collectionView.frame, cell.frame.origin)) {
        [self _lazyLoadImagesData:data forReusableCell:cell];
    }

    return cell;
}

- (UICollectionReusableView *)viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.subclass respondsToSelector:@selector(reusableSupplementaryViewIdentifierForIndexPath:ofKind:)]
                                            ? [self.subclass reusableSupplementaryViewIdentifierForIndexPath:indexPath ofKind:kind]
                                            : nil;
    NSAssert(identifier, NSLocalizedString(@"Supplementary view reuse identifier can not be nil", nil));
    UICollectionReusableView *reusableView = [self.collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    
    id data = [self.globalDataMetric dataForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(loadData:forReusableSupplementaryView:)];
    NSAssert(respondsToSelector, NSLocalizedString(@"sub class must responds to selector `loadData:forReusableSupplementaryView:`", nil));
    [self.subclass loadData:data forReusableSupplementaryView:reusableView];
    
    return reusableView;
}

#pragma mark - Lazy load images

- (void)_lazyLoadImagesData:(id)data forReusableCell:(id)cell {
    if ([self.subclass respondsToSelector:@selector(lazyLoadImagesData:forReusableCell:)]) {
        [self.subclass lazyLoadImagesData:data forReusableCell:cell];
    }
}

@end
