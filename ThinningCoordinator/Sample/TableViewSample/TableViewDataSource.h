//
//  TableViewDataSource.h
//  ThinningCoordinator
//
//  Created by Roy Shaw on 1/21/16.
//  Copyright © 2016 Red Rain. All rights reserved.
//

#import "TCDataSource.h"

@interface TableViewDataSource : TCDataSource <
    TCDataSourceable,
    TCTableViewHeaderFooterViewibility,
    TCTableViewEditable,
    TCTableViewCollectionViewMovable
>

@end
