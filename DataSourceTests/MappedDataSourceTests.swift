//
//  MappedDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 05/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import UIKit
import XCTest
import DataSource
import ReactiveSwift
import Quick
import Nimble

class MappedDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: MappedDataSource!
		var staticDataSource: StaticDataSource<Int>!
		beforeEach {
			let dataSourceSection = [DataSourceSection(items: self.testDataSet, supplementaryItems: self.supplementaryItemOfKind)]
			staticDataSource = StaticDataSource(sections: dataSourceSection)
			dataSource = MappedDataSource(staticDataSource, supplementaryTransform: { ($1 as! Int) * 3 }, transform: { ($0 as! Int) * 2 })
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": [self.testDataSet.map { $0 * 2 }], "LeafDataSource": [staticDataSource], "SupplementaryItems": self.supplementaryItemOfKind.map { $1 * 3 }] }
	}
}
