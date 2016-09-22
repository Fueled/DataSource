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
		self.beginUpdates()
		batchChanges()
		self.endUpdates()
	}

	public func ds_deleteItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
		self.deleteRows(at: indexPaths, with: .fade)
	}

	public func ds_deleteSections(_ sections: [Int]) {
		self.deleteSections(IndexSet(integers: sections), with: .fade)
	}

	public func ds_insertItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
		self.insertRows(at: indexPaths, with: .fade)
	}

	public func ds_insertSections(_ sections: [Int]) {
		self.insertSections(IndexSet(integers: sections), with: .fade)
	}

	public func ds_moveItemAtIndexPath(_ oldIndexPath: IndexPath, toIndexPath newIndexPath: IndexPath) {
		self.moveRow(at: oldIndexPath, to: newIndexPath)
	}

	public func ds_moveSection(_ oldSection: Int, toSection newSection: Int) {
		self.moveSection(oldSection, toSection: newSection)
	}

	public func ds_reloadData() {
		self.reloadData()
	}

	public func ds_reloadItemsAtIndexPaths(_ indexPaths: [IndexPath]) {
		self.reloadRows(at: indexPaths, with: .fade)
	}

	public func ds_reloadSections(_ sections: [Int]) {
		self.reloadSections(IndexSet(integers: sections), with: .fade)
	}

}
