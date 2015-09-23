//
//  DataSourceItemReceiver.swift
//  DataSource
//
//  Created by Vadim Yelagin on 23/09/15.
//  Copyright © 2015 Fueled. All rights reserved.
//

import UIKit
import ReactiveCocoa

public protocol DataSourceItemReceiver {

	func setItem(item: Any)

}

@objc public protocol DataSourceObjectItemReceiver {

	@objc func setItem(item: AnyObject)

}

func configureReceiver(receiver: AnyObject, withItem item: Any) {
	if let receiver = receiver as? DataSourceItemReceiver {
		receiver.setItem(item)
	} else if let receiver = receiver as? DataSourceObjectItemReceiver,
		item = item as? AnyObject
	{
		receiver.setItem(item)
	}
}
