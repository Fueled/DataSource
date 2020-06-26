//
//  TableViewDataSourceWithHeaderFooterTitlesTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 05/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick
import ReactiveSwift

class TableViewDataSourceWithHeaderFooterTitlesTests: QuickSpecWithDataSets {
	override func spec() {
		var tableViewDataSource: TableViewDataSourceWithHeaderFooterTitles!
		var tableView: UITableView!
		let headerTitle = "headerTitle"
		let footerTitle = "footerTitle"
		let headerSection = DataSourceSection(items: self.dataSetWithTestCellModels, supplementaryItems: [UICollectionView.elementKindSectionHeader: headerTitle, UICollectionView.elementKindSectionFooter: footerTitle])
		beforeEach {

			let dataSource = Property(value: StaticDataSource(sections: [headerSection]))
			tableViewDataSource = TableViewDataSourceWithHeaderFooterTitles()
			tableView = UITableView(frame: CGRect.zero)
			let tableViewDescriptors = [CellDescriptor(TestTableViewCell.reuseIdentifier, TestCellModel.self, .class(TestTableViewCell.self))]
			tableViewDataSource.configure(tableView, using: tableViewDescriptors)
			tableViewDataSource.dataSource.innerDataSource <~ dataSource.producer.map { $0 as DataSource }
		}
		itBehavesLike("TableViewDataSource object") {
			[
				"tableViewDataSource": tableViewDataSource!,
				"TestCellModels": [self.dataSetWithTestCellModels],
				"TestSections": [headerSection],
				"tableView": tableView!
			]
		}
		it("has correct header") {
			expect(tableViewDataSource.tableView(tableView, titleForHeaderInSection: 0)) == headerTitle
		}
		it("has correct footer") {
			expect(tableViewDataSource.tableView(tableView, titleForFooterInSection: 0)) == footerTitle
		}
	}
}
