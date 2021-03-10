//
//  MutableCompositeDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 15/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Combine
import Foundation

/// `DataSource` implementation that is composed of a mutable array
/// of other dataSources (called inner dataSources).
///
/// See `CompositeDataSource` for details.
///
/// The array of innerDataSources can be modified by calling methods that perform
/// individual changes and instantly make the dataSource emit
/// a corresponding dataChange.
public final class MutableCompositeDataSource: DataSource {
	public let changes: AnyPublisher<DataChange, Never>
	private let changesPassthroughSubject = PassthroughSubject<DataChange, Never>()
	private var cancellable: AnyCancellable!

	private(set) var innerDataSources: CurrentValueSubject<[DataSource], Never>

	public init(_ innerDataSources: [DataSource] = []) {
		self.changes = self.changesPassthroughSubject.eraseToAnyPublisher()
		self.innerDataSources = CurrentValueSubject(innerDataSources)
		self.cancellable = self.innerDataSources
			.map(Self.changesOfInnerDataSources)
			.switchToLatest()
			.sink { [weak self] in
				self?.changesPassthroughSubject.send($0)
			}
	}

	deinit {
		self.changesPassthroughSubject.send(completion: .finished)
	}

	public var numberOfSections: Int {
		return self.innerDataSources.value.reduce(into: 0) { subtotal, dataSource in
			subtotal += dataSource.numberOfSections
		}
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		let (index, innerSection) = mapInside(self.innerDataSources.value, section)
		return self.innerDataSources.value[index].numberOfItemsInSection(innerSection)
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		let (index, innerSection) = mapInside(self.innerDataSources.value, section)
		return self.innerDataSources.value[index].supplementaryItemOfKind(kind, inSection: innerSection)
	}

	public func item(at indexPath: IndexPath) -> Any {
		let (index, innerSection) = mapInside(self.innerDataSources.value, indexPath.section)
		let innerPath = indexPath.ds_setSection(innerSection)
		return self.innerDataSources.value[index].item(at: innerPath)
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		let (index, innerSection) = mapInside(self.innerDataSources.value, indexPath.section)
		let innerPath = indexPath.ds_setSection(innerSection)
		return self.innerDataSources.value[index].leafDataSource(at: innerPath)
	}

	/// Inserts a given inner dataSource at a given index
	/// and emits `DataChangeInsertSections` for its sections.
	public func insert(_ dataSource: DataSource, at index: Int) {
		self.insert([dataSource], at: index)
	}

	/// Inserts an array of dataSources at a given index
	/// and emits `DataChangeInsertSections` for their sections.
	public func insert(_ dataSources: [DataSource], at index: Int) {
		self.innerDataSources.value.insert(contentsOf: dataSources, at: index)
		let sections = dataSources.enumerated().flatMap { self.sections(of: $1, at: index + $0) }
		if !sections.isEmpty {
			let change = DataChangeInsertSections(sections)
			self.changesPassthroughSubject.send(change)
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
		self.innerDataSources.value.removeSubrange(range)
		if !sections.isEmpty {
			let change = DataChangeDeleteSections(sections)
			self.changesPassthroughSubject.send(change)
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
		self.innerDataSources.value[index] = dataSource
		if !batch.isEmpty {
			let change = DataChangeBatch(batch)
			self.changesPassthroughSubject.send(change)
		}
	}

	/// Moves an inner dataSource at a given index to another index
	/// and emits a batch of `DataChangeMoveSection` for its sections.
	public func moveData(at oldIndex: Int, to newIndex: Int) {
		let oldLocation = mapOutside(self.innerDataSources.value, oldIndex)(0)
		let dataSource = self.innerDataSources.value.remove(at: oldIndex)
		self.innerDataSources.value.insert(dataSource, at: newIndex)
		let newLocation = mapOutside(self.innerDataSources.value, newIndex)(0)
		let numberOfSections = dataSource.numberOfSections
		let batch: [DataChange] = (0 ..< numberOfSections).map {
			DataChangeMoveSection(from: oldLocation + $0, to: newLocation + $0)
		}
		if !batch.isEmpty {
			let change = DataChangeBatch(batch)
			self.changesPassthroughSubject.send(change)
		}
	}

	private func sections(of dataSource: DataSource, at index: Int) -> [Int] {
		let location = mapOutside(self.innerDataSources.value, index)(0)
		let length = dataSource.numberOfSections
		return Array(location..<location + length)
	}

	private func sectionsOfDataSource(at index: Int) -> [Int] {
		let dataSource = self.innerDataSources.value[index]
		return self.sections(of: dataSource, at: index)
	}

	private static func changesOfInnerDataSources(_ innerDataSources: [DataSource]) -> AnyPublisher<DataChange, Never> {
		Publishers.MergeMany(
			innerDataSources.enumerated().map { index, dataSource in
				return dataSource.changes.map {
					$0.mapSections(mapOutside(innerDataSources, index))
				}
				.eraseToAnyPublisher()
			}
		)
			.eraseToAnyPublisher()
	}
}
