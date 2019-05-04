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

	public func ds_performBatchChanges(_ batchChanges: @escaping () -> Void) {
		self.performBatchUpdates(batchChanges, completion: nil)
	}

	public func ds_deleteItems(at indexPaths: [IndexPath]) {
		self.deleteItems(at: indexPaths)
	}

	public func ds_deleteSections(_ sections: [Int]) {
		self.deleteSections(IndexSet(dsIntegers: sections))
	}

	public func ds_insertItems(at indexPaths: [IndexPath]) {
		self.insertItems(at: indexPaths)
	}

	public func ds_insertSections(_ sections: [Int]) {
		self.insertSections(IndexSet(dsIntegers: sections))
	}

	public func ds_moveItem(at oldIndexPath: IndexPath, to newIndexPath: IndexPath) {
		self.moveItem(at: oldIndexPath, to: newIndexPath)
	}

	public func ds_moveSection(_ oldSection: Int, toSection newSection: Int) {
		self.moveSection(oldSection, toSection: newSection)
	}

	public func ds_reloadData() {
		self.reloadData()
	}

	public func ds_reloadItems(at indexPaths: [IndexPath]) {
		self.reloadItems(at: indexPaths)
	}

	public func ds_reloadSections(_ sections: [Int]) {
		self.reloadSections(IndexSet(dsIntegers: sections))
	}

}
