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
#import "TCSectionDataMetric+Private.h"
#import "TCHelper.h"

@interface TCSectionDataMetric ()
@property (nonatomic, strong, readwrite, nonnull) NSMutableArray *itemsData;
@property (nonatomic, copy, nonnull) NSString *titleForHeader;
@property (nonatomic, copy, nonnull) NSString *titleForFooter;
@property (nonatomic, strong, nonnull) id dataForHeader;
@property (nonatomic, strong, nonnull) id dataForFooter;
@property (nonatomic, copy, nonnull) NSString *indexTitle;

@property (nonatomic, strong, nonnull) NSArray *dataForSupplementaryHeader;
@property (nonatomic, strong, nonnull) NSArray *dataForSupplementaryFooter;

@property (nonatomic, strong) NSMutableArray<NSNumber *> *cachedHeightForCell;
@property (nonatomic, strong) NSMutableArray<NSValue *> *cachedSizeForCell;

@end

@implementation TCSectionDataMetric

#pragma mark - Initializer

- (nullable instancetype)init {
    [NSException raise:@"Ues designed initializer instead" format:@""];
    return nil;
}

- (nullable instancetype)initWithItemsData:(nonnull NSArray *)itemsData {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _itemsData = [itemsData mutableCopy];
    
    return self;
}

- (nullable instancetype)initWithItemsData:(nonnull NSArray *)itemsData indexTitle:(nonnull NSString *)indexTitle {
    self = [self initWithItemsData:itemsData];

    _indexTitle = indexTitle;
    
    return self;
}

- (nullable instancetype)initWithItemsData:(nonnull NSArray *)itemsData titleForHeader:(nonnull NSString *)titleForHeader titleForFooter:(nonnull NSString *)titleForFooter {
    self = [self initWithItemsData:itemsData];
    
    _titleForHeader = titleForHeader;
    _titleForFooter = titleForFooter;
    
    return self;
}

- (nullable instancetype)initWithItemsData:(nonnull NSArray *)itemsData titleForHeader:(nonnull NSString *)titleForHeader titleForFooter:(nonnull NSString *)titleForFooter indexTitle:(nonnull NSString *)indexTitle {
    self = [self initWithItemsData:itemsData titleForHeader:titleForHeader titleForFooter:titleForFooter];
    
    _indexTitle = indexTitle;
    
    return self;
}

- (nullable instancetype)initWithItemsData:(nonnull NSArray *)itemsData dataForHeader:(nonnull id)dataForHeader dataForFooter:(nonnull id)dataForFooter {
    self = [self initWithItemsData:itemsData];
    
    _dataForHeader = dataForHeader;
    _dataForFooter = dataForFooter;
    
    return self;
}

- (nullable instancetype)initWithItemsData:(nonnull NSArray *)itemsData dataForHeader:(nonnull id)dataForHeader dataForFooter:(nonnull id)dataForFooter indexTitle:(nonnull NSString *)indexTitle {
    self = [self initWithItemsData:itemsData dataForHeader:dataForHeader dataForFooter:dataForFooter];
    _indexTitle = indexTitle;
    return self;
}

- (nullable instancetype)initWithItemsData:(nonnull NSArray *)itemsData dataForSupplementaryHeader:(nonnull NSArray *)dataForSupplementaryHeader dataForSupplementaryFooter:(nonnull NSArray *)dataForSupplementaryFooter {
   self = [self initWithItemsData:itemsData];
    
    _dataForSupplementaryHeader = dataForSupplementaryHeader;
    _dataForSupplementaryFooter = dataForSupplementaryFooter;
    
    return self;
}

+ (nullable instancetype)empty {
    return [[[self class] alloc] initWithItemsData:@[]];
}

- (NSMutableArray<NSNumber *> *)cachedHeightForCell {
    if (!_cachedHeightForCell) {
        NSInteger count = self.numberOfItems;
        _cachedHeightForCell = [[NSMutableArray alloc] initWithCapacity:count];
        for (int index = 0; index < count; index++) {
            [_cachedHeightForCell addObject:@(UITableViewAutomaticDimension)];
        }
    }
    
    return _cachedHeightForCell;
}


- (NSMutableArray<NSValue *> *)cachedSizeForCell {
    if (!_cachedSizeForCell) {
        NSInteger count = self.numberOfItems;
        _cachedSizeForCell = [[NSMutableArray alloc] initWithCapacity:count];
        for (int index = 0; index < count; index++) {
            [_cachedSizeForCell addObject:[NSValue valueWithCGSize:CGSizeZero]];
        }
    }
    
    return _cachedSizeForCell;
}


#pragma mark - Retrieve

- (NSInteger)numberOfItems {
    return _itemsData.count;
}

- (nonnull NSArray *)itemsData {
    return _itemsData;
}

- (nullable id)dataAtIndex:(NSInteger)index {
    if (self.numberOfItems <= index) {
        return nil;
    }

    return self.itemsData[index];
}

- (nullable NSString *)titleForHeader {
    return _titleForHeader;
}

- (nullable NSString *)titleForFooter {
    return _titleForFooter;
}

- (nullable id)dataForHeader {
    return _dataForHeader;
}

- (nullable id)dataForFooter {
    return _dataForFooter;
}

- (nullable NSString *)indexTitle {
    return _indexTitle;
}

- (nullable id)dataForSupplementaryHeaderAtIndex:(NSInteger)index {
    if (self.dataForSupplementaryHeader.count <= index) {
        return nil;
    }
    
    return self.dataForSupplementaryHeader[index];
}

- (nullable id)dataForSupplementaryFooterAtIndex:(NSInteger)index {
    if (self.dataForSupplementaryFooter.count <= index) {
        return nil;
    }
    
    return self.dataForSupplementaryFooter[index];
}


#pragma mark - Modify

- (void)append:(nonnull id)data {
    [_itemsData addObject:data];
}

- (void)appendContentsOf:(nonnull NSArray *)data {
    [_itemsData addObjectsFromArray:data];
}

- (void)addItemsDataFromArray:(NSArray *)data {
    [self appendContentsOf:data];
}

- (void)insert:(nonnull id)data atIndex:(NSInteger)index {
    [self insertContentsOf:@[data] atIndex:index];
}

- (void)insertContentsOf:(nonnull NSArray *)data atIndex:(NSInteger)index {
    validateInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    [_itemsData insertObjects:data atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, data.count)]];
}

- (void)insertItemsDataFromArray:(NSArray *)data atIndex:(NSInteger)index {
    [self insertContentsOf:data atIndex:index];
}

- (void)replaceWith:(nonnull id)data atIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    [_itemsData replaceObjectAtIndex:index withObject:data];
}

- (void)replaceWithNewData:(id)data atIndex:(NSInteger)index {
    [self replaceWith:data atIndex:index];
}

- (void)replaceWithContentsOf:(nonnull NSArray *)data atIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    [_itemsData replaceObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, data.count)] withObjects:data];
}

- (void)replaceWithNewDataArray:(NSArray *)data atIndex:(NSInteger)index {
    [self replaceWithContentsOf:data atIndex:index];
}

- (nonnull id)removeFirst {
    if ([_itemsData count] <= 0) {
        return nil;
    }

    id first = _itemsData.firstObject;
    [_itemsData removeObjectAtIndex:0];
    
    return first;
}

- (nonnull id)removeLast {
    id last = _itemsData.lastObject;
    [_itemsData removeLastObject];

    return last;
}

- (nullable id)removeAtIndex:(NSInteger)index {
    if (self.numberOfItems <= index) {
        return nil;
    }
    
    id removed = [_itemsData objectAtIndex:index];
    [_itemsData removeObjectAtIndex:index];
    
    return removed;
}

- (nullable id)removeDataForItemAtIndex:(NSInteger)index {
    return [self removeAtIndex:index];
}

- (nullable NSArray *)removeAll {
    NSArray *removed = [[NSArray alloc] initWithArray:_itemsData];
    [_itemsData removeAllObjects];
    return removed;
}

- (void)exchangeElementAtIndex:(NSInteger)index withElementAtIndex:(NSInteger)otherIndex {
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    [_itemsData exchangeObjectAtIndex:index withObjectAtIndex:otherIndex];
}

- (void)exchangeDataAtIndex:(NSInteger)sourceIndex withDataAtIndex:(NSInteger)destinationIndex {
    [self exchangeElementAtIndex:sourceIndex withElementAtIndex:destinationIndex];
}

- (void)moveElementAtIndex:(NSInteger)index toIndex:(NSInteger)otherIndex {
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    if (index == otherIndex) {
        return;
    }
    
    id moved = [_itemsData objectAtIndex:index];
    [_itemsData removeObjectAtIndex:index];
    [_itemsData insertObject:moved atIndex:otherIndex];
}

#pragma mark - Cache Height

- (void)cacheHeight:(CGFloat)height forIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    _cachedHeightForCell[index] = @(height);
}
- (CGFloat)cachedHeightForIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
#if defined(__LP64__) && __LP64__
    return [_cachedHeightForCell[index] doubleValue];
#else
    return [_cachedHeightForCell[index] floatValue];
#endif
}

- (void)cacheSize:(CGSize)size forIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    _cachedSizeForCell[index] = [NSValue valueWithCGSize:size];
}

- (CGSize)cachedSizeForIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    return [_cachedSizeForCell[index] CGSizeValue];
}

- (void)invalidateCachedCellHeightForIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    _cachedHeightForCell[index] = @(UITableViewAutomaticDimension);
}

- (void)invalidateCachedCellSizeForIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(_itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    _cachedSizeForCell[index] = [NSValue valueWithCGSize:CGSizeZero];
}

- (void)invalidateCachedHeightForHeader {
    _cachedHeightForHeader = 0.0f;
}

- (void)invalidateCachedHeightForFooter {
    _cachedHeightForFooter = 0.0f;
}

- (void)invalidateCachedSizeForHeader {
    _cachedSizeForHeader = CGSizeZero;
}

- (void)invalidateCachedSizeForFooter {
    _cachedSizeForFooter = CGSizeZero;
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

@end

