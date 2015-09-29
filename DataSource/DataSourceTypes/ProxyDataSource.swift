//
//  ProxyDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

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

	public let changes: Signal<DataChange, NoError>
	private let observer: Event<DataChange, NoError> -> ()
	private let disposable = CompositeDisposable()
	private var lastDisposable: Disposable?

	public let innerDataSource: MutableProperty<DataSource>

	/// When `true`, switching innerDataSource produces
	/// a dataChange consisting of deletions of all the
	/// sections of the old inner dataSource and insertion of all
	/// the sections of the new innerDataSource.
	///
	/// when `false`, switching innerDataSource produces `DataChangeReloadData`.
	public let animatesChanges: MutableProperty<Bool>

	public init(_ inner: DataSource = EmptyDataSource(), animateChanges: Bool = true) {
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
		self.innerDataSource = MutableProperty(inner)
		self.animatesChanges = MutableProperty(animateChanges)
		self.lastDisposable = inner.changes.observe(self.observer)
		self.disposable += self.innerDataSource.producer
			.combinePrevious(inner)
			.skip(1)
			.startWithNext {
				[weak self] old, new in
				if let this = self {
					this.lastDisposable?.dispose()
					sendNext(this.observer, changeDataSources(old, new, this.animatesChanges.value))
					this.lastDisposable = new.changes.observe(this.observer)
				}
		}
	}

	deinit {
		sendCompleted(self.observer)
		self.disposable.dispose()
		self.lastDisposable?.dispose()
	}

	public var numberOfSections: Int {
		let inner = self.innerDataSource.value
		return inner.numberOfSections
	}

	public func numberOfItemsInSection(section: Int) -> Int {
		let inner = self.innerDataSource.value
		return inner.numberOfItemsInSection(section)
	}

	public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
		let inner = self.innerDataSource.value
		return inner.supplementaryItemOfKind(kind, inSection: section)
	}

	public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
		let inner = self.innerDataSource.value
		return inner.itemAtIndexPath(indexPath)
	}

	public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
		let inner = self.innerDataSource.value
		return inner.leafDataSourceAtIndexPath(indexPath)
	}

}

private func changeDataSources(old: DataSource, _ new: DataSource, _ animateChanges: Bool) -> DataChange {
	if !animateChanges {
		return DataChangeReloadData()
	}
	var batch: [DataChange] = []
	let oldSections = old.numberOfSections
	if oldSections > 0 {
		batch.append(DataChangeDeleteSections(0 ..< oldSections))
	}
	let newSections = new.numberOfSections
	if newSections > 0 {
		batch.append(DataChangeInsertSections(0 ..< newSections))
	}
	return DataChangeBatch(batch)
}
