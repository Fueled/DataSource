//
//  StaticDataSource.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 04/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import UIKit
import XCTest
import DataSource
import ReactiveSwift
import Quick
import Nimble

class StaticDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: StaticDataSource<Int>!
		beforeEach {
			let dataSourceSection = [DataSourceSection(items: self.testDataSet, supplementaryItems: self.supplementaryItemOfKind)]
			dataSource = StaticDataSource(sections: dataSourceSection)
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": self.testDataSet, "SupplementaryItems": self.supplementaryItemOfKind] }
		context("StaticDataSource with multiple sections") {
			beforeEach {
				let dataSourceSection1 = DataSourceSection(items: self.testDataSet)
				let dataSourceSection2 = DataSourceSection(items: self.testDataSet2)
				dataSource = StaticDataSource(sections: [dataSourceSection1, dataSourceSection2])
			}
			it("has two sections") {
				expect(dataSource.numberOfSections) == 2
			}
			it("has correct number of items in both sections") {
				expect(dataSource.numberOfItemsInSection(0)) == self.testDataSet.count
				expect(dataSource.numberOfItemsInSection(1)) == self.testDataSet2.count
			}
			it("values correspond to the original") {
				self.compareDataSourceToArray(array: self.testDataSet, dataSource: dataSource, section: 0)
				self.compareDataSourceToArray(array: self.testDataSet2, dataSource: dataSource, section: 1)
			}
			it("leafDataSource equal to self") {
				expect(dataSource.leafDataSource(at: IndexPath(item: 0, section: 0)).0) === dataSource
				expect(dataSource.leafDataSource(at: IndexPath(item: 0, section: 1)).0) === dataSource
			}
		}
	}
}
