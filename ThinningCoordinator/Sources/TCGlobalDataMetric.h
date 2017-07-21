//
//  TCGlobalDataMetric.h
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

#import <UIKit/UIKit.h>

@class TCSectionDataMetric;
@interface TCGlobalDataMetric : NSObject

/// NSArray parameter must contains all instance kinda `TCSectionDataMetric`.
- (nullable instancetype)initWithSectionDataMetrics:(nonnull NSArray<TCSectionDataMetric *> *)sectionDataMetrics;
/// UITableView only.
- (nullable instancetype)initWithSectionDataMetrics:(nonnull NSArray<TCSectionDataMetric *> *)sectionDataMetrics dataForHeader:(nonnull id)dataForHeader dataForFooter:(nonnull id)dataForFooter;

/// Return empty instance
+ (nullable instancetype)empty;

#pragma mark - Retrieve

/// The count of sections
- (NSInteger)numberOfSections;

/// Each section items count
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/// The data from specific section
- (nullable NSArray *)dataInSection:(NSInteger)section;

/// The data which should configure for the indexPath
- (nullable id)dataForItemAtIndexPath:(nonnull NSIndexPath *)indexPath;

/// Return the data indexPath in UITableview/UICollection
- (nullable NSIndexPath *)indexPathOfData:(nonnull id)data;

/// Return the all section data metrics
/// **Note**: Prepared for swift convert.
- (nullable NSArray<TCSectionDataMetric *> *)allSectionDataMetrics __attribute__((deprecated("use `sectionDataMetrics:` instead.")));

/// Return the all section data metrics
- (nullable NSArray<TCSectionDataMetric *> *)sectionDataMetrics;

/// All data.
- (nullable NSArray *)allData;


/// UITableView only, return the specific section header title
- (nullable NSString *)titleForHeaderInSection:(NSInteger)section;

/// UITableView only, return the specific section footer title
- (nullable NSString *)titleForFooterInSection:(NSInteger)section;

/// UITableView only, return the specific section header data
- (nullable id)dataForHeaderInSection:(NSInteger)section;

/// UITableView only, return the specific section header data
- (nullable id)dataForFooterInSection:(NSInteger)section;

/// UITableView only, return the specific header index
- (NSInteger)indexOfHeaderData:(nonnull id)data;

/// UITableView only, return the specific footer index
- (NSInteger)indexOfFooterData:(nonnull id)data;

/// UITableView only, return the table view header data
- (nullable id)dataForHeader;

/// UITableView only, return the table view footer data
- (nullable id)dataForFooter;

/// UICollectionView only, the data for specific kind at indexPath
- (nullable id)dataForSupplementaryHeaderAtIndexPath:(nonnull NSIndexPath *)indexPath;

/// UICollectionView only, the data for specific kind at indexPath
- (nullable id)dataForSupplementaryFooterAtIndexPath:(nonnull NSIndexPath *)indexPath;

/// UICollectionView only,
- (nullable id)dataForSupplementaryElementOfKind:(nonnull NSString *)kind atIndexPath:(nonnull NSIndexPath *)indexPath __attribute__((deprecated("use `dataForSupplementaryHeaderAtIndexPath:` or `dataForSupplementaryFooterAtIndexPath` instead.")));

/// Private: Section index titles.
- (nullable NSArray<NSString *> *)sectionIndexTitles;

#pragma mark - Modify

/// Append single `TCSectionDataMetric` to last for current section.
- (void)append:(nonnull TCSectionDataMetric *)sectionDataMetric;

/// Add new `TCSectionDataMetric` to last for current section
- (void)appendSectionDataMetric:(nonnull TCSectionDataMetric *)sectionDataMetric __attribute__((deprecated("use `append:` instead.")));

/// Append multiple `TCSectionDataMetric` collection to last for current section.
- (void)appendContentsOf:(nonnull NSArray<TCSectionDataMetric *> *)sectionDataMetrics;

/// Append single `TCSectionDataMetric` for current setion at specific index.
- (void)insert:(nonnull TCSectionDataMetric *)sectionDataMetric atIndex:(NSInteger)index;

/// Append multiple `TCSectionDataMetric` for current setion at specific index.
- (void)insertContentsOf:(nonnull NSArray<TCSectionDataMetric *> *)sectionDataMetrics atIndex:(NSInteger)index;;

/// Add new `TCSectionDataMetric` for current setion at specific index
- (void)insertSectionDataMetric:(nonnull TCSectionDataMetric *)sectionDataMetric atIndex:(NSInteger)index __attribute__((deprecated("use `insert:atIndex:` instead.")));

/// Append single data to last section data metric.
- (void)appendLastSection:(nonnull id )data;

/// Append multiple data to last section data metric.
- (void)appendLastSectionContentsOf:(nonnull NSArray *)data;

/// Append new data to last section data metric
- (void)appendLastSectionData:(nonnull NSArray *)data __attribute__((deprecated("use `appendLastSectionContentsOf:` instead.")));

/// Append single data to specific section data metric.
- (void)append:(nullable id)data inSection:(NSInteger)section;

/// Append multiple data to specific section data metric.
- (void)appendContentsOf:(nullable NSArray *)data inSection:(NSInteger)section;

/// Append new data to specific section data metric
- (void)appendData:(nonnull NSArray *)data inSection:(NSInteger)section __attribute__((deprecated("use `appendContentsOf:inSection:` instead.")));

/// Insert single data to specific section & item data metric.
- (void)insert:(nonnull id)data atIndexPath:(nonnull NSIndexPath *)indexPath;

/// Insert multiple data to specific section & item data metric.
- (void)insertContentsOf:(nonnull NSArray *)data atIndexPath:(nonnull NSIndexPath *)indexPath;

/// Insert specific item new data to specific section data metric
- (void)insertData:(nonnull NSArray *)data atIndexPath:(nonnull NSIndexPath *)indexPath __attribute__((deprecated("use `insertContentsOf:atIndexPath` instead.")));

/// Replace single data to specific section data metric.
- (void)replaceWith:(nonnull id)data atIndexPath:(nonnull NSIndexPath *)indexPath;

/// Replace multiple data to specific section data metric.
- (void)replaceWithContentsOf:(nonnull NSArray *)data atIndexPath:(nonnull NSIndexPath *)indexPath;

/// Replace specific item new data to specific section data metric
- (void)replaceData:(nonnull NSArray *)data atIndexPath:(nonnull NSIndexPath *)indexPath __attribute__((deprecated("use `replaceContentsOf:atIndexPath:` instead.")));

/// Remove the first section data metric.
- (nullable TCSectionDataMetric *)removeFirst;

/// Remove the last section data metric.
- (nullable TCSectionDataMetric *)removeLast;

/// Remove specific section data metric.
- (nullable TCSectionDataMetric *)removeAtIndex:(NSInteger)index;

/// Remove specific data for indexPath.
- (nullable id)removeAtIndexPath:(nonnull NSIndexPath *)indexPath;

/// Remove specific data for indexPaths.
- (nullable NSArray<id> *)removeAtIndexPaths:(nonnull NSArray<NSIndexPath *> *)indexPaths;

/// Remove all data.
- (nullable NSArray *)removeAll;

/// Remove the last section data metric
- (nullable TCSectionDataMetric *)removeLastSectionDataMetric __attribute__((deprecated("use `removeLast` instead.")));

/// Remove specific section data metric
- (nullable TCSectionDataMetric *)removeSectionDataMetricAtIndex:(NSInteger)index __attribute__((deprecated("use `removeAtIndex:` instead.")));

/// Remove specific data for indexPath
- (nullable id)removeDataAtIndexPath:(nonnull NSIndexPath *)indexPath __attribute__((deprecated("use `removeAtIndexPath:` instead.")));

/// Exchange data.
- (void)exchageAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath withIndexPath:(nonnull NSIndexPath *)destinationIndexPath;

/// Move data.
- (void)moveAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath;

#pragma mark - Cache Size & Height

- (void)invalidateCachedCellHeightForIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)invalidateCachedCellSizeForIndexPath:(nonnull NSIndexPath *)indexPath;
- (void)invalidateCachedHeightForHeaderInSection:(NSInteger)section;
- (void)invalidateCachedHeightForFooterInSection:(NSInteger)section;
- (void)invalidateCachedSizeForHeaderInSection:(NSInteger)section;
- (void)invalidateCachedSizeForFooterInSection:(NSInteger)section;

@end
