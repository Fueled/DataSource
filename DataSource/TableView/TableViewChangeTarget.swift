//
//  TableViewChangeTarget.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import UIKit

public class TableViewChangeTarget: DataChangeTarget {
	
	private let tableView: UITableView
	
	init(tableView: UITableView) {
		self.tableView = tableView
	}
	
	public func ds_performBatchChanges(_ batchChanges: @escaping ()->()) {
		self.tableView.beginUpdates()
		batchChanges()
		self.tableView.endUpdates()
	}
	
	public func ds_deleteItems(at indexPaths: [IndexPath]) {
		self.tableView.deleteRows(at: indexPaths, with: .fade)
	}
	
	public func ds_deleteSections(_ sections: [Int]) {
		self.tableView.deleteSections(IndexSet(ds_integers: sections), with: .fade)
	}
	
	public func ds_insertItems(at indexPaths: [IndexPath]) {
		self.tableView.insertRows(at: indexPaths, with: .fade)
	}
	
	public func ds_insertSections(_ sections: [Int]) {
		self.tableView.insertSections(IndexSet(ds_integers: sections), with: .fade)
	}
	
	public func ds_moveItem(at oldIndexPath: IndexPath, to newIndexPath: IndexPath) {
		self.tableView.moveRow(at: oldIndexPath, to: newIndexPath)
	}
	
	public func ds_moveSection(_ oldSection: Int, toSection newSection: Int) {
		self.tableView.moveSection(oldSection, toSection: newSection)
	}
	
	public func ds_reloadData() {
		self.tableView.reloadData()
	}
	
	public func ds_reloadItems(at indexPaths: [IndexPath]) {
		self.tableView.reloadRows(at: indexPaths, with: .fade)
	}
	
	public func ds_reloadSections(_ sections: [Int]) {
		self.tableView.reloadSections(IndexSet(ds_integers: sections), with: .fade)
	}
	
}
