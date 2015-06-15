//
//  CollectionViewChangeTarget.swift
//  DataSource
//
//  Created by Vadim Yelagin on 10/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView: DataChangeTarget {
    
    public func ds_performBatchChanges(batchChanges: () -> ()) {
        self.performBatchUpdates(batchChanges, completion: nil)
    }
    
    public func ds_deleteItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        self.deleteItemsAtIndexPaths(indexPaths)
    }
    
    public func ds_deleteSections(sections: NSIndexSet) {
        self.deleteSections(sections)
    }
    
    public func ds_insertItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        self.insertItemsAtIndexPaths(indexPaths)
    }
    
    public func ds_insertSections(sections: NSIndexSet) {
        self.insertSections(sections)
    }
    
    public func ds_moveItemAtIndexPath(oldIndexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
        self.moveItemAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
    }
    
    public func ds_moveSection(oldSection: Int, toSection newSection: Int) {
        self.moveSection(oldSection, toSection: newSection)
    }
    
    public func ds_reloadData() {
        self.reloadData()
    }
    
    public func ds_reloadItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
        self.reloadItemsAtIndexPaths(indexPaths)
    }
    
    public func ds_reloadSections(sections: NSIndexSet) {
        self.reloadSections(sections)
    }
    
}
