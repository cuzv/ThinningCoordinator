//
//  TCHelper.h
//  Haioo
//
//  Created by Moch Xiao on 8/25/15.
//  Copyright (c) 2015 Haioo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TCHelper : NSObject

BOOL TCCollectionViewSupportsConstraintsProperty();
BOOL TCCollectionViewSupportsConstraintsProperty();
void validateInsertElementArgumentIndex(NSArray *arr, const NSInteger index, const void *file, const int line, const void *method);
void validateNoneInsertElementArgumentIndex(NSArray *arr, const NSInteger index, const void *file, const int line, const void *method);
@end
