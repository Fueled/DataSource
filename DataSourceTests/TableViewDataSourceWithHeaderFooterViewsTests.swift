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
import Combine

class TableViewDataSourceWithHeaderFooterViewsTests: QuickSpecWithDataSets {
	var tableViewDataSource: TableViewDataSourceWithHeaderFooterViews!
	var cancellable: AnyCancellable?

	override func spec() {
		var tableView: UITableView!

		let testSections = [
			DataSourceSection(
				items: self.dataSetWithTestCellModels,
				supplementaryItems: [
					UICollectionView.elementKindSectionHeader: TestHeaderFirstViewModel(),
					UICollectionView.elementKindSectionFooter: TestFooterFirstViewModel()
				]
			),
			DataSourceSection(
				items: self.dataSetWithTestCellModels,
				supplementaryItems: [
					UICollectionView.elementKindSectionHeader: TestHeaderSecondViewModel(),
					UICollectionView.elementKindSectionFooter: TestFooterSecondViewModel()
				]
			),
		]

		beforeEach {
			let dataSource = CurrentValueSubject<StaticDataSource, Never>(
				StaticDataSource(
					sections: testSections
				)
			)
			self.tableViewDataSource = TableViewDataSourceWithHeaderFooterViews()
			tableView = UITableView(frame: CGRect.zero)
			let cellDescriptors = [
				CellDescriptor(TestTableViewCell.reuseIdentifier, TestCellModel.self, .class(TestTableViewCell.self))
			]
			self.tableViewDataSource.configure(
				tableView,
				using: cellDescriptors,
				headerDescriptors: [
					HeaderFooterDescriptor(TestHeaderFirstView.reuseIdentifier, TestHeaderFirstViewModel.self, .class(TestHeaderFirstView.self)),
					HeaderFooterDescriptor(TestHeaderSecondView.reuseIdentifier, TestHeaderSecondViewModel.self, .class(TestHeaderSecondView.self)),
				],
				footerDescriptors: [
					HeaderFooterDescriptor(TestFooterFirstView.reuseIdentifier, TestFooterFirstViewModel.self, .class(TestFooterFirstView.self)),
					HeaderFooterDescriptor(TestFooterSecondView.reuseIdentifier, TestFooterSecondViewModel.self, .class(TestFooterSecondView.self)),
				]
			)
			self.cancellable = dataSource
				.map { $0 as DataSource }
				.assign(to: \.dataSource.innerDataSource, on: self.tableViewDataSource)
		}

		itBehavesLike("TableViewDataSource object") {
			[
				"tableViewDataSource": self.tableViewDataSource!,
				"TestCellModels": [self.dataSetWithTestCellModels],
				"TestSections": testSections,
				"tableView": tableView!
			]
		}
		it("has header") {
			expect(self.tableViewDataSource.tableView(tableView, viewForHeaderInSection: 0)).to(beAKindOf(TestHeaderFirstView.self))
			expect(self.tableViewDataSource.tableView(tableView, viewForHeaderInSection: 1)).to(beAKindOf(TestHeaderSecondView.self))
		}
		it("has footer") {
			expect(self.tableViewDataSource.tableView(tableView, viewForFooterInSection: 0)).to(beAKindOf(TestFooterFirstView.self))
			expect(self.tableViewDataSource.tableView(tableView, viewForFooterInSection: 1)).to(beAKindOf(TestFooterSecondView.self))
		}
	}
}
