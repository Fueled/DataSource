//
//  DataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

public protocol DataSource {
    
    var changes: Signal<DataChange, NoError> { get }
    
    var numberOfSections: Int { get }
    
    func numberOfItemsInSection(section: Int) -> Int
    
    func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any?
    
    func itemAtIndexPath(indexPath: NSIndexPath) -> Any
    
    func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath)
    
}
