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

	func ds_performBatchChanges(_ batchChanges: @escaping () -> Void)

	func ds_deleteItems(at indexPaths: [IndexPath])

	func ds_deleteSections(_ sections: [Int])

	func ds_insertItems(at indexPaths: [IndexPath])

	func ds_insertSections(_ sections: [Int])

	func ds_moveItem(at oldIndexPath: IndexPath, to newIndexPath: IndexPath)

	func ds_moveSection(_ oldSection: Int, toSection newSection: Int)

	func ds_reloadData()

	func ds_reloadItems(at indexPaths: [IndexPath])

	func ds_reloadSections(_ sections: [Int])

}
