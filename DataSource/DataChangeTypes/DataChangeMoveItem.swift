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

	public init(from fromIndexPath: IndexPath, to toIndexPath: IndexPath) {
		self.fromIndexPath = fromIndexPath
		self.toIndexPath = toIndexPath
	}

	public func apply(to target: DataChangeTarget) {
		target.ds_moveItem(at: fromIndexPath, to: toIndexPath)
	}

	public func mapSections(_ transform: (Int) -> Int) -> DataChangeMoveItem {
		return DataChangeMoveItem(from: fromIndexPath.ds_mapSection(transform), to: toIndexPath.ds_mapSection(transform))
	}

}
