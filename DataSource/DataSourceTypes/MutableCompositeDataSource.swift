//
//  MutableCompositeDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 15/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift

/// `DataSource` implementation that is composed of a mutable array
/// of other dataSources (called inner dataSources).
///
/// See `CompositeDataSource` for details.
///
/// The array of innerDataSources can be modified by calling methods that perform
/// individual changes and instantly make the dataSource emit
/// a corresponding dataChange.
public final class MutableCompositeDataSource: DataSource {

	public let changes: Signal<DataChange, Never>
	private let observer: Signal<DataChange, Never>.Observer
	private let disposable = CompositeDisposable()

	private let _innerDataSources: MutableProperty<[DataSource]>

	public var innerDataSources: Property<[DataSource]> {
		return Property(_innerDataSources)
	}

	public init(_ inner: [DataSource] = []) {
		(self.changes, self.observer) = Signal<DataChange, Never>.pipe()
		self._innerDataSources = MutableProperty(inner)
		self.disposable += self._innerDataSources.producer
			.flatMap(.latest, changesOfInnerDataSources)
			.start(self.observer)
	}

	deinit {
		self.observer.sendCompleted()
		self.disposable.dispose()
	}

	public var numberOfSections: Int {
		return self._innerDataSources.value.reduce(0) { subtotal, dataSource in
			return subtotal + dataSource.numberOfSections
		}
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		let (index, innerSection) = mapInside(self._innerDataSources.value, section)
		return self._innerDataSources.value[index].numberOfItemsInSection(innerSection)
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		let (index, innerSection) = mapInside(self._innerDataSources.value, section)
		return self._innerDataSources.value[index].supplementaryItemOfKind(kind, inSection: innerSection)
	}

	public func item(at indexPath: IndexPath) -> Any {
		let (index, innerSection) = mapInside(self._innerDataSources.value, indexPath.section)
		let innerPath = indexPath.ds_setSection(innerSection)
		return self._innerDataSources.value[index].item(at: innerPath)
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		let (index, innerSection) = mapInside(self._innerDataSources.value, indexPath.section)
		let innerPath = indexPath.ds_setSection(innerSection)
		return self._innerDataSources.value[index].leafDataSource(at: innerPath)
	}

	/// Inserts a given inner dataSource at a given index
	/// and emits `DataChangeInsertSections` for its sections.
	public func insert(_ dataSource: DataSource, at index: Int) {
		self.insert([dataSource], at: index)
	}

	/// Inserts an array of dataSources at a given index
	/// and emits `DataChangeInsertSections` for their sections.
	public func insert(_ dataSources: [DataSource], at index: Int) {
		self._innerDataSources.value.insert(contentsOf: dataSources, at: index)
		let sections = dataSources.enumerated().flatMap { self.sections(of: $1, at: index + $0) }
		if !sections.isEmpty {
			let change = DataChangeInsertSections(sections)
			self.observer.send(value: change)
		}
	}

	/// Deletes an inner dataSource at a given index
	/// and emits `DataChangeDeleteSections` for its sections.
	public func delete(at index: Int) {
		self.delete(in: Range(index...index))
	}

	/// Deletes an inner dataSource in the given range
	/// and emits `DataChangeDeleteSections` for its corresponding sections.
	public func delete(in range: Range<Int>) {
		let sections = range.flatMap(self.sectionsOfDataSource)
		self._innerDataSources.value.removeSubrange(range)
		if !sections.isEmpty {
			let change = DataChangeDeleteSections(sections)
			self.observer.send(value: change)
		}
	}

	/// Replaces an inner dataSource at a given index with another inner dataSource
	/// and emits a batch of `DataChangeDeleteSections` and `DataChangeInsertSections`
	/// for their sections.
	public func replaceDataSource(at index: Int, with dataSource: DataSource) {
		var batch: [DataChange] = []
		let oldSections = self.sectionsOfDataSource(at: index)
		if !oldSections.isEmpty {
			batch.append(DataChangeDeleteSections(oldSections))
		}
		let newSections = self.sections(of: dataSource, at: index)
		if !newSections.isEmpty {
			batch.append(DataChangeInsertSections(newSections))
		}
		self._innerDataSources.value[index] = dataSource
		if !batch.isEmpty {
			let change = DataChangeBatch(batch)
			self.observer.send(value: change)
		}
	}

	/// Moves an inner dataSource at a given index to another index
	/// and emits a batch of `DataChangeMoveSection` for its sections.
	public func moveData(at oldIndex: Int, to newIndex: Int) {
		let oldLocation = mapOutside(self._innerDataSources.value, oldIndex)(0)
		let dataSource = self._innerDataSources.value.remove(at: oldIndex)
		self._innerDataSources.value.insert(dataSource, at: newIndex)
		let newLocation = mapOutside(self._innerDataSources.value, newIndex)(0)
		let numberOfSections = dataSource.numberOfSections
		let batch: [DataChange] = (0 ..< numberOfSections).map {
			DataChangeMoveSection(from: oldLocation + $0, to: newLocation + $0)
		}
		if !batch.isEmpty {
			let change = DataChangeBatch(batch)
			self.observer.send(value: change)
		}
	}

	private func sections(of dataSource: DataSource, at index: Int) -> [Int] {
		let location = mapOutside(self._innerDataSources.value, index)(0)
		let length = dataSource.numberOfSections
		return Array(location ..< location + length)
	}

	private func sectionsOfDataSource(at index: Int) -> [Int] {
		let dataSource = self._innerDataSources.value[index]
		return self.sections(of: dataSource, at: index)
	}

}

private func changesOfInnerDataSources(_ innerDataSources: [DataSource]) -> SignalProducer<DataChange, Never> {
	let arrayOfSignals = innerDataSources.enumerated().map { index, dataSource in
		return dataSource.changes.map {
			$0.mapSections(mapOutside(innerDataSources, index))
		}
	}
	return SignalProducer { observer, disposable in
		for signal in arrayOfSignals {
			disposable += signal.observe(observer)
		}
	}
}
