//
//  TableViewHeaderView.m
//  ThinningCoordinator
//
//  Created by Roy Shaw on 1/21/16.
//  Copyright © 2016 Red Rain. All rights reserved.
//

#import "TableViewHeaderFooterView.h"
#import <Masonry/Masonry.h>


@interface TableViewHeaderFooterView ()
@property (nonatomic, strong) UILabel *nameLabel;
@end


@implementation TableViewHeaderFooterView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    [self setupUserInterface];
    [self setupReactiveCocoa];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.contentView setNeedsLayout];
    [self.contentView layoutIfNeeded];
    self.nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.nameLabel.bounds) - 16;
}

- (void)setupUserInterface {
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(8, 8, 8, 8));
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
