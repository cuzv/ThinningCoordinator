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
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [self.globalDataMetric titleForHeaderInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    return [self.globalDataMetric titleForFooterInSection:section];
}

#pragma mark - UICollectionViewDataSource

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [self init];

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
