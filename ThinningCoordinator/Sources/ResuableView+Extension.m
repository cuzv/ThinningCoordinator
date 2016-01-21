//
//  ResuableView+Extension.m
//  ThinningCoordinator
//
//  Created by Moch Xiao on 1/21/16.
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

#import "ResuableView+Extension.h"
#import "TCHelper.h"
#import <objc/runtime.h>

BOOL TCTableViewSupportsConstraintsProperty();
BOOL TCCollectionViewSupportsConstraintsProperty();

#pragma mark - UICollectionReusableView

@implementation UICollectionReusableView (TCLayoutSizeFittingSize)

// This is kind of a hack because cells don't have an intrinsic content size or any other way to constrain them to a size. As a result, labels that _should_ wrap at the bounds of a cell, don't. So by adding width and height constraints to the cell temporarily, we can make the labels wrap and the layout compute correctly.
- (CGSize)tc_preferredLayoutSizeFittingSize:(CGSize)fittingSize {
    CGRect frame = self.frame;
    frame.size = fittingSize;
    self.frame = frame;
    
    CGSize size;
    if (TCCollectionViewSupportsConstraintsProperty()) {
        // Apple's implement like folow, somehow, it doesn't work.
        // size = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        size = [self systemLayoutSizeFittingSize:CGSizeMake(fittingSize.width, UILayoutFittingCompressedSize.height)];
    } else {
        NSArray *constraints = @[
                                 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fittingSize.width],
                                 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:UILayoutFittingExpandedSize.height]];
        
        [self addConstraints:constraints];
        [self updateConstraints];
        size = [self systemLayoutSizeFittingSize:fittingSize];
        [self removeConstraints:constraints];
    }
    
    frame.size = size;
    self.frame = frame;
    
    return size;
}

@end

#pragma mark - UICollectionViewCell

@implementation UICollectionViewCell (TCLayoutSizeFittingSize)

- (CGSize)tc_preferredLayoutSizeFittingSize:(CGSize)fittingSize {
    CGRect frame = self.frame;
    frame.size = fittingSize;
    self.frame = frame;
    
    CGSize size;
    if (TCCollectionViewSupportsConstraintsProperty()) {
        [self layoutSubviews];
        // Apple's implement like folow, somehow, it doesn't work.
        // size = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        size = [self.contentView systemLayoutSizeFittingSize:CGSizeMake(fittingSize.width, UILayoutFittingCompressedSize.height)];
    } else {
        NSArray *constraints = @[
                                 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fittingSize.width],
                                 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:UILayoutFittingExpandedSize.height]];
        
        [self addConstraints:constraints];
        [self updateConstraints];
        size = [self systemLayoutSizeFittingSize:fittingSize];
        [self removeConstraints:constraints];
    }
    
    // Only consider the height for cells, because the contentView isn't anchored correctly sometimes.
    fittingSize.height = size.height;
    frame.size = fittingSize;
    self.frame = frame;
    
    return fittingSize;
}

@end


#pragma mark - UITableViewCell

@implementation UITableViewCell (TCLayoutSizeFittingSize)

/// **Note**: You should indicate the `preferredMaxLayoutWidth` by this way:
/// **Note**: You should indicate the `preferredMaxLayoutWidth` by this way:
/// ```Swift
/// override func layoutSubviews() {
///    super.layoutSubviews()
///    contentView.setNeedsLayout()
///    contentView.layoutIfNeeded()
///    nameLabel.preferredMaxLayoutWidth = CGRectGetWidth(nameLabel.bounds)
/// }
/// ```
- (CGSize)tc_preferredLayoutSizeFittingSize:(CGSize)fittingSize {
    CGRect frame = self.frame;
    frame.size = fittingSize;
    self.frame = frame;
    
    CGSize size;
    if (TCCollectionViewSupportsConstraintsProperty()) {
        [self layoutSubviews];
        // Apple's implement like folow, somehow, it doesn't work.
        // size = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    } else {
        NSArray *constraints = @[
                                 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fittingSize.width],
                                 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:UILayoutFittingExpandedSize.height]];
        
        [self addConstraints:constraints];
        [self updateConstraints];
        size = [self systemLayoutSizeFittingSize:fittingSize];
        [self removeConstraints:constraints];
    }
    
    // Only consider the height for cells, because the contentView isn't anchored correctly sometimes.
    fittingSize.height = size.height;
    frame.size = fittingSize;
    self.frame = frame;
    
    return fittingSize;
}

@end

#pragma mark - UITableViewHeaderFooterView

@implementation UITableViewHeaderFooterView (TCLayoutSizeFittingSize)

- (CGSize)tc_preferredLayoutSizeFittingSize:(CGSize)fittingSize {
    CGRect frame = self.frame;
    frame.size = fittingSize;
    self.frame = frame;
    
    CGSize size;
    if (TCCollectionViewSupportsConstraintsProperty()) {
        [self layoutSubviews];
        // Apple's implement like folow, somehow, it doesn't work.
        // size = systemLayoutSizeFittingSize(UILayoutFittingCompressedSize)
        size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    } else {
        NSArray *constraints = @[
                                 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:fittingSize.width],
                                 [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationLessThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:UILayoutFittingExpandedSize.height]];
        
        [self addConstraints:constraints];
        [self updateConstraints];
        size = [self systemLayoutSizeFittingSize:fittingSize];
        [self removeConstraints:constraints];
    }
    
    // Only consider the height for cells, because the contentView isn't anchored correctly sometimes.
    fittingSize.height = size.height;
    frame.size = fittingSize;
    self.frame = frame;
    
    return fittingSize;
}

@end

#pragma mark - Helpers

static inline BOOL _supportsConstraintsProperty() {
    static BOOL constraintsSupported;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *versionString = [[UIDevice currentDevice] systemVersion];
        constraintsSupported = ([versionString integerValue] > 7);
    });
    
    return constraintsSupported;
}

BOOL TCTableViewSupportsConstraintsProperty() {
    return _supportsConstraintsProperty();
}


BOOL TCCollectionViewSupportsConstraintsProperty() {
    return _supportsConstraintsProperty();
}


#pragma mark - UITableView TCComputeLayoutSize

@implementation UITableView (TCComputeLayoutSize)

- (CGFloat)tc_heightForReusableCellByIdentifier:(nonnull NSString *)identifier dataConfigurationHandler:(nonnull void (^)(UITableViewCell * _Nonnull cell))dataConfigurationHandler {
    UITableViewCell *reusableCell = [self dequeueReusableCellWithIdentifier:identifier];
    if (!reusableCell) {
        [NSException raise:@"FatalError" format:@"Cell must be registered to tableView for identifier: %@", identifier];
    }
    
    [reusableCell prepareForReuse];
    dataConfigurationHandler(reusableCell);
    
    CGSize fittingSize = CGSizeMake(CGRectGetWidth(self.bounds), UILayoutFittingExpandedSize.height);
    return [reusableCell tc_preferredLayoutSizeFittingSize:fittingSize].height + 1.0f / [UIScreen mainScreen].scale;
}

- (CGFloat)tc_heightForReusableHeaderFooterViewByIdentifier:(nonnull NSString *)identifier dataConfigurationHandler:(nonnull void (^)(UITableViewHeaderFooterView * _Nonnull reusableHeaderFooterView))dataConfigurationHandler {
    UITableViewHeaderFooterView *reusableHeaderFooterView = [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
    if (!reusableHeaderFooterView) {
        [NSException raise:@"FatalError" format:@"HeaderFooterView must be registered to tableView for identifier: %@", identifier];
    }
    
    [reusableHeaderFooterView prepareForReuse];
    dataConfigurationHandler(reusableHeaderFooterView);
    
    CGSize fittingSize = CGSizeMake(CGRectGetWidth(self.bounds), UILayoutFittingExpandedSize.height);
    return [reusableHeaderFooterView tc_preferredLayoutSizeFittingSize:fittingSize].height + 1.0f / [UIScreen mainScreen].scale;
}

@end


#pragma mark - 

@implementation UICollectionView (TCComputeLayoutSize)

- (CGSize)tc_sizeForReusableViewByClass:(nonnull Class)cls preferredLayoutSizeFittingSize:(CGSize)fittingSize dataConfigurationHandler:(nonnull void (^)(UICollectionReusableView * _Nonnull reusableView))dataConfigurationHandler {
    NSDictionary<NSString *, UICollectionReusableView *> *reusableViews = self.tc_reusableViews;
    if (!reusableViews) {
        reusableViews = @{};
    }
    
    NSString *key = NSStringFromClass(cls);
    UICollectionReusableView *reusableView = [reusableViews objectForKey:key];
    if (!reusableView) {
        reusableView = [[cls alloc] initWithFrame:CGRectZero];
        [reusableViews setValue:reusableView forKey:key];
        [self tc_setReusableViews:reusableViews];
    }
  
    [reusableView prepareForReuse];
    dataConfigurationHandler(reusableView);
    
    return [reusableView tc_preferredLayoutSizeFittingSize:fittingSize];
}

static const void *ReusableViewsAccocaitionKey = @"reusableViews";
- (NSDictionary<NSString *, UICollectionReusableView *> *)tc_reusableViews {
    return objc_getAssociatedObject(self, &ReusableViewsAccocaitionKey);
}

- (void)tc_setReusableViews:(NSDictionary<NSString *, UICollectionReusableView *> *)reusableViews {
    objc_setAssociatedObject(self, &ReusableViewsAccocaitionKey, reusableViews, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end