//
//  TableViewDataSourceWithHeaderFooterViewsTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 05/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick
import ReactiveSwift

class TableViewDataSourceWithHeaderFooterViewsTests: QuickSpecWithDataSets {
	override func spec() {
		var tableViewDataSource: TableViewDataSourceWithHeaderFooterViews!
		var tableView: UITableView!
		beforeEach {
			let headerFooterView = TestHeaderFooterViewModel()
			let headerSection = DataSourceSection(
				items: self.dataSetWithTestCellModels,
				supplementaryItems: [UICollectionView.elementKindSectionHeader: headerFooterView, UICollectionView.elementKindSectionFooter: headerFooterView])
			let dataSource = Property(value: StaticDataSource(sections: [headerSection]))
			tableViewDataSource = TableViewDataSourceWithHeaderFooterViews()
			tableView = UITableView(frame: CGRect.zero)
			let tableViewDescriptors = [CellDescriptor(TestTableViewCell.reuseIdentifier, TestCellModel.self, .class(TestTableViewCell.self))]
			tableViewDataSource.configure(
				tableView,
				using: tableViewDescriptors,
				headerDescriptor: HeaderFooterDescriptor(TestHeaderFooterView.reuseIdentifier, TestHeaderFooterViewModel.self, .class(TestHeaderFooterView.self)),
				footerDescriptor: HeaderFooterDescriptor(TestHeaderFooterView.reuseIdentifier, TestHeaderFooterViewModel.self, .class(TestHeaderFooterView.self)))
			tableViewDataSource.dataSource.innerDataSource <~ dataSource.producer.map { $0 as DataSource }
		}
		itBehavesLike("TableViewDataSource object") { ["tableViewDataSource": tableViewDataSource!, "TestCellModels": [self.dataSetWithTestCellModels], "tableView": tableView!] }
		it("has header") {
			 expect(tableViewDataSource.tableView(tableView, viewForHeaderInSection: 0)).notTo(beNil())
		}
		it("has footer") {
			expect(tableViewDataSource.tableView(tableView, viewForFooterInSection: 0)).notTo(beNil())
		}
	}
}
