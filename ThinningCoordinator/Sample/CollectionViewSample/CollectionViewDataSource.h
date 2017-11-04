//
//  CollectionViewDataSource.h
//  ThinningCoordinator
//
//  Created by Roy Shaw on 1/21/16.
//  Copyright © 2016 Red Rain. All rights reserved.
//

#import "TCDataSource.h"

@interface CollectionViewDataSource : TCDataSource<
    TCDataSourceable,
    TCCollectionSupplementaryViewibility,
    TCTableViewCollectionViewMovable
>

@end
