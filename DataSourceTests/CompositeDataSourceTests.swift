//
//  CompositeDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 06/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import Combine
import DataSource
import Nimble
import Quick

class CompositeDataSourceTests: QuickSpecWithDataSets {
	private var cancellable: AnyCancellable?

	override func spec() {
		var dataSource: CompositeDataSource!
		var staticDataSources: [StaticDataSource<Int>]!
		beforeEach {
			let firstStaticDataSource = StaticDataSource(sections: [DataSourceSection(items: self.testDataSet, supplementaryItems: self.supplementaryItemOfKind)])
			let secondStaticDataSource = StaticDataSource(sections: [DataSourceSection(items: self.testDataSet2)])
			staticDataSources = [firstStaticDataSource, secondStaticDataSource]
			dataSource = CompositeDataSource(staticDataSources)
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSet, self.testDataSet2], "LeafDataSource": staticDataSources!, "SupplementaryItems": [self.supplementaryItemOfKind]] }
		it("should generate corresponding dataChanges") {
			let firstDataSource = StaticDataSource(items: [1, 2, 3])
			let secondDataSource = ProxyDataSource(animateChanges: false)
			dataSource = CompositeDataSource([firstDataSource, secondDataSource])
			let lastChange = CurrentValueSubject<DataChange?, Never>(nil)
			self.cancellable = dataSource.changes.map { Optional($0) }.subscribe(lastChange)
			expect(lastChange.value).to(beNil())
			secondDataSource.innerDataSource.value = StaticDataSource(items: [4, 5, 6])
			expect(lastChange.value).notTo(beNil())
			expect(lastChange.value).to(beAKindOf(DataChangeReloadData.self))
			secondDataSource.animatesChanges = true
			secondDataSource.innerDataSource.value = StaticDataSource(items: [4, 5, 6])
			expect(lastChange.value).to(beAKindOf(DataChangeBatch.self))
			let batches = (lastChange.value as! DataChangeBatch).changes
			expect(batches.count) == 2
			expect(batches.first).to(beAKindOf(DataChangeDeleteSections.self))
			expect(batches.last).to(beAKindOf(DataChangeInsertSections.self))
		}
	}
}
