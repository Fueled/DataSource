//
//  TableViewHeaderFooterView.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import UIKit
import ReactiveCocoa

/// `UITableViewHeaderFooterView` subclass that implements `DataSourceItemReceiver` protocol
/// by putting received dataSource items into a `MutableProperty` called `item`.
/// - note:
///   You are not required to subclass `TableViewHeaderFooterView` class in order
///   to use your cell subclass with `TableViewDataSourceWithHeaderFooterViews`.
///   Instead you can implement `DataSourceItemReceiver`
///   protocol directly in any `UITableViewHeaderFooterView` subclass.
public class TableViewHeaderFooterView: UITableViewHeaderFooterView, DataSourceItemReceiver, Disposing {

	public final let item = MutableProperty<Any?>(nil)

	public final let disposable = CompositeDisposable()

	deinit {
		disposable.dispose()
	}

	public func ds_setItem(item: Any) {
		self.item.value = item
	}

}
