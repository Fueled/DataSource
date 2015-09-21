//
//  AutoDiffDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 10/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class AutoDiffDataSource<T>: DataSource {

	public let changes: Signal<DataChange, NoError>
	private let observer: Signal<DataChange, NoError>.Observer
	private let disposable: Disposable

	public let items: MutableProperty<[T]>

	public let supplementaryItems: [String: Any]

	public let compare: (T, T) -> Bool

	public init(_ items: [T] = [],
		supplementaryItems: [String: Any] = [:],
		findMoves: Bool = true,
		_ compare: (T, T) -> Bool)
	{
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
		self.items = MutableProperty(items)
		self.supplementaryItems = supplementaryItems
		self.compare = compare
		func autoDiff(old: [T], new: [T]) -> DataChange {
			let result = AutoDiff.compare(old: old, new: new, findMoves: findMoves, compare: compare)
			return DataChangeBatch(result.toItemChanges())
		}
		self.disposable = self.items.producer
			.combinePrevious(items)
			.skip(1)
			.map(autoDiff)
			.start(self.observer)
	}

	deinit {
		sendCompleted(self.observer)
		self.disposable.dispose()
	}

	public let numberOfSections = 1

	public func numberOfItemsInSection(section: Int) -> Int {
		return self.items.value.count
	}

	public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
		return self.supplementaryItems[kind]
	}

	public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
		return self.items.value[indexPath.item]
	}

	public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
		return (self, indexPath)
	}

}
