//
//  ProxyDataSourceTestsNew.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 04/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.


import UIKit
import XCTest
import DataSource
import ReactiveSwift
import Quick
import Nimble

class ProxyDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: ProxyDataSource!
		var staticDataSource: StaticDataSource<Int>!
		beforeEach {
			staticDataSource = StaticDataSource(items: self.testDataSet)
			dataSource = ProxyDataSource(staticDataSource)
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": [self.testDataSet], "LeafDataSource": [staticDataSource]] }
		context("when change inner data source value") {
			beforeEach {
				staticDataSource = StaticDataSource(items: self.testDataSet2)
				dataSource.innerDataSource.value = staticDataSource
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": [self.testDataSet2], "LeafDataSource": [staticDataSource]] }
		}
	}
}
