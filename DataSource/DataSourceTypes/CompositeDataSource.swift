//
//  CompositeDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class CompositeDataSource: DataSource {
    
    public let changes: Signal<DataChange, NoError>
    private let observer: Signal<DataChange, NoError>.Observer
    private let disposable = CompositeDisposable()
    
    public let innerDataSources: [DataSource]
    
    public init(_ inner: [DataSource]) {
        (self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
        self.innerDataSources = inner
        for (index, dataSource) in inner.enumerate() {
            self.disposable += dataSource.changes
                .map { $0.mapSections(mapOutside(inner, index)) }
                .observe(self.observer)
        }
    }
    
    deinit {
        sendCompleted(self.observer)
        self.disposable.dispose()
    }
    
    public var numberOfSections: Int {
        return self.innerDataSources.reduce(0) {
            subtotal, dataSource in
            return subtotal + dataSource.numberOfSections
        }
    }
    
    public func numberOfItemsInSection(section: Int) -> Int {
        let (index, innerSection) = mapInside(self.innerDataSources, section)
        return self.innerDataSources[index].numberOfItemsInSection(innerSection)
    }
    
    public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
        let (index, innerSection) = mapInside(self.innerDataSources, section)
        return self.innerDataSources[index].supplementaryItemOfKind(kind, inSection: innerSection)
    }
    
    public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
        let (index, innerSection) = mapInside(self.innerDataSources, indexPath.section)
        let innerPath = setSection(innerSection)(indexPath)
        return self.innerDataSources[index].itemAtIndexPath(innerPath)
    }
    
    public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
        let (index, innerSection) = mapInside(self.innerDataSources, indexPath.section)
        let innerPath = setSection(innerSection)(indexPath)
        return self.innerDataSources[index].leafDataSourceAtIndexPath(innerPath)
    }
    
}

func mapInside(inner: [DataSource], _ outerSection: Int) -> (Int, Int) {
    var innerSection = outerSection
    var index = 0
    while innerSection >= inner[index].numberOfSections {
        innerSection -= inner[index].numberOfSections
        index++
    }
    return (index, innerSection)
}

func mapOutside(inner: [DataSource], _ index: Int)(innerSection: Int) -> Int {
    var outerSection = innerSection
    for i in 0 ..< index {
        outerSection += inner[i].numberOfSections
    }
    return outerSection
}
