//
//  KVODataSource.swift
//  YouHue
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class  KVODataSource: NSObject, DataSource {

	public let changes: Signal<DataChange, NoError>
	private let observer: Event<DataChange, NoError> -> ()

	public let target: NSObject
	public let keyPath: String
	public let supplementaryItems: [String: Any]

	public init(target: NSObject, keyPath:String, supplementaryItems: [String: Any] = [:]) {
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
		self.target = target
		self.keyPath = keyPath
		self.supplementaryItems = supplementaryItems
		super.init()
		self.target.addObserver(self, forKeyPath: self.keyPath, options: [], context: nil)
	}

	deinit {
		self.target.removeObserver(self, forKeyPath: self.keyPath, context: nil)
		sendCompleted(self.observer)
	}

	public let numberOfSections = 1

	public func numberOfItemsInSection(section: Int) -> Int {
		return self.items.count
	}

	public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
		return self.supplementaryItems[kind]
	}

	public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
		return self.items[indexPath.item]
	}

	public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
		return (self, indexPath)
	}

	private var items: NSArray {
		return self.target.valueForKeyPath(self.keyPath) as! NSArray
	}

	public override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
		if let target = object as? NSObject,
			let change = change,
			let type = change[NSKeyValueChangeKindKey] as? NSKeyValueChange,
			let indices = change[NSKeyValueChangeIndexesKey] as? NSIndexSet
			where keyPath == self.keyPath && target == self.target
		{
			self.observeChangeOfType(type, atIndices: indices)
		}
	}

	private func observeChangeOfType(type: NSKeyValueChange, atIndices indices: NSIndexSet) {
		var indexPaths: [NSIndexPath] = []
		indices.enumerateIndexesUsingBlock {
			index, _ in
			indexPaths.append(NSIndexPath(forItem: index, inSection: 0))
		}
		switch type {
		case .Insertion:
			sendNext(self.observer, DataChangeInsertItems(indexPaths))
		case .Removal:
			sendNext(self.observer, DataChangeDeleteItems(indexPaths))
		case .Replacement:
			sendNext(self.observer, DataChangeReloadItems(indexPaths))
		case .Setting:
			sendNext(self.observer, DataChangeReloadSections(0))
		}
	}

}
