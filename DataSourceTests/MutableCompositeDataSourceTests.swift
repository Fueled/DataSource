//
//  MutableCompositeDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 06/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick

class MutableCompositeDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: MutableCompositeDataSource!
		var staticDataSources: [StaticDataSource<Int>]!
		var firstStaticDataSource: StaticDataSource<Int>!
		var secondStaticDataSource: StaticDataSource<Int>!
		beforeEach {
			firstStaticDataSource = StaticDataSource(sections: [DataSourceSection(items: self.testDataSet, supplementaryItems: self.supplementaryItemOfKind)])
			secondStaticDataSource = StaticDataSource(sections: [DataSourceSection(items: self.testDataSet2, supplementaryItems: self.supplementaryItemOfKind2)])
			staticDataSources = [firstStaticDataSource, secondStaticDataSource]
			dataSource = MutableCompositeDataSource(staticDataSources)
		}
		itBehavesLike("DataSource protocol") {
			["DataSource": dataSource,
			 "InitialData": [self.testDataSet, self.testDataSet2],
			 "LeafDataSource": staticDataSources,
			 "SupplementaryItems": [self.supplementaryItemOfKind, self.supplementaryItemOfKind2], ]
		}
		context("when adding new dataSource") {
			beforeEach {
				let thirdStaticDataSource = StaticDataSource(sections: [DataSourceSection(items: self.testDataSet3, supplementaryItems: self.supplementaryItemOfKind2)])
				staticDataSources = [thirdStaticDataSource, firstStaticDataSource, secondStaticDataSource]
				dataSource.insert(thirdStaticDataSource, at: staticDataSources.startIndex)
			}
			itBehavesLike("DataSource protocol") {
				["DataSource": dataSource,
				 "InitialData": [self.testDataSet3, self.testDataSet, self.testDataSet2],
				 "LeafDataSource": staticDataSources,
				 "SupplementaryItems": [self.supplementaryItemOfKind2, self.supplementaryItemOfKind, self.supplementaryItemOfKind2], ]
			}
		}
		context("when deleting a dataSource") {
			beforeEach {
				staticDataSources = [secondStaticDataSource]
				dataSource.delete(at: staticDataSources.startIndex)
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": [self.testDataSet2], "LeafDataSource": staticDataSources, "SupplementaryItems": [self.supplementaryItemOfKind2]] }
		}
		context("when replacing a dataSource") {
			beforeEach {
				let thirdStaticDataSource = StaticDataSource(sections: [DataSourceSection(items: self.testDataSet3)])
				staticDataSources = [thirdStaticDataSource, secondStaticDataSource]
				dataSource.replaceDataSource(at: staticDataSources.startIndex, with: thirdStaticDataSource)
			}
			itBehavesLike("DataSource protocol") {
				["DataSource": dataSource,
				 "InitialData": [self.testDataSet3, self.testDataSet2],
				 "LeafDataSource": staticDataSources,
				 "SupplementaryItems": [[:], self.supplementaryItemOfKind2], ]
			}
		}
		context("when moving a dataSource") {
			beforeEach {
				staticDataSources = [secondStaticDataSource, firstStaticDataSource]
				dataSource.moveData(at: staticDataSources.startIndex, to: staticDataSources.index(after: staticDataSources.startIndex))
			}
			itBehavesLike("DataSource protocol") {
				["DataSource": dataSource,
				 "InitialData": [self.testDataSet2, self.testDataSet],
				 "LeafDataSource": staticDataSources,
				 "SupplementaryItems": [self.supplementaryItemOfKind2, self.supplementaryItemOfKind], ]
			}
		}
	}
}
