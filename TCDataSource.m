//
//  TCDataSource.m
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
#import "TCGlobalDataMetric.h"
#import "TCDataSourceProtocol.h"
#import "TCSectionDataMetric.h"

@interface TCDataSource ()
@property (nonatomic, weak, readwrite) UITableView *tableView;
@property (nonatomic, weak, readwrite) UICollectionView *collectionView;
@property (nonatomic, weak) id <TCDataSourceProtocol> subclass;
@end

@implementation TCDataSource

- (instancetype)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ([self conformsToProtocol:@protocol(TCDataSourceProtocol)]) {
        self.subclass = (id <TCDataSourceProtocol>) self;
    } else {
        NSAssert(NO, @"subclass must conforms TCDataSourceProtocol!");
    }
    
    return self;
}

#pragma mark - UITableViewDataSource

- (instancetype)initWithTableView:(UITableView *)tableView {
    self = [self init];

    NSAssert(tableView, NSLocalizedString(@"Tableview can not be nil", nil));
    _tableView = tableView;

    return self;
}

#pragma mark -

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.globalDataMetric numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.globalDataMetric numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.subclass reusableCellIdentifierForIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    [self.subclass loadData:data forReusableCell:cell];

    [cell setNeedsUpdateConstraints];
    [cell updateConstraintsIfNeeded];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.globalDataMetric titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.globalDataMetric titleForFooterInSection:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    NSMutableArray *indexTitles = [NSMutableArray new];
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(indexTitleForSectionDataMetric:)];
    if (!respondsToSelector) {
        return nil;
    }

    // If titles contains nil will crash
    __block BOOL valid = YES;
    [[self.globalDataMetric allSectionDataMetrics] enumerateObjectsUsingBlock:^(TCSectionDataMetric *obj, NSUInteger idx, BOOL *stop) {
        NSString *title = [self.subclass indexTitleForSectionDataMetric:obj];
        if (!title) {
            valid = NO;
            *stop = YES;
        }
        [indexTitles addObject:title];
    }];

    if (!valid) {
        return nil;
    }
    
    return indexTitles;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    NSArray *sectionIndexTitles = [self sectionIndexTitlesForTableView:self.tableView];
    return [sectionIndexTitles indexOfObjectIdenticalTo:title];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(canEditItemAtIndexPath:)];
    if (!respondsToSelector) {
        return respondsToSelector;
    }
    
    return [self.subclass canEditItemAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(commitEditingData:atIndexPath:)];
    if (!respondsToSelector) {
        return;
    }
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    if (UITableViewCellEditingStyleDelete == editingStyle) {
        [self.globalDataMetric removeDataAtIndexPath:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    } else if (UITableViewCellEditingStyleInsert == editingStyle) {
        // Duplicate last content item, in case reload data error, should not use it.
        if (!data) {
            NSLog(NSLocalizedString(@"Array index cross the bounds", nil));
            return;
        }
        
        NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
        [self.globalDataMetric insertData:@[data] atIndexPath:newIndexPath];
        [tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }

    [self.subclass commitEditingData:data atIndexPath:indexPath];
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(canMoveItemAtIndexPath:)];
    if (!respondsToSelector) {
        return respondsToSelector;
    }
    
    return [self.subclass canMoveItemAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    TCSectionDataMetric *sourceSectionDataMetric = [self.globalDataMetric dataInSection:sourceIndexPath.section];
    NSMutableArray *sourceContent = [[sourceSectionDataMetric allItems] mutableCopy];
    
    if (sourceIndexPath.section == destinationIndexPath.section) {
        [sourceContent exchangeObjectAtIndex:sourceIndexPath.item withObjectAtIndex:destinationIndexPath.item];
    } else {
        id temp = [sourceContent objectAtIndex:sourceIndexPath.item];
        [sourceContent removeObject:temp];
        
        TCSectionDataMetric *destinationSectionDataMetric = [self.globalDataMetric dataInSection:destinationIndexPath.section];
        NSMutableArray *destinationContent = [[destinationSectionDataMetric allItems] mutableCopy];
        [destinationContent insertObject:temp atIndex:destinationIndexPath.item];
        [destinationSectionDataMetric setValue:destinationContent forKey:@"items"];
    }
    
    [sourceSectionDataMetric setValue:sourceContent forKey:@"items"];
}


#pragma mark - UICollectionViewDataSource

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [self init];

    NSAssert(collectionView, NSLocalizedString(@"CollectionView can not be nil", nil));
    _collectionView = collectionView;
    
    return self;
}

#pragma mark -

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.globalDataMetric numberOfSections];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.globalDataMetric numberOfItemsInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.subclass reusableCellIdentifierForIndexPath:indexPath];
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
    id data = [self.globalDataMetric dataForItemAtIndexPath:indexPath];
    [self.subclass loadData:data forReusableCell:cell];

    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [self.subclass respondsToSelector:@selector(reusableSupplementaryViewIdentifierForIndexPath:ofKind:)]
                                            ? [self.subclass reusableSupplementaryViewIdentifierForIndexPath:indexPath ofKind:kind]
                                            : nil;
    NSAssert(identifier, NSLocalizedString(@"Supplementary view reuse identifier can not be nil", nil));
    UICollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:identifier forIndexPath:indexPath];
    
    id data = [self.globalDataMetric dataForSupplementaryElementOfKind:kind atIndexPath:indexPath];
    BOOL respondsToSelector = [self.subclass respondsToSelector:@selector(loadData:forReusableSupplementaryView:)];
    NSAssert(respondsToSelector, NSLocalizedString(@"sub class must responds to selector `loadData:forReusableSupplementaryView:`", nil));
    [self.subclass loadData:data forReusableSupplementaryView:reusableView];
    
    return reusableView;
}


@end
