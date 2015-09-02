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
@property (nonatomic, strong) id tableHeaderData;
@property (nonatomic, strong) id tableFooterData;
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
    
    _sectionDataMetrics = [NSMutableArray new];
    [_sectionDataMetrics addObjectsFromArray:sectionDataMetrics];
    
    return self;
}

- (instancetype)initWithSectionDataMetrics:(NSArray *)sectionDataMetrics tableHeaderData:(id)tableHeaderData tableFooterData:(id)tableFooterData {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _sectionDataMetrics = [NSMutableArray new];
    [_sectionDataMetrics addObjectsFromArray:sectionDataMetrics];
    _tableHeaderData = tableHeaderData;
    _tableFooterData = tableFooterData;
    
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

- (NSArray *)allSectionDataMetrics {
    return self.sectionDataMetrics;
}

- (id)dataInSection:(NSInteger)section {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:section];
    return [sectionDataMetric allItemsData];
}

- (id)dataForItemAtIndexPath:(NSIndexPath *)indexPath {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:indexPath.section];
    return [sectionDataMetric dataAtIndex:indexPath.item];
}

- (NSIndexPath *)indexPathOfData:(id)data {
    __block NSIndexPath *indexPath = nil;
    [self.sectionDataMetrics enumerateObjectsUsingBlock:^(TCSectionDataMetric *sectionDataMetric, NSUInteger idx, BOOL *stop) {
        NSArray *items = [sectionDataMetric allItemsData];
        if ([items containsObject:data]) {
            NSInteger row = [items indexOfObjectIdenticalTo:data];
            indexPath = [NSIndexPath indexPathForItem:row inSection:idx];
            *stop = YES;
        }
    }];
    
    return indexPath;
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:section];
    return [sectionDataMetric titleForHeader];
}

- (NSString *)titleForFooterInSection:(NSInteger)section {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:section];
    return [sectionDataMetric titleForFooter];
}

- (id)dataForHeaderInSection:(NSInteger)section {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:section];
    return [sectionDataMetric dataForHeader];
}

- (id)dataForFooterInSection:(NSInteger)section {
    TCSectionDataMetric *sectionDataMetric = [self.sectionDataMetrics objectAtIndex:section];
    return [sectionDataMetric dataForFooter];
}

- (NSInteger)indexOfHeaderData:(id)data {
    NSArray *headerData = [self.sectionDataMetrics valueForKey:@"dataForHeader"];
    if ([headerData containsObject:data]) {
        return [headerData indexOfObjectIdenticalTo:data];
    }
    
    return -1;
}

- (NSInteger)indexOfFooterData:(id)data {
    NSArray *footerData = [self.sectionDataMetrics valueForKey:@"dataForFooter"];
    if ([footerData containsObject:data]) {
        return [footerData indexOfObjectIdenticalTo:data];
    }
    
    return -1;
}

- (id)dataForHeader {
    return self.tableHeaderData;
}

- (id)dataForFooter {
    return self.tableFooterData;
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
    [[self.sectionDataMetrics objectAtIndex:indexPath.section] insertItemsDataFromArray:data atIndex:indexPath.item];
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
    [[self.sectionDataMetrics objectAtIndex:indexPath.section] removeDataForItemAtIndex:indexPath.item];
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
