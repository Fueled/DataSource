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
				var initialData: [[Int]]!
				var leafDataSource: [DataSource]?
				var supplementrayItems: [String: Int]!
				beforeEach {
					//Avoiding swift bug https://bugs.swift.org/browse/SR-3871
					dataSource = (sharedExampleContext()["DataSource"] as AnyObject as? DataSource)
					initialData = sharedExampleContext()["InitialData"] as? [[Int]]
					leafDataSource = sharedExampleContext()["LeafDataSource"] as? [DataSource]
					supplementrayItems = sharedExampleContext()["SupplementaryItems"] as? [String: Int] ?? [:]
				}
				it("has correct number of items in sections") {
					for (index, _) in initialData.enumerated() {
						expect(dataSource.numberOfItemsInSection(index)) == initialData[index].count
					}
				}
				it("has correct number of section") {
					expect(dataSource.numberOfSections) == initialData.count
				}
				it("all items are the same as in input data") {
					for (sectionIndex, element) in initialData.enumerated() {
						for (itemIndex, element) in element.enumerated() {
							expect(dataSource.item(at: IndexPath(item: itemIndex, section: sectionIndex)) as? Int) == element
						}
					}
				}
				it("leafDataSource equal to proper dataSource") {
					for (sectionIndex, element) in initialData.enumerated() {
						for (itemIndex, _) in element.enumerated() {
							expect(dataSource.leafDataSource(at: IndexPath(item: itemIndex, section: sectionIndex)).0) === leafDataSource?[sectionIndex] ?? dataSource
						}
					}
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
