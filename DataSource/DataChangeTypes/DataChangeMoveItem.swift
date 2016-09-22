//
//  DataChangeMoveItem.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeMoveItem: DataChange {

	public let fromIndexPath: IndexPath
	public let toIndexPath: IndexPath

	public init(from: IndexPath, to: IndexPath) {
		self.fromIndexPath = from
		self.toIndexPath = to
	}

	public func apply(_ target: DataChangeTarget) {
		target.ds_moveItemAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
	}

	public func mapSections(_ transform: @escaping (Int) -> Int) -> DataChangeMoveItem {
		let f = mapSection(transform)
		return DataChangeMoveItem(from: f(fromIndexPath), to: f(toIndexPath))
	}

}
