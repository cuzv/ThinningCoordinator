//
//  TCHelper.m
//  Haioo
//
//  Created by Roy Shaw on 8/25/15.
//  Copyright (c) 2015 Red Rain (https://github.com/cuzv).
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

#import "TCHelper.h"

@implementation TCHelper

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

NSArray *TCArrayRemoveIndexs(NSMutableArray *arr, NSArray<NSNumber *> *indexs) {
    NSInteger maxIndex = 0;
    for (NSNumber *element in indexs) {
        if (element.integerValue > maxIndex) {
            maxIndex = element.integerValue;
        }
    }
    
    if (arr.count <= maxIndex) {
        return nil;
    }
    
    NSMutableArray *removed = [NSMutableArray new];
    for (NSNumber *element in indexs) {
        [removed addObject:[arr objectAtIndex:element.integerValue]];
    }
    for (id data in removed) {
        [arr removeObject:data];
    }
    return removed;
}

@end
