//
//  CollectionViewDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 06/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import DataSource
import Nimble
import Quick
import Combine

class CollectionViewDataSourceTests: QuickSpecWithDataSets {
	var collectionViewDataSource: CollectionViewDataSource!
	var cancellable: AnyCancellable?

	override func spec() {
		var collectionView: UICollectionView!
		beforeEach {
			let dataSource = CurrentValueSubject<StaticDataSource, Never>(
				StaticDataSource(
					items: self.dataSetWithTestCellModels
				)
			)
			self.collectionViewDataSource = CollectionViewDataSource()
			collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
			let collectionViewDescriptors = [CellDescriptor(TestCollectionViewCell.reuseIdentifier, TestCellModel.self, .class(TestCollectionViewCell.self))]
			self.collectionViewDataSource.configure(collectionView, using: collectionViewDescriptors)
			self.cancellable = dataSource
				.map { $0 as DataSource }
				.assign(to: \.dataSource.innerDataSource, on: self.collectionViewDataSource)
		}
		itBehavesLike("CollectionViewDataSource object") {
			[
				"collectionViewDataSource": self.collectionViewDataSource!,
				"TestCellModels": [self.dataSetWithTestCellModels],
				"collectionView": collectionView!
			]
		}
	}
}
