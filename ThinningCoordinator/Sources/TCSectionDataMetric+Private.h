//
//  TCSectionDataMetric+Private.h
//  ThinningCoordinator
//
//  Created by Moch Xiao on 1/21/16.
//  Copyright © @2016 Moch Xiao (https://github.com/cuzv).
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

@interface TCSectionDataMetric ()

- (void)cacheHeight:(CGFloat)height forIndex:(NSInteger)index;
- (CGFloat)cachedHeightForIndex:(NSInteger)index;

- (void)cacheSize:(CGSize)size forIndex:(NSInteger)index;
- (CGSize)cachedSizeForIndex:(NSInteger)index;

@property (nonatomic, assign, readwrite) CGFloat cachedHeightForHeader;
@property (nonatomic, assign, readwrite) CGFloat cachedHeightForFooter;

@property (nonatomic, assign, readwrite) CGSize cachedSizeForHeader;
@property (nonatomic, assign, readwrite) CGSize cachedSizeForFooter;


@end


