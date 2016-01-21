//
//  TCDelegate.m
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

#import "TCDelegate.h"
#import "TCDataSource.h"
#import "TCDataSource+Private.h"
#import "TCGlobalDataMetric.h"
#import "TCDataSourceProtocol.h"

@interface TCDelegate ()
@property (nonatomic, weak, readwrite) UITableView *tableView;
@property (nonatomic, weak, readwrite) UICollectionView *collectionView;

@property (nonatomic, assign) BOOL scrollingToTop;
@property (nonatomic, strong, readwrite, nullable) NSValue *targetRect;
@end

@implementation TCDelegate

#pragma mark - Initializer

- (nullable instancetype)init {
    [NSException raise:@"Use `initWithTableView:` or `initWithCollectionView:` instead." format:@""];
    return nil;
}

- (nullable instancetype)initWithTableView:(nonnull UITableView *)tableView {
    NSAssert(tableView, NSLocalizedString(@"Tableview can not be nil", nil));
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _tableView = tableView;
    
    return self;
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    NSAssert(collectionView, NSLocalizedString(@"CollectionView can not be nil", nil));
    self = [super init];
    if (!self) {
        return nil;
    }

    _collectionView = collectionView;
    
    return self;
}


#pragma mark - Accessor

- (nonnull TCDataSource *)dataSource {
    if (self.tableView) {
        return (TCDataSource *)self.tableView.dataSource;
    }
    
    return (TCDataSource *)self.collectionView.dataSource;
}

- (nonnull TCGlobalDataMetric *)globalDataMetric {
    return self.dataSource.globalDataMetric;
}

- (void)setGlobalDataMetric:(nonnull TCGlobalDataMetric *)globalDataMetric {
    self.dataSource.globalDataMetric = globalDataMetric;
}


#pragma mark - UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.targetRect = nil;
    [self loadImagesForVisibleElements];
}


- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    CGRect rect = CGRectMake((*targetContentOffset).x, (*targetContentOffset).y, CGRectGetWidth(scrollView.frame), CGRectGetHeight(scrollView.frame));
    self.targetRect = [NSValue valueWithCGRect:rect];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.targetRect = nil;
    [self loadImagesForVisibleElements];
}

- (void)loadImagesForVisibleElements {
    id lazyLoadable = self.dataSource.lazyLoadable;
    if (!lazyLoadable) {
        return;
    }
    NSArray *visibleIndexPaths = self.tableView ? [self.tableView indexPathsForVisibleRows] : [self.collectionView indexPathsForVisibleItems];
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        id cell = self.tableView ? [self.tableView cellForRowAtIndexPath:indexPath] : [self.collectionView cellForItemAtIndexPath:indexPath];
        id data = [self.dataSource.globalDataMetric dataForItemAtIndexPath:indexPath];
        if (cell && data) {
            [lazyLoadable lazyLoadImagesData:data forReusableCell:cell];
        }
    }
}

- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView {
    self.scrollingToTop = YES;
    return YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    self.scrollingToTop = NO;
    [self loadContent];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView {
    self.scrollingToTop = NO;
    [self loadContent];
}

- (void)loadContent {
    if (self.scrollingToTop) {
        return;
    }
    
    if (self.tableView) {
        [self loadContentForTableView];
    }
    else {
        [self loadConentForCollectionView];
    }
}

- (void)loadContentForTableView {
    if (self.tableView.indexPathsForVisibleRows.count <= 0) {
        return;
    }
    [self.tableView reloadData];
}

- (void)loadConentForCollectionView {
    if (self.collectionView.indexPathsForVisibleItems.count <= 0) {
        return;
    }
    [self.collectionView reloadData];

}


#pragma mark - UITableViewDelegate helper methods

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self.dataSource _heightForRowAtIndexPath:indexPath];
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    return [self.dataSource _heightForHeaderInSection:section];
}

- (nullable UIView *)viewForHeaderInSection:(NSInteger)section {
    return [self.dataSource _viewForHeaderInSection:section];
}

- (CGFloat)heightForFooterInSection:(NSInteger)section {
    return [self.dataSource _heightForFooterInSection:section];
}

- (nullable UIView *)viewForFooterInSection:(NSInteger)section {
   return [self.dataSource _viewForFooterInSection:section];
}


#pragma mark - UICollectionViewDelegate helper methods

- (CGSize)sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath preferredLayoutSizeFittingSize:(CGSize)fittingSize cellType:(nonnull Class)type {
    return [self.dataSource _sizeForItemAtIndexPath:indexPath preferredLayoutSizeFittingSize:fittingSize cellType:type];
}

- (CGSize)sizeForSupplementaryViewAtIndexPath:(nonnull NSIndexPath *)indexPath preferredLayoutSizeFittingSize:(CGSize)fittingSize cellType:(nonnull Class)type ofKind:(nonnull NSString *)kind {
    return [self.dataSource _sizeForSupplementaryViewAtIndexPath:indexPath preferredLayoutSizeFittingSize:fittingSize cellType:type ofKind:kind];
}

- (nonnull UICollectionReusableView *)viewForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath {
    return [self.dataSource _viewForSupplementaryElementOfKind:kind atIndexPath:indexPath];
}

@end
