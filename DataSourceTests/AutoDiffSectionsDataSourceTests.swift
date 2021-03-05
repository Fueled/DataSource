//
//  AutoDiffSectionsDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 06/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick
import ReactiveSwift

class AutoDiffSectionsDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: AutoDiffSectionsDataSource<Int>!
		var dataSourceSection1: DataSourceSection<Int>!
		var dataSourceSection2: DataSourceSection<Int>!
		var dataSourceSections: [DataSourceSection<Int>]!
		beforeEach {
			dataSourceSection1 = DataSourceSection(items: self.testDataSet, supplementaryItems: ["sectionId": "1"])
			dataSourceSection2 = DataSourceSection(items: self.testDataSet2, supplementaryItems: ["sectionId": "2"])
			dataSourceSections = [dataSourceSection1, dataSourceSection2]
			dataSource = AutoDiffSectionsDataSource(
				sections: dataSourceSections,
				findItemMoves: true,
				compareSections:
				{
					let header0 = $0.supplementaryItems["sectionId"] as! String
					let header1 = $1.supplementaryItems["sectionId"] as! String
					return header0 == header1
				},
				compareItems: { $0 == $1 })
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSet, self.testDataSet2]] }
		context("when changing dataSource sections") {
			beforeEach {
				dataSourceSections = [dataSourceSection2, dataSourceSection1]
				dataSource.sections.value = dataSourceSections
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSet2, self.testDataSet]] }
			it("should generate corresponding dataChanges") {
				let lastChange = MutableProperty<DataChange?>(nil)
				lastChange <~ dataSource.changes
				expect(lastChange.value).to(beNil())
				dataSource.sections.value.append(DataSourceSection(items: self.testDataSet3, supplementaryItems: ["sectionId": "3"]))
				expect(lastChange.value).notTo(beNil())
				expect(lastChange.value).to(beAKindOf(DataChangeBatch.self))
				var batches = (lastChange.value as! DataChangeBatch).changes
				expect(batches.count) == 1
				expect(batches.first).to(beAKindOf(DataChangeInsertSections.self))
				dataSource.sections.value[2] = DataSourceSection(items: self.testDataSet3 + [56], supplementaryItems: ["sectionId": "3"])
				expect(lastChange.value).to(beAKindOf(DataChangeBatch.self))
				batches = (lastChange.value as! DataChangeBatch).changes
				expect(batches.count) == 1
				expect(batches.first).to(beAKindOf(DataChangeInsertItems.self))
				expect((batches.first as! DataChangeInsertItems).indexPaths.first).to(be(IndexPath(row: 6, section: 2)))
			}
		}
	}
}
