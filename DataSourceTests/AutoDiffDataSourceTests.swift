//
//  AutoDiffDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 06/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick
import ReactiveSwift

class AutoDiffDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: AutoDiffDataSource<Int>!
		beforeEach {
			dataSource = AutoDiffDataSource(self.testDataSet, supplementaryItems: self.supplementaryItemOfKind2, findMoves: true, compare: { $0 == $1 })
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSet], "SupplementaryItems": [self.supplementaryItemOfKind2]] }
		context("when changing dataSource items") {
			beforeEach {
				dataSource.items.value = self.testDataSet3
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSet3], "SupplementaryItems": [self.supplementaryItemOfKind2]] }
			it("should generate corresponding dataChanges") {
				let lastChange = MutableProperty<DataChange?>(nil)
				lastChange <~ dataSource.changes
				expect(lastChange.value).to(beNil())
				dataSource.items.value = Array(51...55)
				expect(lastChange.value).notTo(beNil())
				expect(lastChange.value).to(beAKindOf(DataChangeBatch.self))
				var batches = (lastChange.value as! DataChangeBatch).changes
				expect(batches.count) == 1
				expect(batches.first).to(beAKindOf(DataChangeDeleteItems.self))
				dataSource.items.value = [52, 51, 53, 54, 55]
				expect(lastChange.value).to(beAKindOf(DataChangeBatch.self))
				batches = (lastChange.value as! DataChangeBatch).changes
				expect(batches.count) == 1
				expect(batches.first).to(beAKindOf(DataChangeMoveItem.self))
			}
		}
	}
}
