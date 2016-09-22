//
//  DataChangeReloadItems.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeReloadItems: DataChange {

	public let indexPaths: [IndexPath]

	public init(_ indexPaths: [IndexPath]) {
		self.indexPaths = indexPaths
	}

	public init (_ indexPath: IndexPath) {
		self.init([indexPath])
	}

	public func apply(to target: DataChangeTarget) {
		target.ds_reloadItems(at: indexPaths)
	}

	public func mapSections(_ transform: (Int) -> Int) -> DataChangeReloadItems {
		return DataChangeReloadItems(indexPaths.map { $0.ds_mapSection(transform) })
	}

}
