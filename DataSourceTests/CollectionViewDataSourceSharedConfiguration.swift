//
//  CollectionViewDataSourceSharedConfiguration.swift
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

class CollectionViewDataSourceSharedConfiguration: QuickConfiguration {
	override class func configure(_ configuration: Configuration) {
		sharedExamples("CollectionViewDataSource object") { (sharedExampleContext: @escaping SharedExampleContext) in
			describe("CollectionView tests") {
				var collectionViewDataSource: CollectionViewDataSource!
				var initialData: [[TestCellModel]]!
				var collectionView: UICollectionView!
				beforeEach {
					collectionViewDataSource = sharedExampleContext()["collectionViewDataSource"] as? CollectionViewDataSource
					initialData = sharedExampleContext()["TestCellModels"] as? [[TestCellModel]]
					collectionView = sharedExampleContext()["collectionView"] as? UICollectionView
				}
				it("configure visible cells") {
					collectionViewDataSource.configureVisibleCells()
				}
				it("has correct number of section") {
					expect(collectionViewDataSource.numberOfSections(in: collectionView)) == initialData.count
				}
				it("has proper count of items") {
					for (index, _) in initialData.enumerated() {
						expect(collectionViewDataSource.collectionView(collectionView, numberOfItemsInSection: index)) == initialData[index].count
					}
				}
				it("cells has correct type") {
					for (sectionIndex, element) in initialData.enumerated() {
						for (itemIndex, _) in element.enumerated() {
							expect(collectionViewDataSource.collectionView(collectionView, cellForItemAt: IndexPath(item: itemIndex, section: sectionIndex))).notTo(beNil())
						}
					}
				}
			}
		}
	}
}
