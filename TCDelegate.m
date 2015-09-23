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

@interface TCDelegate ()
@property (nonatomic, weak, readwrite) UITableView *tableView;
@property (nonatomic, weak, readwrite) UICollectionView *collectionView;
@end

@implementation TCDelegate

- (instancetype)init {
    NSAssert(NO, NSLocalizedString(@"Use designed initializer instead!", nil));
    return nil;
}

- (instancetype)__init__ {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [self __init__];
    
    NSAssert(tableView, NSLocalizedString(@"Tableview can not be nil", nil));
    _tableView = tableView;
    
    return self;
}

#pragma mark - UITableViewDelegate helper methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    TCDataSource *dataSource = (TCDataSource *)tableView.dataSource;
    return [dataSource heightForRowAtIndexPath:indexPath];
}

- (UIView *)viewForHeaderInSection:(NSInteger)section {
    TCDataSource *dataSource = (TCDataSource *)self.tableView.dataSource;
    return [dataSource viewForHeaderFooterInSection:section isHeader:YES];
}

- (UIView *)viewForFooterInSection:(NSInteger)section {
    TCDataSource *dataSource = (TCDataSource *)self.tableView.dataSource;
   return [dataSource viewForHeaderFooterInSection:section isHeader:NO];
}

- (CGFloat)heightForHeaderInSection:(NSInteger)section {
    TCDataSource *dataSource = (TCDataSource *)self.tableView.dataSource;
    return [dataSource heightForHeaderFooterInSection:section isHeader:YES];
}

- (CGFloat)heightForFooterInSection:(NSInteger)section {
    TCDataSource *dataSource = (TCDataSource *)self.tableView.dataSource;
    return [dataSource heightForHeaderFooterInSection:section isHeader:NO];
}

#pragma mark - UICollectionViewDataSource

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [self __init__];
    
    NSAssert(collectionView, NSLocalizedString(@"CollectionView can not be nil", nil));
    _collectionView = collectionView;
    
    return self;
}

#pragma mark - UIScrollViewDelegate

///// Fix second time scrolling before first scrolling not ended intermediate state
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    [self loadImagesForOnscreenItems];
//}

///  Load images for all onscreen rows when scrolling is finished.
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenItems];
    }
}

///  When scrolling stops, proceed to load the app images that are on screen.
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenItems];
}

- (void)loadImagesForOnscreenItems {
    // visible index paths
    NSArray *visibleIndexPaths = self.tableView ? [self.tableView indexPathsForVisibleRows] : [self.collectionView indexPathsForVisibleItems];
    TCDataSource *dataSource = self.tableView ? (TCDataSource *)self.tableView.dataSource : (TCDataSource *)self.collectionView.dataSource;
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        // cell data
        id data = [dataSource.globalDataMetric dataForItemAtIndexPath:indexPath];
        // cell
        id cell = self.tableView ? [self.tableView cellForRowAtIndexPath:indexPath] : [self.collectionView cellForItemAtIndexPath:indexPath];
        [dataSource _lazyLoadImagesData:data forReusableCell:cell];
    }
}

@end
