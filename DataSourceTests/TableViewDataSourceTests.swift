//
//  TableViewDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 05/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import Combine
import DataSource
import Nimble
import Quick

class TableViewDataSourceTests: QuickSpecWithDataSets {
	var tableViewDataSource: TableViewDataSource!
	var cancellable: AnyCancellable?

	override func spec() {
		var tableView: UITableView!
		let testSections = [
			DataSourceSection(items: self.dataSetWithTestCellModels),
			DataSourceSection(items: self.dataSetWithTestCellModels2)
		]
		beforeEach {
			let dataSource = CurrentValueSubject<StaticDataSource, Never>(
				StaticDataSource(
					sections: testSections
				)
			)
			self.tableViewDataSource = TableViewDataSource()
			tableView = UITableView(frame: CGRect.zero)
			let tableViewDescriptors = [CellDescriptor(TestTableViewCell.reuseIdentifier, TestCellModel.self, .class(TestTableViewCell.self))]
			self.tableViewDataSource.configure(tableView, using: tableViewDescriptors)
			self.cancellable = dataSource
				.map { $0 as DataSource }
				.assign(to: \.dataSource.innerDataSource, on: self.tableViewDataSource)
		}
		itBehavesLike("TableViewDataSource object") {
			[
				"tableViewDataSource": self.tableViewDataSource!,
				"TestCellModels": [self.dataSetWithTestCellModels, self.dataSetWithTestCellModels2],
				"TestSections": testSections,
				"tableView": tableView!
			]
		}
	}
}
