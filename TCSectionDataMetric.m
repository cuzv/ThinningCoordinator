//
//  TCSectionData.m
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


#import "TCSectionDataMetric.h"

@interface TCSectionDataMetric ()
@property (nonatomic, copy) NSString *titleForHeader;
@property (nonatomic, copy) NSString *titleForFooter;
@property (nonatomic, strong) id dataForHeader;
@property (nonatomic, strong) id dataForFooter;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, strong) NSDictionary *dataForSupplementaryElements;
@end

@implementation TCSectionDataMetric

#pragma mark - Initializer

- (instancetype)init {
    NSAssert(NO, NSLocalizedString(@"Ues designed initializer instead", nil));
    return nil;
}

- (instancetype)initWithItems:(NSArray *)items {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _items = [items mutableCopy];
    
    return self;
}

- (instancetype)initWithItems:(NSArray *)items titleForHeader:(NSString *)titleForHeader titleForFooter:(NSString *)titleForFooter {
    self = [self initWithItems:items];
    
    _titleForHeader = titleForHeader;
    _titleForFooter = titleForFooter;
    
    return self;
}

- (instancetype)initWithItems:(NSArray *)items dataForHeader:(id)dataForHeader dataForFooter:(id)dataForFooter {
    self = [self initWithItems:items];
    
    _dataForHeader = dataForHeader;
    _dataForFooter = dataForFooter;
    
    return self;
}

- (instancetype)initWithItems:(NSArray *)items dataForSupplementaryElements:(NSDictionary *)dataForSupplementaryElements {
    self = [self initWithItems:items];
    
    _dataForSupplementaryElements = dataForSupplementaryElements;
    
    return self;
}

#pragma mark - Retrieve

- (NSInteger)numberOfItems {
    return self.items.count;
}

- (NSArray *)allItems {
    return self.items;
}

- (id)dataAtIndex:(NSInteger)index {
    return [self.items objectAtIndex:index];
}

- (id)dataForSupplementaryElementOfKind:(NSString *)kind atIndex:(NSInteger)index {
    NSArray *data = [self.dataForSupplementaryElements objectForKey:kind];
    return [data objectAtIndex:index];
}

#pragma mark - Modify

- (void)addItemsFromArray:(NSArray *)data {
    [self.items addObjectsFromArray:data];
}

- (void)insertItemsFromArray:(NSArray *)data atIndex:(NSInteger)index {
    NSInteger count = self.items.count;
    if (index > count) {
        NSLog(@"Index cross the bounds");
        return;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, data.count)];
    [self.items insertObjects:data atIndexes:indexSet];
}

- (void)removeItemAtIndex:(NSInteger)index {
    NSInteger count = self.items.count;
    if (index > count) {
        NSLog(@"Index cross the bounds");
        return;
    }
    
    [self.items removeObjectAtIndex:index];
}

#pragma mark - Description

- (NSString *)description {
    return [self _description_];
}

- (NSString *)debugDescription {
    return [self _description_];
}

- (NSString *)_description_ {
    NSMutableString *desc = [[NSMutableString alloc] initWithString:@"items: (\n"];
    for (id item in self.items) {
        [desc appendFormat:@"%@\n", item];
    }
    [desc appendFormat:@")\nitems count :%@, \n", @(self.items.count)];
    
    return [NSString stringWithString:desc];
}

#pragma mark - Helpers

+ (NSDictionary *)supplementaryElementsWithHeaderData:(NSArray *)headerData footerData:(NSArray *)footerData {
    NSDictionary *supplementaryElements = @{UICollectionElementKindSectionHeader: headerData,
                                            UICollectionElementKindSectionFooter: footerData};
    return supplementaryElements;
}



@end
