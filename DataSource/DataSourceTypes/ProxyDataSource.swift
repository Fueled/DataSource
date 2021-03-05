//
//  ProxyDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Combine
import Foundation

/// `DataSource` implementation that returns data from
/// another dataSource (called inner dataSource).
///
/// The inner dataSource can be switched to a different
/// dataSource instance. In this case the proxyDataSource
/// emits a dataChange reloading its entire data.
///
/// ProxyDataSource listens to dataChanges of its inner dataSource
/// and emits them as its own changes.
public final class ProxyDataSource: DataSource {
	public var innerDataSource: CurrentValueSubject<DataSource, Never>

	/// When `true`, switching innerDataSource produces
	/// a dataChange consisting of deletions of all the
	/// sections of the old inner dataSource and insertion of all
	/// the sections of the new innerDataSource.
	///
	/// when `false`, switching innerDataSource produces `DataChangeReloadData`.
	@Published public var animatesChanges: Bool

	public let changes: AnyPublisher<DataChange, Never>
	private let changesPassthroughSubject = PassthroughSubject<DataChange, Never>()

	private var cancellables = Set<AnyCancellable>()
	private var lastCancellable: AnyCancellable?

	public init(_ innerDataSource: DataSource = EmptyDataSource(), animateChanges: Bool = true) {
		self.changes = self.changesPassthroughSubject.eraseToAnyPublisher()
		self.innerDataSource = CurrentValueSubject(innerDataSource)
		self.animatesChanges = animateChanges
		self.lastCancellable = innerDataSource.changes.subscribe(self.changesPassthroughSubject)
		self.innerDataSource
			.combinePrevious(innerDataSource)
			.dropFirst()
			.sink { [weak self] old, new in
				guard let self = self else {
					return
				}
				self.lastCancellable?.cancel()
				self.changesPassthroughSubject.send(self.changeDataSources(old, new))
				self.lastCancellable = new.changes.subscribe(self.changesPassthroughSubject)
			}
			.store(in: &self.cancellables)
	}

	deinit {
		self.changesPassthroughSubject.send(completion: .finished)
		self.cancellables.forEach { $0.cancel() }
		self.lastCancellable?.cancel()
	}

	public var numberOfSections: Int {
		self.innerDataSource.value.numberOfSections
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		self.innerDataSource.value.numberOfItemsInSection(section)
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		self.innerDataSource.value.supplementaryItemOfKind(kind, inSection: section)
	}

	public func item(at indexPath: IndexPath) -> Any {
		self.innerDataSource.value.item(at: indexPath)
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		self.innerDataSource.value.leafDataSource(at: indexPath)
	}

	private func changeDataSources(_ old: DataSource, _ new: DataSource) -> DataChange {
		if !self.animatesChanges {
			return DataChangeReloadData()
		}
		var batch: [DataChange] = []
		let oldSections = old.numberOfSections
		if oldSections > 0 {
			batch.append(DataChangeDeleteSections(Array(0 ..< oldSections)))
		}
		let newSections = new.numberOfSections
		if newSections > 0 {
			batch.append(DataChangeInsertSections(Array(0 ..< newSections)))
		}
		return DataChangeBatch(batch)
	}
}
