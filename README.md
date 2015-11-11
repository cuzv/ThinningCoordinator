# ThinningCoordinator

The UITableView/UICollectionView dataSource/delegate thinning coordinator, help thinning your UIViewController!

This practice is based on [Objc.io post](https://www.objc.io/issues/1-view-controllers/lighter-view-controllers/)



## Usage

- bind your tableView/collectionView `datasource ` to `TCDataSource` subclass
  
  ``` objective-c
  self.dataSource = `TCDataSource subclass instance`
  self.tableView.dataSource = self.dataSource
  ```
  
- implement the dataSource method in your `TCDataSource` subclass
  
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
  
  ​
  
  Valar! you have split your dataSource code from ViewController. The delegate implement is similar as the dataSource.
  
- For more information checkout the source code.
  
  ​