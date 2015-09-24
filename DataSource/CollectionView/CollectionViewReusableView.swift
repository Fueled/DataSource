//
//  CollectionViewReusableView.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import UIKit
import ReactiveCocoa

public class CollectionViewReusableView: UICollectionReusableView, DataSourceItemReceiver {

	public final let item = MutableProperty<Any?>(nil)

	public func ds_setItem(item: Any) {
		self.item.value = item
	}

}
