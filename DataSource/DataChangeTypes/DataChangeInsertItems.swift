//
//  DataChangeInsertItems.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeInsertItems: DataChange {

	public let indexPaths: [NSIndexPath]

	public init(_ indexPaths: [NSIndexPath]) {
		self.indexPaths = indexPaths
	}

	public init (_ indexPath: NSIndexPath) {
		self.init([indexPath])
	}

	public func apply(target: DataChangeTarget) {
		target.ds_insertItemsAtIndexPaths(indexPaths)
	}

	public func mapSections(map: Int -> Int) -> DataChangeInsertItems {
		return DataChangeInsertItems(indexPaths.map(mapSection(map)))
	}

}
