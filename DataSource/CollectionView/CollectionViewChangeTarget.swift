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
		performBatchUpdates(batchChanges, completion: nil)
	}

	public func ds_deleteItems(at indexPaths: [IndexPath]) {
		deleteItems(at: indexPaths)
	}

	public func ds_deleteSections(_ sections: [Int]) {
		deleteSections(IndexSet(ds_integers: sections))
	}

	public func ds_insertItems(at indexPaths: [IndexPath]) {
		insertItems(at: indexPaths)
	}

	public func ds_insertSections(_ sections: [Int]) {
		insertSections(IndexSet(ds_integers: sections))
	}

	public func ds_moveItem(at oldIndexPath: IndexPath, to newIndexPath: IndexPath) {
		moveItem(at: oldIndexPath, to: newIndexPath)
	}

	public func ds_moveSection(_ oldSection: Int, toSection newSection: Int) {
		moveSection(oldSection, toSection: newSection)
	}

	public func ds_reloadData() {
		reloadData()
	}

	public func ds_reloadItems(at indexPaths: [IndexPath]) {
		reloadItems(at: indexPaths)
	}

	public func ds_reloadSections(_ sections: [Int]) {
		reloadSections(IndexSet(ds_integers: sections))
	}

}
