//
//  TCSectionData.m
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
    _cachedHeightForHeader = UITableViewAutomaticDimension;
    _cachedHeightForFooter = UITableViewAutomaticDimension;
    _cachedSizeForHeader = CGSizeZero;
    _cachedSizeForFooter = CGSizeZero;
    
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
    
    [self.cachedHeightForCell addObject:@(UITableViewAutomaticDimension)];
    [self.cachedSizeForCell addObject:[NSValue valueWithCGSize:CGSizeZero]];
}

- (void)appendContentsOf:(nonnull NSArray *)data {
    [_itemsData addObjectsFromArray:data];

    for (int index = 0; index < data.count; index++) {
        [self.cachedHeightForCell addObject:@(UITableViewAutomaticDimension)];
        [self.cachedSizeForCell addObject:[NSValue valueWithCGSize:CGSizeZero]];
    }
}

- (void)addItemsDataFromArray:(NSArray *)data {
    [self appendContentsOf:data];
}

- (void)insert:(nonnull id)data atIndex:(NSInteger)index {
    [self insertContentsOf:@[data] atIndex:index];
}

- (void)insertContentsOf:(nonnull NSArray *)data atIndex:(NSInteger)index {
    validateInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, data.count)];
    [_itemsData insertObjects:data atIndexes:indexSet];

    NSMutableArray *height = [NSMutableArray new];
    NSMutableArray *size = [NSMutableArray new];
    for (NSUInteger index = 0; index < data.count; index++) {
        [height addObject:@(UITableViewAutomaticDimension)];
        [size addObject:[NSValue valueWithCGSize:CGSizeZero]];
    }
    [self.cachedHeightForCell insertObjects:height atIndexes:indexSet];
    [self.cachedSizeForCell insertObjects:size atIndexes:indexSet];
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

    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, data.count)];
    [_itemsData replaceObjectsAtIndexes:indexSet withObjects:data];

    NSMutableArray *height = [NSMutableArray new];
    NSMutableArray *size = [NSMutableArray new];
    for (NSUInteger index = 0; index < data.count; index++) {
        [height addObject:@(UITableViewAutomaticDimension)];
        [size addObject:[NSValue valueWithCGSize:CGSizeZero]];
    }
    [self.cachedHeightForCell replaceObjectsAtIndexes:indexSet withObjects:height];
    [self.cachedSizeForCell replaceObjectsAtIndexes:indexSet withObjects:size];
}

- (void)replaceWithNewDataArray:(NSArray *)data atIndex:(NSInteger)index {
    [self replaceWithContentsOf:data atIndex:index];
}

- (nonnull id)removeFirst {
    if ([self.itemsData count] <= 0) {
        return nil;
    }

    [self.cachedHeightForCell removeObjectAtIndex:0];
    [self.cachedSizeForCell removeObjectAtIndex:0];
    
    id first = self.itemsData.firstObject;
    [_itemsData removeObjectAtIndex:0];
    return first;
}

- (nonnull id)removeLast {
    [self.cachedHeightForCell removeLastObject];
    [self.cachedSizeForCell removeLastObject];
    
    id last = self.itemsData.lastObject;
    [_itemsData removeLastObject];
    return last;
}

- (nullable id)removeAtIndex:(NSInteger)index {
    if (self.numberOfItems <= index) {
        return nil;
    }
    
    [self.cachedHeightForCell removeObjectAtIndex:index];
    [self.cachedSizeForCell removeObjectAtIndex:index];

    id removed = [self.itemsData objectAtIndex:index];
    [_itemsData removeObjectAtIndex:index];
    return removed;
}

- (nullable NSArray<id> *)removeAtIndexs:(nonnull NSArray<NSNumber *> *)indexs {
    TCArrayRemoveIndexs(self.cachedHeightForCell, indexs);
    TCArrayRemoveIndexs(self.cachedSizeForCell, indexs);
    return TCArrayRemoveIndexs(_itemsData, indexs);
}

- (nullable id)removeDataForItemAtIndex:(NSInteger)index {
    return [self removeAtIndex:index];
}

- (nullable NSArray *)removeAll {
    [self.cachedHeightForCell removeAllObjects];
    [self.cachedSizeForCell removeAllObjects];

    NSArray *removed = [[NSArray alloc] initWithArray:self.itemsData];
    [_itemsData removeAllObjects];
    
    return removed;
}

- (void)exchangeElementAtIndex:(NSInteger)index withElementAtIndex:(NSInteger)otherIndex {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    [_itemsData exchangeObjectAtIndex:index withObjectAtIndex:otherIndex];
    
    [self.cachedHeightForCell exchangeObjectAtIndex:index withObjectAtIndex:otherIndex];
    [self.cachedSizeForCell exchangeObjectAtIndex:index withObjectAtIndex:otherIndex];
}

- (void)exchangeDataAtIndex:(NSInteger)sourceIndex withDataAtIndex:(NSInteger)destinationIndex {
    [self exchangeElementAtIndex:sourceIndex withElementAtIndex:destinationIndex];
}

- (void)moveElementAtIndex:(NSInteger)index toIndex:(NSInteger)otherIndex {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    if (index == otherIndex) {
        return;
    }
    
    id moved = [self.itemsData objectAtIndex:index];
    [_itemsData removeObjectAtIndex:index];
    [_itemsData insertObject:moved atIndex:otherIndex];
    
    NSNumber *height = [self.cachedHeightForCell objectAtIndex:index];
    [self.cachedHeightForCell removeObjectAtIndex:index];
    [self.cachedHeightForCell insertObject:height atIndex:otherIndex];
    
    NSValue *size = [self.cachedSizeForCell objectAtIndex:index];
    [self.cachedSizeForCell removeObjectAtIndex:index];
    [self.cachedSizeForCell insertObject:size atIndex:otherIndex];
}

#pragma mark - Cache Height

- (void)cacheHeight:(CGFloat)height forIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    self.cachedHeightForCell[index] = @(height);
}
- (CGFloat)cachedHeightForIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
#if defined(__LP64__) && __LP64__
    return [self.cachedHeightForCell[index] doubleValue];
#else
    return [self.cachedHeightForCell[index] floatValue];
#endif
}

- (void)cacheSize:(CGSize)size forIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    self.cachedSizeForCell[index] = [NSValue valueWithCGSize:size];
}

- (CGSize)cachedSizeForIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    return [self.cachedSizeForCell[index] CGSizeValue];
}

- (void)invalidateCachedCellHeightForIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    self.cachedHeightForCell[index] = @(UITableViewAutomaticDimension);
}

- (void)invalidateCachedCellSizeForIndex:(NSInteger)index {
    validateNoneInsertElementArgumentIndex(self.itemsData, index, __FILE__, __LINE__, __FUNCTION__);
    self.cachedSizeForCell[index] = [NSValue valueWithCGSize:CGSizeZero];
}

- (void)invalidateCachedHeightForHeader {
    self.cachedHeightForHeader = 0.0f;
}

- (void)invalidateCachedHeightForFooter {
    self.cachedHeightForFooter = 0.0f;
}

- (void)invalidateCachedSizeForHeader {
    self.cachedSizeForHeader = CGSizeZero;
}

- (void)invalidateCachedSizeForFooter {
    self.cachedSizeForFooter = CGSizeZero;
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

