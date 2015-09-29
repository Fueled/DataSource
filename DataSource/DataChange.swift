//
//  DataChange.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import UIKit

/// A value representing a modification of a dataSource contents.
/// - seealso: DataSource
public protocol DataChange {

	/// Applies the dataChange to a given target.
	func apply(target: DataChangeTarget)

	/// Returns a new dataChange of same type with its section indicies transformed
	/// by the given function.
	func mapSections(map: Int -> Int) -> Self

}
