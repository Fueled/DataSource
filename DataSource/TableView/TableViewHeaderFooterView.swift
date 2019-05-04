//
//  TableViewHeaderFooterView.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import ReactiveSwift
import UIKit

/// `UITableViewHeaderFooterView` subclass that implements `DataSourceItemReceiver` protocol
/// by putting received dataSource items into a `MutableProperty` called `viewModel`.
/// - note:
///   You are not required to subclass `TableViewHeaderFooterView` class in order
///   to use your cell subclass with `TableViewDataSourceWithHeaderFooterViews`.
///   Instead you can implement `DataSourceItemReceiver`
///   protocol directly in any `UITableViewHeaderFooterView` subclass.
open class TableViewHeaderFooterView: UITableViewHeaderFooterView, DataSourceItemReceiver {

	public final let viewModel = MutableProperty<Any?>(nil)

	open func ds_setItem(_ item: Any) {
		self.viewModel.value = item
	}

}
