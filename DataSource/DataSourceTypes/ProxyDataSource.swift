//
//  ProxyDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import Ry

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

    private let pool = DisposePool()
    public let changes: Signal<DataChange>
	public let innerDataSource: Property<DataSource>

	/// When `true`, switching innerDataSource produces
	/// a dataChange consisting of deletions of all the
	/// sections of the old inner dataSource and insertion of all
	/// the sections of the new innerDataSource.
	///
	/// when `false`, switching innerDataSource produces `DataChangeReloadData`.
	public let animatesChanges: Property<Bool>

	public init(_ inner: DataSource = EmptyDataSource(), animateChanges: Bool = true) {
        self.innerDataSource = Property(initialValue: inner)
        self.animatesChanges = Property(initialValue: animateChanges)
		self.changes = self.innerDataSource.values
            .map(Optional.some)
            .startWith(nil)
			.withPrevious()
            .switchMap {
                [animatesChanges = animatesChanges.getter] old, new -> Signal<DataChange> in
                guard let new = new else {
                    fatalError()
                }
                var result = new.changes
                if let old = old {
                    let change = changeDataSources(old, new, animatesChanges())
                    result = result.startWith(change)
                }
                return result
            }
            .multicast(disposeIn: pool)
	}

	public var numberOfSections: Int {
		let inner = self.innerDataSource.value
		return inner.numberOfSections
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		let inner = self.innerDataSource.value
		return inner.numberOfItemsInSection(section)
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		let inner = self.innerDataSource.value
		return inner.supplementaryItemOfKind(kind, inSection: section)
	}

	public func item(at indexPath: IndexPath) -> Any {
		let inner = self.innerDataSource.value
		return inner.item(at: indexPath)
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		let inner = self.innerDataSource.value
		return inner.leafDataSource(at: indexPath)
	}

}

private func changeDataSources(_ old: DataSource, _ new: DataSource, _ animateChanges: Bool) -> DataChange {
	if !animateChanges {
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
