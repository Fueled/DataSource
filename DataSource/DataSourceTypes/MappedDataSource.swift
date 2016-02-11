//
//  MappedDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

/// `DataSource` implementation that returns data from
/// another dataSource (called inner dataSource) after transforming
/// its items with `transform` function and transforming its
/// supplementary items with `supplementaryTransform` function.
///
/// MappedDataSource listens to dataChanges of its inner dataSource
/// and emits them as its own changes.
public final class MappedDataSource: DataSource {

	public let changes: Signal<DataChange, NoError>
	private let observer: Observer<DataChange, NoError>
	private let disposable: Disposable?

	public let innerDataSource: DataSource

	/// Function that is applied to items of the inner dataSource
	/// before they are returned as items of the mappedDataSource.
	private let transform: Any -> Any

	/// Function that is applied to supplementary items of the inner dataSource
	/// before they are returned as supplementary items of the mappedDataSource.
	///
	/// The first parameter is the kind of the supplementary item.
	private let supplementaryTransform: (String, Any?) -> Any?

	public init(_ inner: DataSource, supplementaryTransform: ((String, Any?) -> Any?) = { $1 }, transform: Any -> Any) {
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
		self.innerDataSource = inner
		self.transform = transform
		self.supplementaryTransform = supplementaryTransform
		self.disposable = inner.changes.observe(self.observer)
	}

	deinit {
		self.observer.sendCompleted()
		self.disposable?.dispose()
	}

	public var numberOfSections: Int {
		let inner = self.innerDataSource
		return inner.numberOfSections
	}

	public func numberOfItemsInSection(section: Int) -> Int {
		let inner = self.innerDataSource
		return inner.numberOfItemsInSection(section)
	}

	public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
		let inner = self.innerDataSource
		let supplementaryItem = inner.supplementaryItemOfKind(kind, inSection: section)
		return self.supplementaryTransform(kind, supplementaryItem)
	}

	public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
		let inner = self.innerDataSource
		let item = inner.itemAtIndexPath(indexPath)
		return self.transform(item)
	}

	public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
		let inner = self.innerDataSource
		return inner.leafDataSourceAtIndexPath(indexPath)
	}

}
