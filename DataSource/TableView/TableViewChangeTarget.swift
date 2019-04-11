//
//  TableViewChangeTarget.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import UIKit

extension UITableView: DataChangeTarget {

	public func ds_performBatchChanges(_ batchChanges: @escaping ()->()) {
		beginUpdates()
		batchChanges()
		endUpdates()
	}

	public func ds_deleteItems(at indexPaths: [IndexPath]) {
		deleteRows(at: indexPaths, with: .fade)
	}

	public func ds_deleteSections(_ sections: [Int]) {
		deleteSections(IndexSet(ds_integers: sections), with: .fade)
	}

	public func ds_insertItems(at indexPaths: [IndexPath]) {
		insertRows(at: indexPaths, with: .fade)
	}

	public func ds_insertSections(_ sections: [Int]) {
		insertSections(IndexSet(ds_integers: sections), with: .fade)
	}

	public func ds_moveItem(at oldIndexPath: IndexPath, to newIndexPath: IndexPath) {
		moveRow(at: oldIndexPath, to: newIndexPath)
	}

	public func ds_moveSection(_ oldSection: Int, toSection newSection: Int) {
		moveSection(oldSection, toSection: newSection)
	}

	public func ds_reloadData() {
		reloadData()
	}

	public func ds_reloadItems(at indexPaths: [IndexPath]) {
		reloadRows(at: indexPaths, with: .fade)
	}

	public func ds_reloadSections(_ sections: [Int]) {
		reloadSections(IndexSet(ds_integers: sections), with: .fade)
	}

}
