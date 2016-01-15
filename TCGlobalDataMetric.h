//
//  TCGlobalDataMetric.h
//  ThinningCoordinator
//
//  Created by Moch Xiao on 8/24/15.
//  Copyright (c) 2015 Moch Xiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCSectionDataMetric;
@interface TCGlobalDataMetric : NSObject

/// NSArray parameter must contains all instance kinda `TCSectionDataMetric`
- (instancetype)initWithSectionDataMetrics:(NSArray<__kindof TCSectionDataMetric *> *)sectionDataMetrics;
/// UITableView only
- (instancetype)initWithSectionDataMetrics:(NSArray<__kindof TCSectionDataMetric *> *)sectionDataMetrics tableHeaderData:(id)tableHeaderData tableFooterData:(id)tableFooterData;

/// Return empty instance
+ (instancetype)empty;

#pragma mark - Retrieve

/// The count of sections
- (NSInteger)numberOfSections;

/// Each section items count
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/// Return the all section data metrics
/// **Note**: Prepared for swift convert.
- (NSArray<__kindof TCSectionDataMetric *> *)allSectionDataMetrics;

/// Return the all section data metrics
- (NSArray<__kindof TCSectionDataMetric *> *)sectionDataMetrics;

/// The data from specific section
- (NSArray *)dataInSection:(NSInteger)section;

/// The data which should configure for the indexPath
- (id)dataForItemAtIndexPath:(NSIndexPath *)indexPath;

/// Return the data indexPath in UITableview/UICollection
- (NSIndexPath *)indexPathOfData:(id)data;


/// UITableView only, return the specific section header title
- (NSString *)titleForHeaderInSection:(NSInteger)section;

/// UITableView only, return the specific section footer title
- (NSString *)titleForFooterInSection:(NSInteger)section;

/// UITableView only, return the specific section header data
- (id)dataForHeaderInSection:(NSInteger)section;

/// UITableView only, return the specific section header data
- (id)dataForFooterInSection:(NSInteger)section;

/// UITableView only, return the specific header index
- (NSInteger)indexOfHeaderData:(id)data;

/// UITableView only, return the specific footer index
- (NSInteger)indexOfFooterData:(id)data;

/// UITableView only, return the table view header data
- (id)dataForHeader;

/// UITableView only, return the table view footer data
- (id)dataForFooter;

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

/// Replace specific item new data to specific section data metric
- (void)replaceData:(NSArray *)data atIndexPath:(NSIndexPath *)indexPath;

/// Remove the last section data metric
- (void)removeLastSectionDataMetric;

/// Remove specific section data metric
- (void)removeSectionDataMetricAtIndex:(NSInteger)index;

/// Remove specific data for indexPath
- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath;


@end
