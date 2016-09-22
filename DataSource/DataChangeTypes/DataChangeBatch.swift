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

	public func apply(to target: DataChangeTarget) {
		target.ds_performBatchChanges {
			for change in self.changes {
				change.apply(to: target)
			}
		}
	}

	public func mapSections(_ transform: (Int) -> Int) -> DataChangeBatch {
		let mapped = self.changes.map { $0.mapSections(transform) }
		return DataChangeBatch(mapped)
	}

}
