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

	public func ds_performBatchChanges(_ batchChanges: @escaping () -> Void) {
		self.beginUpdates()
		batchChanges()
		self.endUpdates()
	}

	public func ds_deleteItems(at indexPaths: [IndexPath]) {
		self.deleteRows(at: indexPaths, with: .fade)
	}

	public func ds_deleteSections(_ sections: [Int]) {
		self.deleteSections(IndexSet(dsIntegers: sections), with: .fade)
	}

	public func ds_insertItems(at indexPaths: [IndexPath]) {
		self.insertRows(at: indexPaths, with: .fade)
	}

	public func ds_insertSections(_ sections: [Int]) {
		self.insertSections(IndexSet(dsIntegers: sections), with: .fade)
	}

	public func ds_moveItem(at oldIndexPath: IndexPath, to newIndexPath: IndexPath) {
		self.moveRow(at: oldIndexPath, to: newIndexPath)
	}

	public func ds_moveSection(_ oldSection: Int, toSection newSection: Int) {
		self.moveSection(oldSection, toSection: newSection)
	}

	public func ds_reloadData() {
		self.reloadData()
	}

	public func ds_reloadItems(at indexPaths: [IndexPath]) {
		self.reloadRows(at: indexPaths, with: .fade)
	}

	public func ds_reloadSections(_ sections: [Int]) {
		self.reloadSections(IndexSet(dsIntegers: sections), with: .fade)
	}

}
