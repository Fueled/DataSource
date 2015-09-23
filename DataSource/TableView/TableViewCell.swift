//
//  TableViewCell.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import UIKit
import ReactiveCocoa

public class TableViewCell: UITableViewCell, DataSourceItemReceiver {

	public final let item = MutableProperty<Any?>(nil)

	public func setItem(item: Any) {
		self.item.value = item
	}

}
