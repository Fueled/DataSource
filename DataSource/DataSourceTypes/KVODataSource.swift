//
//  KVODataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift

/// `DataSource` implementation that has a single section and
/// uses key-value coding (KVC) to returns objects from an ordered
/// to-many relation of a target object as its items.
///
/// Uses key-value observing (KVO) internally to observe changes
/// in the to-many relationship and emit them as its own dataChanges.
public final class  KVODataSource: NSObject, DataSource {

	public let changes: Signal<DataChange, Never>
	private let observer: Signal<DataChange, Never>.Observer

	public let target: NSObject
	public let keyPath: String
	public let supplementaryItems: [String: Any]

	public init(target: NSObject, keyPath: String, supplementaryItems: [String: Any] = [:]) {
		(self.changes, self.observer) = Signal<DataChange, Never>.pipe()
		self.target = target
		self.keyPath = keyPath
		self.supplementaryItems = supplementaryItems
		super.init()
		self.target.addObserver(self, forKeyPath: self.keyPath, options: [], context: nil)
	}

	deinit {
		self.target.removeObserver(self, forKeyPath: self.keyPath, context: nil)
		self.observer.sendCompleted()
	}

	public let numberOfSections = 1

	public func numberOfItemsInSection(_ section: Int) -> Int {
		return self.items.count
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		return self.supplementaryItems[kind]
	}

	public func item(at indexPath: IndexPath) -> Any {
		return self.items[(indexPath as NSIndexPath).item]
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		return (self, indexPath)
	}

	private var items: NSArray {
		return self.target.value(forKeyPath: self.keyPath) as! NSArray
	}
	
	// swiftlint:disable block_based_kvo
	override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey: Any]?, context: UnsafeMutableRawPointer?) {
		if let target = object as? NSObject,
			let change = change,
			let type = change[NSKeyValueChangeKey.kindKey] as? NSKeyValueChange,
			let indices = change[NSKeyValueChangeKey.indexesKey] as? IndexSet,
			keyPath == self.keyPath && target == self.target
		{
			self.observeChangeOfType(type, atIndices: indices)
		}
	}

	private func observeChangeOfType(_ type: NSKeyValueChange, atIndices indices: IndexSet) {
		var indexPaths: [IndexPath] = []
		for index in indices {
			indexPaths.append(IndexPath(item: index, section: 0))
		}
		switch type {
		case .insertion:
			self.observer.send(value: DataChangeInsertItems(indexPaths))
		case .removal:
			self.observer.send(value: DataChangeDeleteItems(indexPaths))
		case .replacement:
			self.observer.send(value: DataChangeReloadItems(indexPaths))
		case .setting:
			self.observer.send(value: DataChangeReloadSections([0]))
		@unknown default:
			NSLog("Unhandled case for NSKeyValueChange: \(type). DataSource should be updated to account for it or it could lead to unexpected results.")
			assertionFailure()
		}
	}

}
