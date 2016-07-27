//
//  TCDelegate.h
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

@class TCDataSource;
@class TCGlobalDataMetric;

@interface TCDelegate : NSObject <UITableViewDelegate, UICollectionViewDelegate>

@property (nonatomic, weak, readonly, nullable)  UITableView *tableView;
- (nullable instancetype)initWithTableView:(nonnull UITableView *)tableView;

@property (nonatomic, weak, readonly, nullable) UICollectionView *collectionView;
- (nullable instancetype)initWithCollectionView:(nonnull UICollectionView *)collectionView;

- (nonnull TCDataSource *)dataSource;
@property (nonatomic, assign, nonnull) TCGlobalDataMetric *globalDataMetric;


#pragma mark - UITableViewDelegate helper methods

/// TCDelegate subclass UITableViewDelegate require section cell height, simple return this method.
- (CGFloat)heightForRowAtIndexPath:(nullable NSIndexPath *)indexPath;

/// TCDelegate subclass UITableViewDelegate require section header view height, simple return this method.
- (CGFloat)heightForHeaderInSection:(NSInteger)section;
/// TCDelegate subclass UITableViewDelegate require section header view, simple return this method.
- (nullable UIView *)viewForHeaderInSection:(NSInteger)section;


/// TCDelegate subclass UITableViewDelegate require section footer view height, simple return this method.
- (CGFloat)heightForFooterInSection:(NSInteger)section;
/// TCDelegate subclass UITableViewDelegate require section footer view, simple return this method.
- (nullable UIView *)viewForFooterInSection:(NSInteger)section;


#pragma mark - UICollectionViewDelegate helper methods

/// TCDelegate subclass UICollectionViewDelegate flow layout require cell size, simple return this method.
- (CGSize)sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath preferredLayoutSizeFittingSize:(CGSize)fittingSize cellType:(nonnull Class)type;
/// TCDelegate subclass UICollectionViewDelegate flow layout require SupplementaryView size, simple return this method.
- (CGSize)sizeForSupplementaryViewAtIndexPath:(nonnull NSIndexPath *)indexPath preferredLayoutSizeFittingSize:(CGSize)fittingSize cellType:(nonnull Class)type ofKind:(nonnull NSString *)kind;


#pragma mark - UIScrollViewDelegate

NS_ASSUME_NONNULL_BEGIN

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView;
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
- (BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView;
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView;
- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView;

NS_ASSUME_NONNULL_END


@end



@interface TCDelegate ()

@property (nonatomic, assign) BOOL scrollingToTop;
@property (nonatomic, strong, nullable) NSValue *targetRect;

@end
