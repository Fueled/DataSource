//
//  DataChangeBatch.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeBatch: DataChange {

	public let changes: [DataChange]

	public init(_ changes: [DataChange]) {
		self.changes = changes
	}

	public func apply(target: DataChangeTarget) {
		target.ds_performBatchChanges {
			for change in self.changes {
				change.apply(target)
			}
		}
	}

	public func mapSections(map: Int -> Int) -> DataChangeBatch {
		let mapped = self.changes.map { $0.mapSections(map) }
		return DataChangeBatch(mapped)
	}

}
