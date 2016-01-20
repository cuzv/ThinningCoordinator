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
@interface TCDelegate : NSObject <UITableViewDelegate, UICollectionViewDelegate>

@property (nonatomic, weak, readonly) UITableView *tableView;
- (instancetype)initWithTableView:(UITableView *)tableView;

#pragma mark - UITableViewDelegate helper methods

/// TCDelegate subclass UITableViewDelegate require section header view, simple return this method
- (UIView *)viewForHeaderInSection:(NSInteger)section;

/// TCDelegate subclass UITableViewDelegate require section footer view, simple return this method
- (UIView *)viewForFooterInSection:(NSInteger)section;

/// TCDelegate subclass UITableViewDelegate require section header view height, simple return this method
- (CGFloat)heightForHeaderInSection:(NSInteger)section;

/// TCDelegate subclass UITableViewDelegate require section footer view height, simple return this method
- (CGFloat)heightForFooterInSection:(NSInteger)section;


@property (nonatomic, weak, readonly) UICollectionView *collectionView;
- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

#pragma mark - UIScrollViewDelegate

/// Implemented by `TCDelegate`, If you wanna implement you own version, invoke super first
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;

/// Implemented by `TCDelegate`, If you wanna implement you own version, invoke super first
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView;

#pragma mark - Helper

@property (nonatomic, weak, readonly) TCDataSource *dataSource;

@end