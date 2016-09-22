//
//  MutableDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result

/// `DataSource` implementation that has one section of items of type T.
///
/// The array of items can be modified by calling methods that perform
/// individual changes and instantly make the dataSource emit
/// a corresponding dataChange.
public final class MutableDataSource<T>: DataSource {

	public let changes: Signal<DataChange, NoError>
	fileprivate let observer: Observer<DataChange, NoError>

	fileprivate let _items: MutableProperty<[T]>

	public var items: Property<[T]> {
		return Property(_items)
	}

	public let supplementaryItems: [String: Any]

	public init(_ items: [T] = [], supplementaryItems: [String: Any] = [:]) {
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
		self._items = MutableProperty(items)
		self.supplementaryItems = supplementaryItems
	}

	deinit {
		self.observer.sendCompleted()
	}

	public let numberOfSections = 1

	public func numberOfItemsInSection(_ section: Int) -> Int {
		return self._items.value.count
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		return self.supplementaryItems[kind]
	}

	public func itemAtIndexPath(_ indexPath: IndexPath) -> Any {
		return self._items.value[indexPath.item]
	}

	public func leafDataSourceAtIndexPath(_ indexPath: IndexPath) -> (DataSource, IndexPath) {
		return (self, indexPath)
	}

	/// Inserts a given item at a given index
	/// and emits `DataChangeInsertItems`.
	public func insertItem(_ item: T, atIndex index: Int) {
		self._items.value.insert(item, at: index)
		let change = DataChangeInsertItems(z(index))
		self.observer.send(value: change)
	}

	/// Deletes an item at a given index
	/// and emits `DataChangeDeleteItems`.
	public func deleteItemAtIndex(_ index: Int) {
		self._items.value.remove(at: index)
		let change = DataChangeDeleteItems(z(index))
		self.observer.send(value: change)
	}

	/// Replaces an item at a given index with another item
	/// and emits `DataChangeReloadItems`.
	public func replaceItemAtIndex(_ index: Int, withItem item: T) {
		self._items.value[index] = item
		let change = DataChangeReloadItems(z(index))
		self.observer.send(value: change)
	}

	/// Moves an item at a given index to another index
	/// and emits `DataChangeMoveItem`.
	public func moveItemAtIndex(index oldIndex: Int, toIndex newIndex: Int) {
		let item = self._items.value.remove(at: oldIndex)
		self._items.value.insert(item, at: newIndex)
		let change = DataChangeMoveItem(from: z(oldIndex), to: z(newIndex))
		self.observer.send(value: change)
	}

	/// Replaces all items with a given array of items
	/// and emits `DataChangeReloadSections`.
	public func replaceItemsWithItems(_ items: [T]) {
		self._items.value = items
		let change = DataChangeReloadSections(sections: [0])
		self.observer.send(value: change)
	}

}

private func z(_ index: Int) -> IndexPath {
	return IndexPath(item: index, section: 0)
}
