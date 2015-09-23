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
