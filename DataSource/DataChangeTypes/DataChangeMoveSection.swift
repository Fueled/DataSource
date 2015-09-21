//
//  DataChangeMoveSection.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeMoveSection: DataChange {

	public let fromSection: Int
	public let toSection: Int

	public init(from: Int, to: Int) {
		self.fromSection = from
		self.toSection = to
	}

	public func apply(target: DataChangeTarget) {
		target.ds_moveSection(fromSection, toSection: toSection)
	}

	public func mapSections(map: Int -> Int) -> DataChangeMoveSection {
		return DataChangeMoveSection(from: map(fromSection), to: map(toSection))
	}

}
