//
//  DataChangeMoveItem.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeMoveItem: DataChange {
    
    public let fromIndexPath: NSIndexPath
    public let toIndexPath: NSIndexPath
    
    public init(from: NSIndexPath, to: NSIndexPath) {
        self.fromIndexPath = from
        self.toIndexPath = to
    }
    
    public func apply(target: DataChangeTarget) {
        target.ds_moveItemAtIndexPath(fromIndexPath, toIndexPath: toIndexPath)
    }
    
    public func mapSections(map: Int -> Int) -> DataChangeMoveItem {
        let f = mapSection(map)
        return DataChangeMoveItem(from: f(fromIndexPath), to: f(toIndexPath))
    }
    
}
