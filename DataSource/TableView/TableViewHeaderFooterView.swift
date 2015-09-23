//
//  TableViewHeaderFooterView.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import UIKit
import ReactiveCocoa

public class TableViewHeaderFooterView: UITableViewHeaderFooterView, DataSourceItemReceiver {

	public final let item = MutableProperty<Any?>(nil)

	public func setItem(item: Any) {
		self.item.value = item
	}

}
