//
//  IndexPathExtensions.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

func setSection(section: Int)(_ indexPath: NSIndexPath) -> NSIndexPath {
    return NSIndexPath(forItem: indexPath.item, inSection: section)
}

func mapSection(map: Int -> Int)(_ indexPath: NSIndexPath) -> NSIndexPath {
    return setSection(map(indexPath.section))(indexPath)
}

public extension NSIndexSet {
    
    public convenience init(ds_range: Range<Int>) {
        self.init(indexesInRange: NSRange(location: ds_range.startIndex, length: ds_range.endIndex - ds_range.startIndex))
    }
    
    public convenience init<S: SequenceType where S.Generator.Element == Int>(ds_sequence: S) {
        let res = NSMutableIndexSet()
        for i in ds_sequence {
            res.addIndex(i)
        }
        self.init(indexSet: res)
    }
    
    public func ds_map(transform: Int -> Int) -> NSIndexSet {
        let res = NSMutableIndexSet()
        self.enumerateIndexesUsingBlock {
            index, _ in
            res.addIndex(transform(index))
        }
        return res
    }
    
}
