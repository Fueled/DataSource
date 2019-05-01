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
import ReactiveSwift

class CollectionViewDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var collectionViewDataSource: CollectionViewDataSource!
		var collectionView: UICollectionView!
		beforeEach {
			let dataSource = Property(value: StaticDataSource(items: self.dataSetWithTestCellModels))
			collectionViewDataSource = CollectionViewDataSource()
			collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
			let collectionViewDescriptors = [CellDescriptor(TestCollectionViewCell.reuseIdentifier, TestCellModel.self, .class(TestCollectionViewCell.self))]
			collectionViewDataSource.configure(collectionView, using: collectionViewDescriptors)
			collectionViewDataSource.dataSource.innerDataSource <~ dataSource.producer.map { $0 as DataSource }
		}
		itBehavesLike("CollectionViewDataSource object") { ["collectionViewDataSource": collectionViewDataSource!, "TestCellModels": [self.dataSetWithTestCellModels], "collectionView": collectionView!] }
	}
}
