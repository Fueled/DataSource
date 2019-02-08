//
//  UITableViewDataSourceTests.swift
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

class TableViewDataSourceSharedConfiguration: QuickConfiguration {
	override class func configure(_ configuration: Configuration) {
		sharedExamples("TableViewDataSource object") { (sharedExampleContext: @escaping SharedExampleContext) in
			describe("TableView tests") {
				var tableViewDataSource: TableViewDataSource!
				var initialData: [[TestCellModel]]!
				var tableView: UITableView!
				beforeEach {
					tableViewDataSource = sharedExampleContext()["tableViewDataSource"] as? TableViewDataSource
					initialData = sharedExampleContext()["TestCellModels"] as? [[TestCellModel]]
					tableView = sharedExampleContext()["tableView"] as? UITableView
				}
				it("configure visible cells") {
					tableViewDataSource.configureVisibleCells()
				}
				it("has correct number of section") {
					expect(tableViewDataSource.numberOfSections(in: tableView)) == initialData.count
				}
				it("has correct number of items in sections") {
					for (index, _) in initialData.enumerated() {
						expect(tableViewDataSource.tableView(tableView, numberOfRowsInSection: index)) == initialData[index].count
					}
				}
				it("cells has correct type") {
					for (sectionIndex, element) in initialData.enumerated() {
						for (itemIndex, _) in element.enumerated() {
							expect(tableViewDataSource.tableView(tableView, cellForRowAt: IndexPath(item: itemIndex, section: sectionIndex))).notTo(beNil())
						}
					}
				}
			}
		}
	}
}
