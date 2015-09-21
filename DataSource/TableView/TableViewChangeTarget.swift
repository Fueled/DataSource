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

	public func ds_performBatchChanges(batchChanges: ()->()) {
		self.beginUpdates()
		batchChanges()
		self.endUpdates()
	}

	public func ds_deleteItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
		self.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
	}

	public func ds_deleteSections(sections: NSIndexSet) {
		self.deleteSections(sections, withRowAnimation: .Fade)
	}

	public func ds_insertItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
		self.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
	}

	public func ds_insertSections(sections: NSIndexSet) {
		self.insertSections(sections, withRowAnimation: .Fade)
	}

	public func ds_moveItemAtIndexPath(oldIndexPath: NSIndexPath, toIndexPath newIndexPath: NSIndexPath) {
		self.moveRowAtIndexPath(oldIndexPath, toIndexPath: newIndexPath)
	}

	public func ds_moveSection(oldSection: Int, toSection newSection: Int) {
		self.moveSection(oldSection, toSection: newSection)
	}

	public func ds_reloadData() {
		self.reloadData()
	}

	public func ds_reloadItemsAtIndexPaths(indexPaths: [NSIndexPath]) {
		self.reloadRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
	}

	public func ds_reloadSections(sections: NSIndexSet) {
		self.reloadSections(sections, withRowAnimation: .Fade)
	}

}
