//
//  TCDataSource+Private.h
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

#import "TCDataSource.h"

@protocol TCImageLazyLoadable;

@interface TCDataSource ()

@property (nonatomic, weak, readonly, nullable) id<TCImageLazyLoadable> lazyLoadable;

#pragma mark - UITableViewDelegate helper methods

/// TCDelegate subclass UITableViewDelegate require row height, simple return this method
- (CGFloat)_heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath;

/// TCDelegate subclass UITableViewDelegate require header view height, simple return this method
- (CGFloat)_heightForHeaderInSection:(NSInteger)section;
/// TCDelegate subclass UITableViewDelegate require footer view, simple return this method
- (nullable UIView *)_viewForHeaderInSection:(NSInteger)section;

/// TCDelegate subclass UITableViewDelegate require footer view height, simple return this method
- (CGFloat)_heightForFooterInSection:(NSInteger)section;
/// TCDelegate subclass UITableViewDelegate require footer view, simple return this method
- (nullable UIView *)_viewForFooterInSection:(NSInteger)section;


#pragma mark - UICollectionViewDelegate helper methods

- (CGSize)_sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath preferredLayoutSizeFittingSize:(CGSize)fittingSize cellType:(nonnull Class)type;
- (CGSize)_sizeForSupplementaryViewAtIndexPath:(nonnull NSIndexPath *)indexPath preferredLayoutSizeFittingSize:(CGSize)fittingSize cellType:(nonnull Class)type ofKind:(nonnull NSString *)kind;

@end
