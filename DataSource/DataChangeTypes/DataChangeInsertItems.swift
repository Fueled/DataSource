//
//  DataChangeInsertItems.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeInsertItems: DataChange {

	public let indexPaths: [IndexPath]

	public init(_ indexPaths: [IndexPath]) {
		self.indexPaths = indexPaths
	}

	public init (_ indexPath: IndexPath) {
		self.init([indexPath])
	}

	public func apply(_ target: DataChangeTarget) {
		target.ds_insertItemsAtIndexPaths(indexPaths)
	}

	public func mapSections(_ transform: @escaping (Int) -> Int) -> DataChangeInsertItems {
		return DataChangeInsertItems(indexPaths.map(mapSection(transform)))
	}

}
