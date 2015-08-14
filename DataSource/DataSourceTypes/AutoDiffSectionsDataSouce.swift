//
//  AutoDiffSectionsDataSouce.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/08/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class AutoDiffSectionsDataSouce<T>: DataSource {
    
    public let changes: Signal<DataChange, NoError>
    private let observer: Signal<DataChange, NoError>.Observer
    private let disposable: Disposable
    
    public let sections: MutableProperty<[DataSourceSection<T>]>
    
    public let compareSections: (DataSourceSection<T>, DataSourceSection<T>) -> Bool
    
    public let compareItems: (T, T) -> Bool
    
    public init(sections: [DataSourceSection<T>] = [],
        findItemMoves: Bool = true,
        compareSections: (DataSourceSection<T>, DataSourceSection<T>) -> Bool,
        compareItems: (T, T) -> Bool)
    {
        (self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
        self.sections = MutableProperty(sections)
        self.compareSections = compareSections
        self.compareItems = compareItems
        func autoDiff(oldSections: [DataSourceSection<T>],
            newSections: [DataSourceSection<T>]) -> DataChange
        {
            let sectionsResult = AutoDiff.compare(
                old: oldSections,
                new: newSections,
                findMoves: false,
                compare: compareSections)
            var changes = sectionsResult.toSectionChanges()
            for (oldIndex, newIndex) in sectionsResult.matches {
                let oldItems = oldSections[oldIndex].items
                let newItems = newSections[newIndex].items
                let itemsResult = AutoDiff.compare(
                    old: oldItems,
                    new: newItems,
                    findMoves: findItemMoves,
                    compare: compareItems)
                changes += itemsResult.toItemChanges(oldSection: oldIndex, newSection: newIndex)
            }
            return DataChangeBatch(changes)
        }
        self.disposable = self.sections.producer
            .combinePrevious(sections)
            .skip(1)
            .map(autoDiff)
            .start(self.observer)
    }
    
    deinit {
        sendCompleted(self.observer)
        self.disposable.dispose()
    }
    
    public var numberOfSections: Int {
        return self.sections.value.count
    }
    
    public func numberOfItemsInSection(section: Int) -> Int {
        return self.sections.value[section].items.count
    }
    
    public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
        return self.sections.value[section].supplementaryItems[kind]
    }
    
    public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
        return self.sections.value[indexPath.section].items[indexPath.item]
    }
    
    public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
        return (self, indexPath)
    }
    
}
