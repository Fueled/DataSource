//
//  EmptyDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

/// `DataSource` implementation that has zero sections.
///
/// Never emits any dataChanges.
public final class EmptyDataSource: DataSource {

	public let changes: Signal<DataChange, NoError>
	fileprivate let observer: Observer<DataChange, NoError>

	public init() {
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
	}

	deinit {
		self.observer.sendCompleted()
	}

	public let numberOfSections = 0

	public func numberOfItemsInSection(_ section: Int) -> Int {
		fatalError("Trying to access EmptyDataSource.numberOfItemsInSection")
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		fatalError("Trying to access EmptyDataSource.supplementaryItemOfKind")
	}

	public func itemAtIndexPath(_ indexPath: IndexPath) -> Any {
		fatalError("Trying to access EmptyDataSource.itemAtIndexPath")
	}

	public func leafDataSourceAtIndexPath(_ indexPath: IndexPath) -> (DataSource, IndexPath) {
		fatalError("Trying to access EmptyDataSource.leafDataSourceAtIndexPath")
	}

}
