//
//  AutoDiffDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 10/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa
import Result

/// `DataSource` implementation that has one section of items of type T.
///
/// Whenever the array of items is changed, the autoDiffDataSource compares
/// each pair of old and new items via `compare` function,
/// and produces minimal batch of dataChanges that delete,
/// insert and move individual items.
public final class AutoDiffDataSource<T>: DataSource {

	public let changes: Signal<DataChange, NoError>
	private let observer: Observer<DataChange, NoError>
	private let disposable: Disposable

	/// Mutable array of items in the only section of the autoDiffDataSource.
	///
	/// Every modification of the array causes calculation
	/// and emission of appropriate dataChanges.
	public let items: MutableProperty<[T]>

	public let supplementaryItems: [String: Any]

	/// Function that is used to compare a pair of items for equality.
	/// Returns `true` if the items are equal, and no dataChange is required
	/// to replace the first item with the second.
	public let compare: (T, T) -> Bool

	/// Creates an autoDiffDataSource.
	/// - parameters:
	///   - items: Initial array of items of the only section of the autoDiffDataSource.
	///   - supplementaryItems: Supplementary items of the section.
	///   - findMoves: Set `findMoves` to `false` to make the dataSource emit
	///		a pair of deletion and insertion instead of item movement dataChanges.
	///   - compare: Function that is used to compare a pair of items for equality.
	public init(_ items: [T] = [],
		supplementaryItems: [String: Any] = [:],
		findMoves: Bool = true,
		compare: (T, T) -> Bool)
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
		self.observer.sendCompleted()
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
