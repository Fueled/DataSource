//
//  MutableDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 04/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick

class MutableDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: MutableDataSource<Int>!
		beforeEach {
			dataSource = MutableDataSource(self.testDataSet, supplementaryItems: self.supplementaryItemOfKind)
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSet], "SupplementaryItems": [self.supplementaryItemOfKind]] }
		context("when adding new value") {
			beforeEach {
				dataSource.insertItem(self.newElement, at: self.testDataSet.startIndex)
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSetWithNewElement], "SupplementaryItems": [self.supplementaryItemOfKind]] }
		}
		context("when deleting a item") {
			beforeEach {
				dataSource.deleteItem(at: self.testDataSet.startIndex)
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSetWithoutFirstElement], "SupplementaryItems": [self.supplementaryItemOfKind]] }
		}
		context("when replacing a item") {
			beforeEach {
				dataSource.replaceItem(at: self.testDataSet.startIndex, with: self.newElement)
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSetWithReplacedFirstElement], "SupplementaryItems": [self.supplementaryItemOfKind]] }
		}
		context("when replacing items") {
			beforeEach {
				dataSource.replaceItems(with: self.testDataSet2)
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSet2], "SupplementaryItems": [self.supplementaryItemOfKind]] }
		}
		context("when moving items") {
			beforeEach {
				dataSource.moveItem(at: self.testDataSet.startIndex, to: self.testDataSet.index(after: self.testDataSet.startIndex))
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSetWithReplacedFirstWithSecondElement], "SupplementaryItems": [self.supplementaryItemOfKind]] }
		}
	}
}
