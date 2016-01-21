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

#pragma mark TCDataSourceable

@protocol TCDataSourceable <NSObject>

/// Regiseter the cell class for reuse
- (void)registerReusableCell;

/// return the cell reuse identifier for indexpath
- (nonnull NSString *)reusableCellIdentifierForIndexPath:(nonnull NSIndexPath *)indexPath;

/// load data for specific cell
- (void)loadData:(nonnull id)data forReusableCell:(nonnull id)cell;

@end


#pragma mark TCTableViewHeaderFooterViewibility

@protocol TCTableViewHeaderFooterViewibility <NSObject>

/// UITableView only, register the reuse header or footer view
- (void)registerReusableHeaderFooterView;

/// UITableView only, return the HeaderFooterView header reuse identifier for section
- (nullable NSString *)reusableHeaderViewIdentifierInSection:(NSInteger)section;
/// UITableView only, load data for specific UITableViewHeaderFooterView header
- (void)loadData:(nonnull id)data forReusableHeaderView:(nonnull UITableViewHeaderFooterView *)headerView;

/// UITableView only, return the HeaderFooterView footer reuse identifier for section
- (nullable NSString *)reusableFooterViewIdentifierInSection:(NSInteger)section;
/// UITableView only, load data for specific UITableViewHeaderFooterView footer
- (void)loadData:(nonnull id)data forReusableFooterView:(nonnull UITableViewHeaderFooterView *)footerView;

@end


#pragma mark TCCollectionSupplementaryViewibility

@protocol TCCollectionSupplementaryViewibility <NSObject>

/// UICollectionView only, regiseter the supplementary class for reuse
- (void)registerReusableSupplementaryView;

/// UICollectionView only, return the supplementary header view reuse identifier for indexPath.
- (nullable NSString *)reusableSupplementaryHeaderViewIdentifierForIndexPath:(nonnull NSIndexPath *)indexPath;
/// UICollectionView only, load data for flow layout specific supplementary header view.
- (void)loadData:(nonnull id)data forReusableSupplementaryHeaderView:(nonnull UICollectionReusableView *)reusableView;

/// UICollectionView only, return the supplementary footer view reuse identifier for indexPath.
- (nullable NSString *)reusableSupplementaryFooterViewIdentifierForIndexPath:(nonnull NSIndexPath *)indexPath;
/// UICollectionView only, load data for flow layout specific supplementary footer view.
- (void)loadData:(nonnull id)data forReusableSupplementaryFooterView:(nonnull UICollectionReusableView *)reusableView;

@end


#pragma mark TCTableViewEditable

@protocol TCTableViewEditable <NSObject>

/// Can edit the specific item
- (BOOL)canEditElementAtIndexPath:(nonnull NSIndexPath *)indexPath;

/// commit editing data behavior
- (void)commitEditingData:(nonnull id)data atIndexPath:(nonnull NSIndexPath *)indexPath;

@end


#pragma mark TCTableViewCollectionViewMovable

@protocol TCTableViewCollectionViewMovable <NSObject>

/// Can move the specific item
- (BOOL)canMoveElementAtIndexPath:(nonnull NSIndexPath *)indexPath;

/// Move data position.
- (void)moveElementAtIndexPath:(nonnull NSIndexPath *)sourceIndexPath toIndexPath:(nonnull NSIndexPath *)destinationIndexPath;

@end


#pragma mark TCImageLazyLoadable

@protocol TCImageLazyLoadable <NSObject>

/// Lazy load images.
- (void)lazyLoadImagesData:(nonnull id)data forReusableCell:(nullable id)cell;

@end