//
//  DataSource.swift
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

class DataSourceSharedConfiguration: QuickConfiguration {
	override class func configure(_ configuration: Configuration) {
		sharedExamples("DataSource protocol") { (sharedExampleContext: @escaping SharedExampleContext) in
			describe("Datasource protocol") {
				var dataSource: DataSource!
				var initialData: [Int]!
				var leafDataSource: DataSource?
				var supplementrayItems: [String: Int]!
				beforeEach {
					//Avoiding swift bug https://bugs.swift.org/browse/SR-3871
					dataSource = (sharedExampleContext()["DataSource"] as AnyObject as? DataSource)
					initialData = sharedExampleContext()["InitialData"] as? [Int]
					leafDataSource = sharedExampleContext()["LeafDataSource"] as AnyObject as? DataSource
					supplementrayItems = sharedExampleContext()["SupplementaryItems"] as? [String: Int] ?? [:]
				}
				it("has correct number of items in section") {
					expect(dataSource.numberOfItemsInSection(0)) == initialData.count
				}
				it("has correct number of section") {
					expect(dataSource.numberOfSections) == 1
				}
				it("all items are the same as in input data") {
					for (index, element) in initialData.enumerated() {
						expect(dataSource.item(at: IndexPath(item: index, section: 0)) as? Int) == element
					}
				}
				it("leafDataSource equal to proper dataSource") {
					expect(dataSource.leafDataSource(at: IndexPath(item: 0, section: 0)).0) === leafDataSource ?? dataSource
				}
				it("has correct supplementary item") {
					for (itemKey, itemValue) in supplementrayItems {
						expect(dataSource.supplementaryItemOfKind(itemKey, inSection: 0) as? Int) == itemValue
					}
				}
			}
		}
	}
}
