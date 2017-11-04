//
//  CollectionViewHeaderFooterView.m
//  ThinningCoordinator
//
//  Created by Roy Shaw on 1/21/16.
//  Copyright © 2016 Red Rain. All rights reserved.
//

#import "CollectionViewHeaderFooterView.h"
#import <Masonry/Masonry.h>

@interface CollectionViewHeaderFooterView ()
@property (nonatomic, strong) UILabel *nameLabel;
@end

@implementation CollectionViewHeaderFooterView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self setupUserInterface];
    [self setupReactiveCocoa];
    
    return self;
}

- (void)layoutSubviews {
    self.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.nameLabel.bounds) - 16;
    [super layoutSubviews];
}

- (void)setupUserInterface {
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self).insets(UIEdgeInsetsMake(8, 8, 8, 8));
    }];
}

- (void)setupReactiveCocoa {
    
}

#pragma mark -  Configure data

- (void)setupData:(id)data {
    self.nameLabel.text = data;
}

#pragma mark -  Accessor


- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel new];
        _nameLabel.numberOfLines = 0;
        _nameLabel.backgroundColor = [UIColor yellowColor];
    }
    return _nameLabel;
}




@end
