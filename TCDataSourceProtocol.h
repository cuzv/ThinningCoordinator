//
//  TCDataSourceProtocol.h
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

@protocol TCDataSourceProtocol <NSObject>

@required

/// Regiseter the cell class for reuse
- (void)registerReusableCell;

/// return the cell reuse identifier for indexpath
- (NSString *)reusableCellIdentifierForIndexPath:(NSIndexPath *)indexPath;

/// load data for specific cell
- (void)loadData:(id)data forReusableCell:(id)cell;

@optional

/// UITableView only, register the reuse header or footer view
- (void)registerReusableHeaderFooterView;

/// UITableView only, return the HeaderFooterView reuse identifier for section
- (NSString *)reusableHeaderFooterViewIdentifierInSection:(NSInteger)section;

/// UITableView only, load data for specific UITableViewHeaderFooterView
- (void)loadData:(id)data forReusableHeaderFooterView:(UITableViewHeaderFooterView *)headerFooterView;

/// UICollectionView only, regiseter the supplementary class for reuse
- (void)registerReusableSupplementaryView;

/// UICollectionView only, return the supplementary view reuse identifier for indexpath
- (NSString *)reusableSupplementaryViewIdentifierForIndexPath:(NSIndexPath *)indexPath ofKind:(NSString *)kind;

/// UICollectionView only, load data for specific supplementary view
- (void)loadData:(id)data forReusableSupplementaryView:(UICollectionReusableView *)reusableView;

/// Return the section index title
- (NSString *)indexTitleForSectionDataMetric:(TCSectionDataMetric *)sectionDataMetric;

/// Can edit the specific item
- (BOOL)canEditItemAtIndexPath:(NSIndexPath *)indexPath;

/// commit editing data behavior
- (void)commitEditingData:(id)data atIndexPath:(NSIndexPath *)indexPath;

/// Can move the specific item
- (BOOL)canMoveItemAtIndexPath:(NSIndexPath *)indexPath;

/// Lazy load images
- (void)lazyLoadImagesData:(id)data forReusableCell:(id)cell;

@end
