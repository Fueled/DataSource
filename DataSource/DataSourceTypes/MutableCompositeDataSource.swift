//
//  MutableCompositeDataSource.swift
//  YouHue
//
//  Created by Vadim Yelagin on 15/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class MutableCompositeDataSource: DataSource {
    
    public let changes: Signal<DataChange, NoError>
    private let observer: Signal<DataChange, NoError>.Observer
    private let disposable = CompositeDisposable()
    
    private let _innerDataSources: MutableProperty<[DataSource]>
    
    public var innerDataSources: PropertyOf<[DataSource]> {
        return PropertyOf(_innerDataSources)
    }
    
    public init(_ inner: [DataSource] = []) {
        (self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
        self._innerDataSources = MutableProperty(inner)
        self.disposable += self._innerDataSources.producer
            |> flatMap(.Latest, changesOfInnerDataSources)
            |> start(self.observer)
    }
    
    deinit {
        sendCompleted(self.observer)
        self.disposable.dispose()
    }
    
    public var numberOfSections: Int {
        return reduce(self._innerDataSources.value, 0) {
            subtotal, dataSource in
            return subtotal + dataSource.numberOfSections
        }
    }
    
    public func numberOfItemsInSection(section: Int) -> Int {
        let (index, innerSection) = mapInside(self._innerDataSources.value, section)
        return self._innerDataSources.value[index].numberOfItemsInSection(innerSection)
    }
    
    public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
        let (index, innerSection) = mapInside(self._innerDataSources.value, section)
        return self._innerDataSources.value[index].supplementaryItemOfKind(kind, inSection: innerSection)
    }
    
    public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
        let (index, innerSection) = mapInside(self._innerDataSources.value, indexPath.section)
        let innerPath = setSection(innerSection)(indexPath)
        return self._innerDataSources.value[index].itemAtIndexPath(innerPath)
    }
    
    public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
        let (index, innerSection) = mapInside(self._innerDataSources.value, indexPath.section)
        let innerPath = setSection(innerSection)(indexPath)
        return self._innerDataSources.value[index].leafDataSourceAtIndexPath(innerPath)
    }
    
    public func insertDataSource(dataSource: DataSource, atIndex index: Int) {
        let sections = self.sectionsOfDataSource(dataSource, atIndex: index)
        self._innerDataSources.value.insert(dataSource, atIndex: index)
        if sections.count > 0 {
            let change = DataChangeInsertSections(sections)
            sendNext(self.observer, change)
        }
    }
    
    public func deleteDataSourceAtIndex(index: Int) {
        let sections = self.sectionsOfDataSourceAtIndex(index)
        self._innerDataSources.value.removeAtIndex(index)
        if sections.count > 0 {
            let change = DataChangeDeleteSections(sections)
            sendNext(self.observer, change)
        }
    }
    
    public func replaceDataSourceAtIndex(index: Int, withDataSource dataSource: DataSource) {
        var batch: [DataChange] = []
        let oldSections = self.sectionsOfDataSourceAtIndex(index)
        if oldSections.count > 0 {
            batch.append(DataChangeDeleteSections(oldSections))
        }
        let newSections = self.sectionsOfDataSource(dataSource, atIndex: index)
        if newSections.count > 0 {
            batch.append(DataChangeInsertSections(newSections))
        }
        self._innerDataSources.value[index] = dataSource
        if !batch.isEmpty {
            let change = DataChangeBatch(batch)
            sendNext(self.observer, change)
        }
    }
    
    public func moveDataSourceAtIndex(index oldIndex: Int, toIndex newIndex: Int) {
        let oldLocation = mapOutside(self._innerDataSources.value, oldIndex)(innerSection: 0)
        let dataSource = self._innerDataSources.value.removeAtIndex(oldIndex)
        self._innerDataSources.value.insert(dataSource, atIndex: newIndex)
        let newLocation = mapOutside(self._innerDataSources.value, newIndex)(innerSection: 0)
        let numberOfSections = dataSource.numberOfSections
        let batch: [DataChange] = map(0 ..< numberOfSections) {
            DataChangeMoveSection(from: oldLocation + $0, to: newLocation + $0)
        }
        if !batch.isEmpty {
            let change = DataChangeBatch(batch)
            sendNext(self.observer, change)
        }
    }
    
    private func sectionsOfDataSource(dataSource: DataSource, atIndex index: Int) -> NSIndexSet {
        let location = mapOutside(self._innerDataSources.value, index)(innerSection: 0)
        let length = dataSource.numberOfSections
        return NSIndexSet(indexesInRange: NSMakeRange(location, length))
    }
    
    private func sectionsOfDataSourceAtIndex(index: Int) -> NSIndexSet {
        let dataSource = self._innerDataSources.value[index]
        return self.sectionsOfDataSource(dataSource, atIndex: index)
    }
    
}

private func changesOfInnerDataSources(innerDataSources: [DataSource]) -> SignalProducer<DataChange, NoError> {
    let arrayOfSignals = map(enumerate(innerDataSources)) {
        index, dataSource in
        return dataSource.changes
            |> map {
                $0.mapSections(mapOutside(innerDataSources, index))
            }
    }
    return SignalProducer {
        observer, disposable in
        for signal in arrayOfSignals {
            disposable += signal.observe(observer)
        }
    }
}
