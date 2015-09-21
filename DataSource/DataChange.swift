//
//  DataChange.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import UIKit

public protocol DataChange {

	func apply(target: DataChangeTarget)

	func mapSections(map: Int -> Int) -> Self

}
