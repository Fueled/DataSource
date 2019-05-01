//
//  StaticDataSource.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 04/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick

class StaticDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: StaticDataSource<Int>!
		beforeEach {
			let dataSourceSection = [DataSourceSection(items: self.testDataSet, supplementaryItems: self.supplementaryItemOfKind)]
			dataSource = StaticDataSource(sections: dataSourceSection)
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSet], "SupplementaryItems": [self.supplementaryItemOfKind]] }
		context("StaticDataSource with multiple sections") {
			beforeEach {
				let dataSourceSection1 = DataSourceSection(items: self.testDataSet, supplementaryItems: self.supplementaryItemOfKind2)
				let dataSourceSection2 = DataSourceSection(items: self.testDataSet2, supplementaryItems: self.supplementaryItemOfKind)
				dataSource = StaticDataSource(sections: [dataSourceSection1, dataSourceSection2])
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource!, "InitialData": [self.testDataSet, self.testDataSet2], "SupplementaryItems": [self.supplementaryItemOfKind2, self.supplementaryItemOfKind]] }
		}
	}
}
