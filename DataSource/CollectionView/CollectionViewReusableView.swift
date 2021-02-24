//
//  CollectionViewReusableView.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Combine
import UIKit

/// `UICollectionReusableView` subclass that implements `DataSourceItemReceiver` protocol
/// by putting received dataSource items into a `MutableProperty` called `viewModel`.
/// - note:
///   You are not required to subclass `CollectionViewReusableView` class in order
///   to use your cell subclass with `CollectionViewDataSource`.
///   Instead you can implement `DataSourceItemReceiver`
///   protocol directly in any `UICollectionReusableView` subclass.
open class CollectionViewReusableView: UICollectionReusableView, DataSourceItemReceiver {
	@Published public final var viewModel: Any?

	open func ds_setItem(_ item: Any) {
		self.viewModel = item
	}
}
