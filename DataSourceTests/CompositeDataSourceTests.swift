//
//  CompositeDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 06/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import UIKit
import XCTest
import DataSource
import ReactiveSwift
import Quick
import Nimble

class CompositeDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: CompositeDataSource!
		var staticDataSources: [StaticDataSource<Int>]!
		beforeEach {
			let firstStaticDataSource = StaticDataSource(sections: [DataSourceSection(items: self.testDataSet, supplementaryItems: self.supplementaryItemOfKind)])
			let secondStaticDataSource = StaticDataSource(sections: [DataSourceSection(items: self.testDataSet2)])
			staticDataSources = [firstStaticDataSource, secondStaticDataSource]
			dataSource = CompositeDataSource(staticDataSources)
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": [self.testDataSet, self.testDataSet2], "LeafDataSource": staticDataSources, "SupplementaryItems": [self.supplementaryItemOfKind]] }
	}
}
