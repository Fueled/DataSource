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

	public init(from fromSection: Int, to toSection: Int) {
		self.fromSection = fromSection
		self.toSection = toSection
	}

	public func apply(to target: DataChangeTarget) {
		target.ds_moveSection(fromSection, toSection: toSection)
	}

	public func mapSections(_ transform: (Int) -> Int) -> DataChangeMoveSection {
		return DataChangeMoveSection(from: transform(fromSection), to: transform(toSection))
	}

}
