//
//  EmptyDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class EmptyDataSource: DataSource {
    
    public let changes: Signal<DataChange, NoError>
    private let observer: Signal<DataChange, NoError>.Observer
    
    public init() {
        (self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
    }
    
    deinit {
        sendCompleted(self.observer)
    }
    
    public let numberOfSections = 0
    
    public func numberOfItemsInSection(section: Int) -> Int {
        fatalError("Trying to access EmptyDataSource.numberOfItemsInSection")
    }
    
    public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
        fatalError("Trying to access EmptyDataSource.supplementaryItemOfKind")
    }
    
    public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
        fatalError("Trying to access EmptyDataSource.itemAtIndexPath")
    }
    
    public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
        fatalError("Trying to access EmptyDataSource.leafDataSourceAtIndexPath")
    }
    
}
