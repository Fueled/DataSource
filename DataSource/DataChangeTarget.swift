//
//  DataChangeTarget.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

/// A target onto which different types of dataChanges can be applied.
/// When a dataChange is applied, the target transitions from reflecting
/// the state of the corresponding dataSource prior to the dataChange
/// to reflecting the dataSource state after the dataChange.
///
/// `UITableView` and `UICollectionView` are implementing this protocol.
public protocol DataChangeTarget {

	func ds_performBatchChanges(batchChanges: ()->())

	func ds_deleteItemsAtIndexPaths(indexPaths: [NSIndexPath])

	func ds_deleteSections(sections: NSIndexSet)

	func ds_insertItemsAtIndexPaths(indexPaths: [NSIndexPath])

	func ds_insertSections(sections: NSIndexSet)

	func ds_moveItemAtIndexPath(oldIndexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath)

	func ds_moveSection(oldSection: Int, toSection newSection: Int)

	func ds_reloadData()

	func ds_reloadItemsAtIndexPaths(indexPaths: [NSIndexPath])

	func ds_reloadSections(sections: NSIndexSet)

}
