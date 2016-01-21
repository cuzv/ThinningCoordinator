//
//  CollectionViewSampleViewController.m
//  ThinningCoordinator
//
//  Created by Moch Xiao on 1/21/16.
//  Copyright © 2016 Moch. All rights reserved.
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
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    [self.collectionView addGestureRecognizer:longPress];
 
    
    NSArray *data0 = @[@"Michael", @"Moch", @"KKKK"];
    TCSectionDataMetric *section0 = [[TCSectionDataMetric alloc] initWithItemsData:data0 dataForHeader:header dataForFooter:footer];
    
    NSArray *data1 = @[@"Kevin", @"Anna", text1,  @"Jack"];
    TCSectionDataMetric *section1 = [[TCSectionDataMetric alloc] initWithItemsData:data1];
    
    NSArray *data2 = @[text1, @"Anna", text2,  @"Jack", text3, text4];
    TCSectionDataMetric *section2 = [[TCSectionDataMetric alloc] initWithItemsData:data2];
    
    TCGlobalDataMetric *globalDataMetric = [[TCGlobalDataMetric alloc] initWithSectionDataMetrics:@[section0, section1, section2]];
    
    self.dataSource.globalDataMetric = globalDataMetric;
    [self.collectionView reloadData];
}

- (IBAction)handleMove:(UIBarButtonItem *)sender {
}


- (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    UIGestureRecognizerState state = sender.state;
    
    switch (state) {
        case UIGestureRecognizerStateBegan: {
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[sender locationInView:self.collectionView]];
            if (indexPath) {
                [self.collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
            }
        }
            break;
        case UIGestureRecognizerStateChanged:
            [self.collectionView updateInteractiveMovementTargetPosition:[sender locationInView:sender.view]];
            break;
        case UIGestureRecognizerStateEnded:
            [self.collectionView endInteractiveMovement];
           break;
        default:
            [self.collectionView cancelInteractiveMovement];
            break;
    }
}


- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:[CollectionViewFlowLayout new]];
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
