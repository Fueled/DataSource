//
//  CollectionViewCell.swift
//  DataSource
//
//  Created by Vadim Yelagin on 10/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import ReactiveSwift
import UIKit

/// `UICollectionViewCell` subclass that implements `DataSourceItemReceiver` protocol
/// by putting received dataSource items into a `MutableProperty` called `cellModel`.
/// - note:
///   You are not required to subclass `CollectionViewCell` class in order
///   to use your cell subclass with `CollectionViewDataSource`.
///   Instead you can implement `DataSourceItemReceiver`
///   protocol directly in any `UICollectionViewCell` subclass.
open class CollectionViewCell: UICollectionViewCell, DataSourceItemReceiver {

	public final let cellModel = MutableProperty<Any?>(nil)

	open func ds_setItem(_ item: Any) {
		self.cellModel.value = item
	}

}
