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

	public func ds_performBatchChanges(_ batchChanges: @escaping () -> ()) {
		self.performBatchUpdates(batchChanges, completion: nil)
	}

	public func ds_deleteItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
		self.deleteItems(at: indexPaths)
	}

	public func ds_deleteSections(_ sections: [Int]) {
		self.deleteSections(IndexSet(integers: sections))
	}

	public func ds_insertItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
		self.insertItems(at: indexPaths)
	}

	public func ds_insertSections(_ sections: [Int]) {
		self.insertSections(IndexSet(integers: sections))
	}

	public func ds_moveItemAtIndexPath(_ oldIndexPath: IndexPath, toIndexPath newIndexPath: IndexPath) {
		self.moveItem(at: oldIndexPath, to: newIndexPath)
	}

	public func ds_moveSection(_ oldSection: Int, toSection newSection: Int) {
		self.moveSection(oldSection, toSection: newSection)
	}

	public func ds_reloadData() {
		self.reloadData()
	}

	public func ds_reloadItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
		self.reloadItems(at: indexPaths)
	}

	public func ds_reloadSections(_ sections: [Int]) {
		self.reloadSections(IndexSet(integers: sections))
	}

}
