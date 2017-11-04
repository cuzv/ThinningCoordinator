//
//  TCGlobalDataMetric.h
//  ThinningCoordinator
//
//  Created by Roy Shaw on 8/24/15.
//  Copyright (c) 2015 Red Rain (https://github.com/cuzv).
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

#import "TCGlobalDataMetric.h"

@interface TCGlobalDataMetric ()

- (void)cacheHeight:(CGFloat)height forIndexPath:(nonnull NSIndexPath *)indexPath;
- (CGFloat)cachedHeightForIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)cacheSize:(CGSize)size forIndexPath:(nonnull NSIndexPath *)indexPath;
- (CGSize)cachedSizeForIndexPath:(nonnull NSIndexPath *)indexPath;

- (void)cacheHeight:(CGFloat)height forHeaderInSection:(NSInteger)section;
- (CGFloat)cachedHeightForHeaderInSection:(NSInteger)section;

- (void)cacheSize:(CGSize)size forHeaderInSection:(NSInteger)section;
- (CGSize)cachedSizeForHeaderInSection:(NSInteger)section;

- (void)cacheHeight:(CGFloat)height forFooterInSection:(NSInteger)section;
- (CGFloat)cachedHeightForFooterInSection:(NSInteger)section;

- (void)cacheSize:(CGSize)size forFooterInSection:(NSInteger)section;
- (CGSize)cachedSizeForFooterInSection:(NSInteger)section;

@end
