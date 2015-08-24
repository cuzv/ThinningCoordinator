//
//  TCGlobalDataMetric.h
//  ThinningCoordinator
//
//  Created by Moch Xiao on 8/24/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TCSectionDataMetric;
@interface TCGlobalDataMetric : NSObject

/// NSArray parameter must contains all instance kinda `TCSectionDataMetric`
- (instancetype)initWithSectionDataMetrics:(NSArray *)sectionDataMetrics;

#pragma mark - Retrieve

/// The count of sections
- (NSInteger)numberOfSections;

/// Each section items count
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/// The data which should configure for the indexPath
- (id)dataForItemAtIndexPath:(NSIndexPath *)indexPath;


/// UITableView only, the section header title
- (NSString *)titleForHeaderInSection:(NSInteger)section;

/// UITableView only, the section footer title
- (NSString *)titleForFooterInSection:(NSInteger)section;


/// UICollectionView only, the data for specific kind at indexPath
- (id)dataForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Modify

/// Add new `TCSectionDataMetric` to last for current section
- (void)appendSectionDataMetric:(TCSectionDataMetric *)sectionDataMetric;

/// Add new `TCSectionDataMetric` for current setion at specific index
- (void)insertSectionDataMetric:(TCSectionDataMetric *)sectionDataMetric atIndex:(NSInteger)index;

/// Append new data to last section data metric
- (void)appendLastSectionData:(NSArray *)data;

/// Append new data to specific section data metric
- (void)appendData:(NSArray *)data inSection:(NSInteger)section;

/// Insert specific item new data to specific section data metric
- (void)insertData:(NSArray *)data atIndexPath:(NSIndexPath *)indexPath;

/// Remove the last section data metric
- (void)removeLastSectionDataMetric;

/// Remove specific section data metric
- (void)removeSectionDataMetricAtIndex:(NSInteger)index;

/// Remove specific data for indexPath
- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath;


@end
