//
//  DataSourceItemReceiver.swift
//  DataSource
//
//  Created by Vadim Yelagin on 23/09/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import Foundation

/// Implement this protocol in your `UITableViewCell` or `UICollectionView` subclass
/// to make it receive corresponding items of the dataSource associated
/// with a `TableViewDataSource` or a `CollectionViewDataSource`.
/// - note: Only a class implemented in Swift can conform to this protocol.
///   For Objective-C classes see `DataSourceObjectItemReceiver`.
public protocol DataSourceItemReceiver {

	func ds_setItem(_ item: Any)

}

/// Implement this protocol in your `UITableViewCell` or `UICollectionView` subclass
/// to make it receive corresponding items of the dataSource associated
/// with a `TableViewDataSource` or a `CollectionViewDataSource`.
/// - note: This protocol allows only settings of items of object type.
///   Use `DataSourceItemReceiver` protocol instead if you don't need to implement
///   your class in Objective-C.
@objc public protocol DataSourceObjectItemReceiver {

	@objc func ds_setItem(_ item: AnyObject)

}

func configureReceiver(_ receiver: AnyObject, withItem item: Any) {
	if let receiver = receiver as? DataSourceItemReceiver {
		receiver.ds_setItem(item)
	} else if let receiver = receiver as? DataSourceObjectItemReceiver {
		receiver.ds_setItem(item as AnyObject)
	}
}
