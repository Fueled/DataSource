//
//  StaticDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class StaticDataSource<T>: DataSource {

	public let changes: Signal<DataChange, NoError>
	private let observer: Signal<DataChange, NoError>.Observer

	public let sections: [DataSourceSection<T>]

	public init(sections: [DataSourceSection<T>]) {
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
		self.sections = sections
	}

	deinit {
		sendCompleted(self.observer)
	}

	public convenience init(items: [T]) {
		self.init(sections: [DataSourceSection(items: items)])
	}

	public var numberOfSections: Int {
		return self.sections.count
	}

	public func numberOfItemsInSection(section: Int) -> Int {
		return self.sections[section].items.count
	}

	public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
		return self.sections[section].supplementaryItems[kind]
	}

	public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
		return self.sections[indexPath.section].items[indexPath.item]
	}

	public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
		return (self, indexPath)
	}

}
