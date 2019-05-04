//
//  StaticDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift

/// `DataSource` implementation that has an immutable array of section.
/// 
/// Each section contains an array of items ot type T and
/// (optionally) a dictionary of supplementary items.
///
/// Never emits any dataChanges.
public final class StaticDataSource<T>: DataSource {

	public let changes: Signal<DataChange, Never>
	private let observer: Signal<DataChange, Never>.Observer

	public let sections: [DataSourceSection<T>]

	public init(sections: [DataSourceSection<T>]) {
		(self.changes, self.observer) = Signal<DataChange, Never>.pipe()
		self.sections = sections
	}

	deinit {
		self.observer.sendCompleted()
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
		return self.sections.count
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		return self.sections[section].items.count
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		return self.sections[section].supplementaryItems[kind]
	}

	public func item(at indexPath: IndexPath) -> Any {
		return self.sections[(indexPath as NSIndexPath).section].items[(indexPath as NSIndexPath).item]
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		return (self, indexPath)
	}

}
