//
//  TableViewDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 05/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick
import ReactiveSwift

class TableViewDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var tableViewDataSource: TableViewDataSource!
		var tableView: UITableView!
		let testSections = [
			DataSourceSection(items: self.dataSetWithTestCellModels),
			DataSourceSection(items: self.dataSetWithTestCellModels2)
		]
		beforeEach {
			let dataSource = Property(
				value: StaticDataSource(
					sections: testSections
				)
			)
			tableViewDataSource = TableViewDataSource()
			tableView = UITableView(frame: CGRect.zero)
			let tableViewDescriptors = [CellDescriptor(TestTableViewCell.reuseIdentifier, TestCellModel.self, .class(TestTableViewCell.self))]
			tableViewDataSource.configure(tableView, using: tableViewDescriptors)
			tableViewDataSource.dataSource.innerDataSource <~ dataSource.producer.map { $0 as DataSource }
		}
		itBehavesLike("TableViewDataSource object") {
			[
				"tableViewDataSource": tableViewDataSource!,
				"TestCellModels": [self.dataSetWithTestCellModels, self.dataSetWithTestCellModels2],
				"TestSections": testSections,
				"tableView": tableView!
			]
		}
	}
}
