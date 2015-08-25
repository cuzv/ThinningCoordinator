//
//  TCSectionData.h
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


#import <Foundation/Foundation.h>

@interface TCSectionDataMetric : NSObject

- (instancetype)initWithItems:(NSArray *)items;

/// UITableView only
- (instancetype)initWithItems:(NSArray *)items titleForHeader:(NSString *)titleForHeader titleForFooter:(NSString *)titleForFooter;

/// UITableView only, Data means which delegate method request for custom viewForHeader/viewForFooter needs
- (instancetype)initWithItems:(NSArray *)items dataForHeader:(id)dataForHeader dataForFooter:(id)dataForFooter;

/// UICollectionView only, NSDictionary keys like `UICollectionElementKindSectionHeader`/`UICollectionElementKindSectionFooter`...
- (instancetype)initWithItems:(NSArray *)items dataForSupplementaryElements:(NSDictionary *)dataForSupplementaryElements;

#pragma mark - Retrieve

/// Section data count
- (NSInteger)numberOfItems;

/// All data
- (NSArray *)allItems;

/// Return specific data
- (id)dataAtIndex:(NSInteger)index;


/// UITableView only, the section header title
- (NSString *)titleForHeader;

/// UITableView only, the section footer title
- (NSString *)titleForFooter;

/// UITableView only, the section header data
- (id)dataForHeader;

/// UITableView only, the section footer data
- (id)dataForFooter;


/// UICollectionView only, return specific supplementary element data
- (id)dataForSupplementaryElementOfKind:(NSString *)kind atIndex:(NSInteger)index;

#pragma mark - Modify

/// Add new data for current section data metric
- (void)addItemsFromArray:(NSArray *)data;

/// Add new data for current setion data metric at specific index
- (void)insertItemsFromArray:(NSArray *)data atIndex:(NSInteger)index;

/// Remove specific data at index
- (void)removeItemAtIndex:(NSInteger)index;

#pragma mark - Helpers

/// Build data for initializer
+ (NSDictionary *)supplementaryElementsWithHeaderData:(NSArray *)headerData footerData:(NSArray *)footerData;

@end
