//
//  CollectionViewSampleViewController.m
//  ThinningCoordinator
//
//  Created by Roy Shaw on 1/21/16.
//  Copyright © 2016 Red Rain. All rights reserved.
//

#import "CollectionViewSampleViewController.h"
#import "CollectionViewDataSource.h"
#import "CollectionViewDelegate.h"
#import <Masonry/Masonry.h>
#import "ThinningCoordinator.h"
#import "Text.h"
#import "CollectionViewFlowLayout.h"

@interface CollectionViewSampleViewController ()
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) CollectionViewDataSource *dataSource;
@property (nonatomic, strong) CollectionViewDelegate *delegate;
@end

@implementation CollectionViewSampleViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    NSArray *data0 = @[@"Michael", @"Moch", @"KKKK"];
    
    TCSectionDataMetric *section0 = [[TCSectionDataMetric alloc] initWithItemsData:data0 dataForSupplementaryHeader:@[header] dataForSupplementaryFooter:@[footer]];
    
    NSArray *data1 = @[@"Kevin", @"Anna", text1,  @"Jack"];
    TCSectionDataMetric *section1 = [[TCSectionDataMetric alloc] initWithItemsData:data1];
    
    NSArray *data2 = @[text1, @"Anna", text2,  @"Jack", text3, text4];
    TCSectionDataMetric *section2 = [[TCSectionDataMetric alloc] initWithItemsData:data2];
    
    TCGlobalDataMetric *globalDataMetric = [[TCGlobalDataMetric alloc] initWithSectionDataMetrics:@[section0, section1, section2]];
    
    self.dataSource.globalDataMetric = globalDataMetric;
    [self.collectionView reloadData];
    
    // 如果你需要使用重新排序功能，由于 UICollectionView iOS 9 才提供了官方的 API, 其他支持请查看三方实现。比如
    // https://github.com/LiorNn/DragDropCollectionView
    // https://github.com/ra1028/RAReorderableLayout
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[UICollectionViewFlowLayout new]];
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.delegate = self.delegate;
        _collectionView.dataSource = self.dataSource;
    }
    
    return _collectionView;
}


- (CollectionViewDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [[CollectionViewDataSource alloc] initWithCollectionView:self.collectionView];
    }
    return _dataSource;
}


- (CollectionViewDelegate *)delegate {
    if (!_delegate) {
        _delegate = [[CollectionViewDelegate alloc] initWithCollectionView:self.collectionView];
    }
    return _delegate;
}
@end
