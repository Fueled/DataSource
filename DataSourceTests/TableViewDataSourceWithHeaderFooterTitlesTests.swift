//
//  TableViewDataSourceWithHeaderFooterTitlesTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 05/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import Combine
import DataSource
import Nimble
import Quick

class TableViewDataSourceWithHeaderFooterTitlesTests: QuickSpecWithDataSets {
	var tableViewDataSource: TableViewDataSourceWithHeaderFooterTitles!
	var cancellable: AnyCancellable?

	override func spec() {
		var tableView: UITableView!
		let headerTitle = "headerTitle"
		let footerTitle = "footerTitle"
		let headerSection = DataSourceSection(items: self.dataSetWithTestCellModels, supplementaryItems: [UICollectionView.elementKindSectionHeader: headerTitle, UICollectionView.elementKindSectionFooter: footerTitle])
		beforeEach {
			let dataSource = CurrentValueSubject<StaticDataSource, Never>(
				StaticDataSource(
					sections: [headerSection]
				)
			)
			self.tableViewDataSource = TableViewDataSourceWithHeaderFooterTitles()
			tableView = UITableView(frame: .zero)
			let tableViewDescriptors = [CellDescriptor(TestTableViewCell.reuseIdentifier, TestCellModel.self, .class(TestTableViewCell.self))]
			self.tableViewDataSource.configure(tableView, using: tableViewDescriptors)
			self.cancellable = dataSource
				.map { $0 as DataSource }
				.subscribe(self.tableViewDataSource.dataSource.innerDataSource)
		}
		itBehavesLike("TableViewDataSource object") {
			[
				"tableViewDataSource": self.tableViewDataSource!,
				"TestCellModels": [self.dataSetWithTestCellModels],
				"TestSections": [headerSection],
				"tableView": tableView!,
			]
		}
		it("has correct header") {
			expect(self.tableViewDataSource.tableView(tableView, titleForHeaderInSection: 0)) == headerTitle
		}
		it("has correct footer") {
			expect(self.tableViewDataSource.tableView(tableView, titleForFooterInSection: 0)) == footerTitle
		}
	}
}
