//
//  TCHelper.m
//  Haioo
//
//  Created by Moch Xiao on 8/25/15.
//  Copyright (c) 2015 Haioo. All rights reserved.
//

#import "TCHelper.h"

@implementation TCHelper

static inline BOOL _supportsConstraintsProperly() {
    static BOOL constraintsSupported;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *versionString = [[UIDevice currentDevice] systemVersion];
        constraintsSupported = ([versionString integerValue] > 7);
    });
    
    return constraintsSupported;
}


BOOL TCCollectionViewSupportsConstraintsProperly() {
    return _supportsConstraintsProperly();
}

BOOL TCTableViewSupportsConstraintsProperly() {
    return _supportsConstraintsProperly();
}

@end
