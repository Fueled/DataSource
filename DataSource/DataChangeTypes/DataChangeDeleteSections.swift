//
//  DataChangeDeleteSections.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeDeleteSections: DataChange {

	public let sections: [Int]

	public init(_ sections: [Int]) {
		self.sections = sections
	}

	public func apply(to target: DataChangeTarget) {
		target.ds_deleteSections(sections)
	}

	public func mapSections(_ transform: (Int) -> Int) -> DataChangeDeleteSections {
		return DataChangeDeleteSections(sections.map(transform))
	}

}
