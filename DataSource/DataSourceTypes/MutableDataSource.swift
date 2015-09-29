//
//  MutableDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

/// `DataSource` implementation that has one section of items of type T.
///
/// The array of items can be modified by calling methods that perform
/// individual changes and instantly make the dataSource emit
/// a corresponding dataChange.
public final class MutableDataSource<T>: DataSource {

	public let changes: Signal<DataChange, NoError>
	private let observer: Event<DataChange, NoError> -> ()

	private let _items: MutableProperty<[T]>

	public var items: PropertyOf<[T]> {
		return PropertyOf(_items)
	}

	public let supplementaryItems: [String: Any]

	public init(_ items: [T] = [], supplementaryItems: [String: Any] = [:]) {
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
		self._items = MutableProperty(items)
		self.supplementaryItems = supplementaryItems
	}

	deinit {
		sendCompleted(self.observer)
	}

	public let numberOfSections = 1

	public func numberOfItemsInSection(section: Int) -> Int {
		return self._items.value.count
	}

	public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
		return self.supplementaryItems[kind]
	}

	public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
		return self._items.value[indexPath.item]
	}

	public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
		return (self, indexPath)
	}

	/// Inserts a given item at a given index
	/// and emits `DataChangeInsertItems`.
	public func insertItem(item: T, atIndex index: Int) {
		self._items.value.insert(item, atIndex: index)
		let change = DataChangeInsertItems(z(index))
		sendNext(self.observer, change)
	}

	/// Deletes an item at a given index
	/// and emits `DataChangeDeleteItems`.
	public func deleteItemAtIndex(index: Int) {
		self._items.value.removeAtIndex(index)
		let change = DataChangeDeleteItems(z(index))
		sendNext(self.observer, change)
	}

	/// Replaces an item at a given index with another item
	/// and emits `DataChangeReloadItems`.
	public func replaceItemAtIndex(index: Int, withItem item: T) {
		self._items.value[index] = item
		let change = DataChangeReloadItems(z(index))
		sendNext(self.observer, change)
	}

	/// Moves an item at a given index to another index
	/// and emits `DataChangeMoveItem`.
	public func moveItemAtIndex(index oldIndex: Int, toIndex newIndex: Int) {
		let item = self._items.value.removeAtIndex(oldIndex)
		self._items.value.insert(item, atIndex: newIndex)
		let change = DataChangeMoveItem(from: z(oldIndex), to: z(newIndex))
		sendNext(self.observer, change)
	}

	/// Replaces all items with a given array of items
	/// and emits `DataChangeReloadSections`.
	public func replaceItemsWithItems(items: [T]) {
		self._items.value = items
		let change = DataChangeReloadSections(0)
		sendNext(self.observer, change)
	}

}

private func z(index: Int) -> NSIndexPath {
	return NSIndexPath(forItem: index, inSection: 0)
}
