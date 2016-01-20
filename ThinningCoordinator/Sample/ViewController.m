//
//  ViewController.m
//  ThinningCoordinator
//
//  Created by Moch Xiao on 1/20/16.
//  Copyright © 2016 Moch. All rights reserved.
//

#import "ViewController.h"
#import "ThinningCoordinator.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    TCSectionDataMetric *section = [[TCSectionDataMetric alloc] initWithItemsData:nil];
    NSLog(@"%@", section);
}


@end
