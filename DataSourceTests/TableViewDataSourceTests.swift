//
//  TableViewDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 05/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import UIKit
import XCTest
import DataSource
import ReactiveSwift
import Quick
import Nimble

class TableViewDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var tableViewDataSource: TableViewDataSource!
		var tableView: UITableView!
		beforeEach {
			let dataSource = Property(value: StaticDataSource(items: self.dataSetWithTestCellModels))
			tableViewDataSource = TableViewDataSource()
			tableView = UITableView(frame: CGRect.zero)
			let tableViewDescriptors = [CellDescriptor(TestTableViewCell.reuseIdentifier, TestCellModel.self, .class(TestTableViewCell.self))]
			tableViewDataSource.configure(tableView, using: tableViewDescriptors)
			tableViewDataSource.dataSource.innerDataSource <~ dataSource.producer.map { $0 as DataSource }
		}
		itBehavesLike("TableViewDataSource object") { ["tableViewDataSource": tableViewDataSource, "TestCellModels": self.dataSetWithTestCellModels, "tableView": tableView] }
	}
}
