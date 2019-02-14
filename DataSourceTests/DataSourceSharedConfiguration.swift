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
import CoreData

class DataSourceSharedConfiguration: QuickConfiguration {
	override class func configure(_ configuration: Configuration) {
		sharedExamples("DataSource protocol") { (sharedExampleContext: @escaping SharedExampleContext) in
			describe("Datasource protocol") {
				var dataSource: DataSource!
				var initialData: [[Int]]!
				var leafDataSource: [DataSource]!
				var supplementrayItems: [[String: Int]]!
				beforeEach {
					//Avoiding swift bug https://bugs.swift.org/browse/SR-3871
					dataSource = (sharedExampleContext()["DataSource"] as AnyObject as? DataSource)
					initialData = sharedExampleContext()["InitialData"] as? [[Int]]
					leafDataSource = sharedExampleContext()["LeafDataSource"] as? [DataSource] ?? [dataSource]
					supplementrayItems = sharedExampleContext()["SupplementaryItems"] as? [[String: Int]] ?? [[:]]
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
							let dataSourceItem: Int
							if let itemAsManagedObject = (dataSource.item(at: IndexPath(item: itemIndex, section: sectionIndex)) as? NSManagedObject) {
								dataSourceItem = Int((itemAsManagedObject.value(forKey: "id") as! String))!
							} else if let itemAsAnyObject = (dataSource.item(at: IndexPath(item: itemIndex, section: sectionIndex)) as? Int) {
								dataSourceItem = itemAsAnyObject
							} else {
								fatalError("DataSource item should be of expected type")
							}
							expect(dataSourceItem) == element
						}
					}
				}
				it("leafDataSource equal to proper dataSource") {
					for (index, element) in leafDataSource.enumerated() {
						expect(dataSource.leafDataSource(at: IndexPath(item: 0, section: index)).0) === element
					}
				}
				it("has correct supplementary items") {
					for (sectionIndex, sectionSupplementaryItems) in supplementrayItems.enumerated() {
						sectionSupplementaryItems.forEach {
							expect(dataSource.supplementaryItemOfKind($0.key, inSection: sectionIndex) as? Int) == $0.value
						}
					}
				}
			}
		}
	}
}
