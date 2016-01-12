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
@property (nonatomic, strong) NSMutableArray *itemsData;
@property (nonatomic, strong) NSDictionary *dataForSupplementaryElements;
@end

@implementation TCSectionDataMetric

#pragma mark - Initializer

- (instancetype)init {
    NSAssert(NO, NSLocalizedString(@"Ues designed initializer instead", nil));
    return nil;
}

- (instancetype)initWithItemsData:(NSArray *)itemsData {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _itemsData = [itemsData mutableCopy];
    
    return self;
}

- (instancetype)initWithItemsData:(NSArray *)itemsData titleForHeader:(NSString *)titleForHeader titleForFooter:(NSString *)titleForFooter {
    self = [self initWithItemsData:itemsData];
    
    _titleForHeader = titleForHeader;
    _titleForFooter = titleForFooter;
    
    return self;
}

- (instancetype)initWithItemsData:(NSArray *)itemsData dataForHeader:(id)dataForHeader dataForFooter:(id)dataForFooter {
    self = [self initWithItemsData:itemsData];
    
    _dataForHeader = dataForHeader;
    _dataForFooter = dataForFooter;
    
    return self;
}

- (instancetype)initWithItemsData:(NSArray *)itemsData dataForSupplementaryElements:(NSDictionary *)dataForSupplementaryElements {
    self = [self initWithItemsData:itemsData];
    
    _dataForSupplementaryElements = dataForSupplementaryElements;
    
    return self;
}

#pragma mark - Retrieve

- (NSInteger)numberOfItems {
    return self.itemsData.count;
}

- (NSArray *)allItemsData {
    return _itemsData;
}

- (NSArray *)itemsData {
    return _itemsData;
}

- (id)dataAtIndex:(NSInteger)index {
    return [self.itemsData objectAtIndex:index];
}

- (id)dataForSupplementaryElementOfKind:(NSString *)kind atIndex:(NSInteger)index {
    NSArray *data = [self.dataForSupplementaryElements objectForKey:kind];
    return [data objectAtIndex:index];
}

#pragma mark - Modify

- (void)addItemsDataFromArray:(NSArray *)data {
    [_itemsData addObjectsFromArray:data];
}

- (void)insertItemsDataFromArray:(NSArray *)data atIndex:(NSInteger)index {
    NSInteger count = self.itemsData.count;
    if (count <= index) {
        NSLog(@"Index cross the bounds");
        return;
    }
    
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, data.count)];
    [_itemsData insertObjects:data atIndexes:indexSet];
}

- (void)replaceWithNewData:(id)data atIndex:(NSInteger)index {
    NSInteger count = self.itemsData.count;
    if (count <= index) {
        NSLog(@"Index cross the bounds");
        return;
    }

    [_itemsData replaceObjectAtIndex:index withObject:data];
}

- (void)replaceWithNewDataArray:(NSArray *)data atIndex:(NSInteger)index {
    NSInteger count = self.itemsData.count;
    if (count <= index) {
        NSLog(@"Index cross the bounds");
        return;
    }

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, data.count)];
    [_itemsData replaceObjectsAtIndexes:indexSet withObjects:data];
}

- (void)removeDataForItemAtIndex:(NSInteger)index {
    NSInteger count = self.itemsData.count;
    if (count <= index) {
        NSLog(@"Index cross the bounds");
        return;
    }
    
    [_itemsData removeObjectAtIndex:index];
}

- (void)exchangeDataAtIndex:(NSInteger)sourceIndex withDataAtIndex:(NSInteger)destinationIndex {
    NSInteger count = self.itemsData.count;
    if (count <= sourceIndex ||
        count <= destinationIndex) {
        NSLog(@"Index cross the bounds");
        return;
    }
    
    [_itemsData exchangeObjectAtIndex:sourceIndex withObjectAtIndex:destinationIndex];
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
    for (id item in self.itemsData) {
        [desc appendFormat:@"%@\n", item];
    }
    [desc appendFormat:@")\nitems count :%@, \n", @(self.itemsData.count)];
    
    return [NSString stringWithString:desc];
}

#pragma mark - Helpers

+ (NSDictionary *)supplementaryElementsWithHeaderData:(NSArray *)headerData footerData:(NSArray *)footerData {
    if (!headerData && !footerData) {
        return nil;
    }

    NSMutableDictionary *supplementaryElements = [NSMutableDictionary new];
    if (headerData) {
        [supplementaryElements setObject:headerData forKey:UICollectionElementKindSectionHeader];
    }
    if (footerData) {
        [supplementaryElements setObject:footerData forKey:UICollectionElementKindSectionFooter];
    }

    return supplementaryElements;
}



@end
