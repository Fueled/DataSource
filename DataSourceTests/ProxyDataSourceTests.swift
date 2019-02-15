//
//  ProxyDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 04/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick

class ProxyDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: ProxyDataSource!
		var staticDataSource: StaticDataSource<Int>!
		beforeEach {
			let dataSourceSection = DataSourceSection(items: self.testDataSet, supplementaryItems: self.supplementaryItemOfKind2)
			staticDataSource = StaticDataSource(sections: [dataSourceSection])
			dataSource = ProxyDataSource(staticDataSource)
			dataSource.animatesChanges.value = true
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": [self.testDataSet], "LeafDataSource": [staticDataSource], "SupplementaryItems": [self.supplementaryItemOfKind2]] }
		context("when change inner data source value") {
			beforeEach {
				let dataSourceSection = DataSourceSection(items: self.testDataSet2, supplementaryItems: self.supplementaryItemOfKind)
				let dataSourceSection2 = DataSourceSection(items: self.testDataSet, supplementaryItems: self.supplementaryItemOfKind2)
				let dataSourceSections = [dataSourceSection, dataSourceSection2]
				staticDataSource = StaticDataSource(sections: dataSourceSections)
				dataSource.animatesChanges.value = false
				dataSource.innerDataSource.value = staticDataSource
			}
			itBehavesLike("DataSource protocol") {
				["DataSource": dataSource,
				 "InitialData": [self.testDataSet2, self.testDataSet],
				 "LeafDataSource": [staticDataSource],
				 "SupplementaryItems": [self.supplementaryItemOfKind, self.supplementaryItemOfKind2], ]
			}
		}
	}
}
