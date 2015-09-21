//
//  DataChangeTarget.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

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
