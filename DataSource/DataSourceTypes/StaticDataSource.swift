//
//  StaticDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import Ry

/// `DataSource` implementation that has an immutable array of section.
///
/// Each section contains an array of items ot type T and
/// (optionally) a dictionary of supplementary items.
///
/// Never emits any dataChanges.
public final class StaticDataSource<T>: DataSource {

	public let changes = Signal<DataChange>.never

	public let sections: [DataSourceSection<T>]

	public init(sections: [DataSourceSection<T>]) {
		self.sections = sections
	}

	/// Convenience initialize that creates a staticDataSource
	/// with a single section and no supplementary items.
	///
	/// Initialize with sections if you need multiple sections
	/// or any supplementary items.
	public convenience init(items: [T]) {
		self.init(sections: [DataSourceSection(items: items)])
	}

	public var numberOfSections: Int {
		return sections.count
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		return sections[section].items.count
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		return sections[section].supplementaryItems[kind]
	}

	public func item(at indexPath: IndexPath) -> Any {
		return sections[indexPath.section].items[indexPath.item]
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		return (self, indexPath)
	}

}
