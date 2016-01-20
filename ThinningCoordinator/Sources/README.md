# ThinningCoordinator

The UITableView/UICollectionView dataSource/delegate thinning coordinator, help thinning your UIViewController!

This practice is based on [Objc.io post](https://www.objc.io/issues/1-view-controllers/lighter-view-controllers/)



## Usage

- bind your tableView/collectionView `datasource ` to `TCDataSource` subclass instance
  
  ``` objective-c
  self.dataSource = `TCDataSource subclass instance`
  self.tableView.dataSource = self.dataSource
  ```
  
- Make you subclass conform `TCDataSourceProtocol` methods
  
  ``` objective-c
  - (void)registerReusableCell {
      [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCellIdentifier];
  }
  
  - (NSString *)reusableCellIdentifierForIndexPath:(NSIndexPath *)indexPath {
      return UITableViewCellIdentifier;
  }
  
  - (void)loadData:(id)data forReusableCell:(UITableViewCell *)cell {
      [cell configureData:data];
  }
  ```
  
- When you received data, build as a `TCGlobalDataMetric`  instance assign to dataSource
  
  ``` objective-c
  self.dataSource.globalDataMetric = globalDataMetric;
  ```

Valar! you have split your dataSource code from ViewController. The delegate implement is similar as the dataSource.

This helper has already implement all dataSource/delegate methods for you. you just need provide little necessary data to complete the whole logical.  For more information checkout the source code.

## License

This repo is available under the MIT license. See the LICENSE file for more info.

## Contact

Follow me on Twitter ([@mochxiao](https://twitter.com/mochxiao))