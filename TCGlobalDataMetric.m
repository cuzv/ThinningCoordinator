//
//  TCGlobalDataMetric.m
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


#import "TCGlobalDataMetric.h"
#import "TCSectionDataMetric.h"

@interface TCGlobalDataMetric ()
@property (nonatomic, strong) NSMutableArray *sectionDataMetrics;
@end

@implementation TCGlobalDataMetric

#pragma mark - Initializer

- (instancetype)init {
    NSAssert(NO, NSLocalizedString(@"Ues `initWithSectionDataMetrics:` instead", nil));
    return nil;
}

- (instancetype)initWithSectionDataMetrics:(NSArray *)sectionDataMetrics {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _sectionDataMetrics = [sectionDataMetrics mutableCopy];
    
    return self;
}

#pragma mark - Retrieve

- (NSInteger)numberOfSections {
    return self.sectionDataMetrics.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:section];
    return [sectionDataMetric numberOfItems];
}

- (id)dataForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:indexPath.section];
    return [sectionDataMetric dataAtIndex:indexPath.item];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:section];
    return [sectionDataMetric titleForHeader];
}

- (NSString *)titleForFooterInSection:(NSInteger)section {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:section];
    return [sectionDataMetric titleForFooter];
}

- (id)dataForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:indexPath.section];
    return [sectionDataMetric dataForSupplementaryElementOfKind:kind atIndex:indexPath.item];
}

#pragma mark - Modify

- (void)appendSectionDataMetric:(TCSectionDataMetric *)sectionDataMetric {
    [self.sectionDataMetrics addObject:sectionDataMetric];
}

- (void)insertSectionDataMetric:(TCSectionDataMetric *)sectionDataMetric atIndex:(NSInteger)index {
    NSInteger count = self.sectionDataMetrics.count;
    if (count < index) {
        NSLog(@"Index cross the bounds");
        return;
    }
    [self.sectionDataMetrics insertObject:sectionDataMetric atIndex:index];
}

- (void)appendLastSectionData:(NSArray *)data {
    [self.sectionDataMetrics.lastObject addItemsFromArray:data];
}

- (void)appendData:(NSArray *)data inSection:(NSInteger)section {
    NSInteger count = self.sectionDataMetrics.count;
    if (count < section) {
        NSLog(@"Index cross the bounds");
        return;
    }
    [[self.sectionDataMetrics objectAtIndex:section] addItemsFromArray:data];
}

- (void)insertData:(NSArray *)data atIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.sectionDataMetrics.count;
    if (count < indexPath.section) {
        NSLog(@"Index cross the bounds");
        return;
    }
    [[self.sectionDataMetrics objectAtIndex:indexPath.section] insertItemsFromArray:data atIndex:indexPath.item];
}

- (void)removeLastSectionDataMetric {
    [self.sectionDataMetrics removeLastObject];
}

- (void)removeSectionDataMetricAtIndex:(NSInteger)index {
    NSInteger count = self.sectionDataMetrics.count;
    if (count < index) {
        NSLog(@"Index cross the bounds");
        return;
    }
    [self.sectionDataMetrics removeObjectAtIndex:index];
}

- (void)removeDataAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger count = self.sectionDataMetrics.count;
    if (count < indexPath.section) {
        NSLog(@"Index cross the bounds");
        return;
    }
    [[self.sectionDataMetrics objectAtIndex:indexPath.section] removeItemAtIndex:indexPath.item];
}

#pragma mark - Description

- (NSString *)description {
    return [self _description_];
}

- (NSString *)debugDescription {
    return [self _description_];
}

- (NSString *)_description_ {
    NSMutableString *desc = [[NSMutableString alloc] initWithString:@"sectionDataMetrics: (\n"];
    for (id item in self.sectionDataMetrics) {
        [desc appendFormat:@"%@\n", item];
    }
    [desc appendFormat:@")\nsection count :%@", @(self.sectionDataMetrics.count)];
    [desc appendFormat:@"\naddress :%p", self];
    return [NSString stringWithString:desc];
}

@end
