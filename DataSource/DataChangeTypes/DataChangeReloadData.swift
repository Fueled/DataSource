//
//  DataChangeReloadData.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeReloadData: DataChange {
    
    public func apply(target: DataChangeTarget) {
        target.ds_reloadData()
    }
    
    public func mapSections(map: Int -> Int) -> DataChangeReloadData {
        return self
    }
    
}
