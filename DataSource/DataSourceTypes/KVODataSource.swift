//
//  KVODataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import Ry

/// `DataSource` implementation that has a single section and
/// uses key-value coding (KVC) to returns objects from an ordered
/// to-many relation of a target object as its items.
///
/// Uses key-value observing (KVO) internally to observe changes
/// in the to-many relationship and emit them as its own dataChanges.
public final class  KVODataSource: NSObject, DataSource {

	private let changesPipe = SignalPipe<DataChange>()
	public var changes: Signal<DataChange> {
		return changesPipe.signal
	}

	public let target: NSObject
	public let keyPath: String
	public let supplementaryItems: [String: Any]

	public init(target: NSObject, keyPath:String, supplementaryItems: [String: Any] = [:]) {
		self.target = target
		self.keyPath = keyPath
		self.supplementaryItems = supplementaryItems
		super.init()
		target.addObserver(self, forKeyPath: keyPath, options: [], context: nil)
	}

	deinit {
		target.removeObserver(self, forKeyPath: keyPath, context: nil)
	}

	public let numberOfSections = 1

	public func numberOfItemsInSection(_ section: Int) -> Int {
		return items.count
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		return supplementaryItems[kind]
	}

	public func item(at indexPath: IndexPath) -> Any {
		return items[indexPath.item]
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		return (self, indexPath)
	}

	private var items: NSArray {
		return target.value(forKeyPath: keyPath) as! NSArray
	}

	public override func observeValue(
		forKeyPath keyPath: String?,
		of object: Any?,
		change: [NSKeyValueChangeKey : Any]?,
		context: UnsafeMutableRawPointer?)
	{
		if let target = object as? NSObject,
			let change = change,
			let type = change[NSKeyValueChangeKey.kindKey] as? NSKeyValueChange,
			let indices = change[NSKeyValueChangeKey.indexesKey] as? IndexSet,
			keyPath == self.keyPath && target == self.target
		{
			observeChangeOfType(type, atIndices: indices)
		}
	}

	private func observeChangeOfType(_ type: NSKeyValueChange, atIndices indices: IndexSet) {
		var indexPaths: [IndexPath] = []
		for index in indices {
			indexPaths.append(IndexPath(item: index, section: 0))
		}
		switch type {
		case .insertion:
			changesPipe.send(DataChangeInsertItems(indexPaths))
		case .removal:
			changesPipe.send(DataChangeDeleteItems(indexPaths))
		case .replacement:
			changesPipe.send(DataChangeReloadItems(indexPaths))
		case .setting:
			changesPipe.send(DataChangeReloadSections([0]))
		@unknown default:
			assertionFailure("Unknown change in KVODataSource")
		}
	}

}
