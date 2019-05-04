//
//  CompositeDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift

/// `DataSource` implementation that is composed of an array
/// of other dataSources (called inner dataSources).
///
/// Sections of inner dataSources become the sections of the compositeDataSource
/// in the following order: first all the sections of the first inner dataSource,
/// then all the sections of the second inner dataSource, and so on.
///
/// CompositeDataSource listens to dataChanges in all of its inner dataSources
/// and emits them as its own changes, after mapping section indices in them
/// to correspond to the structure of the compositeDataSource.
public final class CompositeDataSource: DataSource {

	public let changes: Signal<DataChange, Never>
	private let observer: Signal<DataChange, Never>.Observer
	private let disposable = CompositeDisposable()

	public let innerDataSources: [DataSource]

	public init(_ inner: [DataSource]) {
		(self.changes, self.observer) = Signal<DataChange, Never>.pipe()
		self.innerDataSources = inner
		for (index, dataSource) in inner.enumerated() {
			self.disposable += dataSource.changes.observeValues { [weak self] change in
				if let self = self {
					let map = mapOutside(self.innerDataSources, index)
					let mapped = change.mapSections(map)
					self.observer.send(value: mapped)
				}
			}
		}
	}

	deinit {
		self.observer.sendCompleted()
		self.disposable.dispose()
	}

	public var numberOfSections: Int {
		return self.innerDataSources.reduce(0) { subtotal, dataSource in
			return subtotal + dataSource.numberOfSections
		}
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		let (index, innerSection) = mapInside(self.innerDataSources, section)
		return self.innerDataSources[index].numberOfItemsInSection(innerSection)
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		let (index, innerSection) = mapInside(self.innerDataSources, section)
		return self.innerDataSources[index].supplementaryItemOfKind(kind, inSection: innerSection)
	}

	public func item(at indexPath: IndexPath) -> Any {
		let (index, innerSection) = mapInside(self.innerDataSources, (indexPath as NSIndexPath).section)
		let innerPath = indexPath.ds_setSection(innerSection)
		return self.innerDataSources[index].item(at: innerPath)
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		let (index, innerSection) = mapInside(self.innerDataSources, (indexPath as NSIndexPath).section)
		let innerPath = indexPath.ds_setSection(innerSection)
		return self.innerDataSources[index].leafDataSource(at: innerPath)
	}

}

func mapInside(_ inner: [DataSource], _ outerSection: Int) -> (Int, Int) {
	var innerSection = outerSection
	var index = 0
	while innerSection >= inner[index].numberOfSections {
		innerSection -= inner[index].numberOfSections
		index += 1
	}
	return (index, innerSection)
}

func mapOutside(_ inner: [DataSource], _ index: Int) -> (Int) -> Int {
	return { innerSection in
		var outerSection = innerSection
		for i in 0 ..< index {
			outerSection += inner[i].numberOfSections
		}
		return outerSection
	}
}
