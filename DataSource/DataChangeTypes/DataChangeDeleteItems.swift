//
//  DataChangeDeleteItems.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeDeleteItems: DataChange {

	public let indexPaths: [IndexPath]

	public init(_ indexPaths: [IndexPath]) {
		self.indexPaths = indexPaths
	}

	public init (_ indexPath: IndexPath) {
		self.init([indexPath])
	}

	public func apply(to target: DataChangeTarget) {
		target.ds_deleteItems(at: indexPaths)
	}

	public func mapSections(_ transform: (Int) -> Int) -> DataChangeDeleteItems {
		return DataChangeDeleteItems(indexPaths.map { $0.ds_mapSection(transform) })
	}

}
