//
//  EmptyDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Combine
import Foundation

/// `DataSource` implementation that has zero sections.
///
/// Never emits any dataChanges.
public final class EmptyDataSource: DataSource {
	public let changes: AnyPublisher<DataChange, Never>
	private let changesPassthroughSubject = PassthroughSubject<DataChange, Never>()

	public init() {
		self.changes = self.changesPassthroughSubject.eraseToAnyPublisher()
	}

	deinit {
		self.changesPassthroughSubject.send(completion: .finished)
	}

	public let numberOfSections = 0

	public func numberOfItemsInSection(_ section: Int) -> Int {
		fatalError("Trying to access EmptyDataSource.numberOfItemsInSection(_:)")
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		fatalError("Trying to access EmptyDataSource.supplementaryItemOfKind(_:inSection:)")
	}

	public func item(at indexPath: IndexPath) -> Any {
		fatalError("Trying to access EmptyDataSource.item(at:)")
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		fatalError("Trying to access EmptyDataSource.leafDataSource(at:)")
	}
}
