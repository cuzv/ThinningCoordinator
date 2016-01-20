//
//  TCHelper.m
//  Haioo
//
//  Created by Moch Xiao on 8/25/15.
//  Copyright (c) 2015 Haioo. All rights reserved.
//

#import "TCHelper.h"

@implementation TCHelper

static inline BOOL _supportsConstraintsProperty() {
    static BOOL constraintsSupported;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *versionString = [[UIDevice currentDevice] systemVersion];
        constraintsSupported = ([versionString integerValue] > 7);
    });
    
    return constraintsSupported;
}


BOOL TCCollectionViewSupportsConstraintsProperty() {
    return _supportsConstraintsProperty();
}

BOOL TCTableViewSupportsConstraintsProperty() {
    return _supportsConstraintsProperty();
}


void validateInsertElementArgumentIndex(NSArray *arr, const NSInteger index, const void *file, const int line, const void *method) {
    if (arr.count <= index) {
        NSString *message = [NSString stringWithFormat:@"index %@ extends beyond bounds: %s:%@:%s",
                             @(index), file, @(line), method];
        NSLog(@"%@", message);
        [[NSException exceptionWithName:@"Index beyond boundary." reason:message userInfo:nil] raise];
    }
}

void validateNoneInsertElementArgumentIndex(NSArray *arr, const NSInteger index, const void *file, const int line, const void *method) {
    if (arr.count < index) {
        NSString *message = [NSString stringWithFormat:@"index %@ extends beyond bounds: %s:%@:%s",
                             @(index), file, @(line), method];
        NSLog(@"%@", message);
        [[NSException exceptionWithName:@"Index beyond boundary." reason:message userInfo:nil] raise];
    }
}

@end
