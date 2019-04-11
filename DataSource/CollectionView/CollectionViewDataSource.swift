//
//  CollectionViewDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 10/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import UIKit
import Ry

/// An object that implements `UICollectionViewDataSource` protocol
/// by returning the data from an associated dataSource.
///
/// The number of section and numbers of items in sections
/// are taken directly from the dataSource.
///
/// The cells are dequeued from a collectionView
/// by reuseIdentifiers returned by `reuseIdentifierForItem` function.
///
/// Supplementary views are dequeued from a collectionView by reuseIdentifiers
/// returned by `reuseIdentifierForSupplementaryItem` function.
///
/// If a cell or reusableView implements the `DataSourceItemReceiver` protocol
/// (e.g. by subclassing the `CollectionViewCell` or `CollectionViewReusableView` class),
/// the item at the indexPath is passed to it via `ds_setItem` method.
///
/// A collectionViewDataSource observes changes of the associated dataSource
/// and applies those changes to the associated collectionView.
open class CollectionViewDataSource: NSObject, UICollectionViewDataSource {

	@IBOutlet public final var collectionView: UICollectionView?

	public final let dataSource = ProxyDataSource()

	public final var reuseIdentifierForItem: (IndexPath, Any) -> String = {
		_, _ in "DefaultCell"
	}

	public final var reuseIdentifierForSupplementaryItem: (String, Int, Any) -> String = {
		_, _, _ in "DefaultSupplementaryView"
	}

	public final var dataChangeTarget: DataChangeTarget? = nil

	private let pool = DisposePool()

	public override init() {
		super.init()
		dataSource.changes.addObserver {
			[weak self] change in
			if let self = self, let dataChangeTarget = self.dataChangeTarget ?? self.collectionView {
				change.apply(to: dataChangeTarget)
			}
		}.dispose(in: pool)
	}

	open func configureCell(_ cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		let item = dataSource.item(at: indexPath)
		configureReceiver(cell, withItem: item)
	}

	open func configureCellForItem(at indexPath: IndexPath) {
		if let cell = collectionView?.cellForItem(at: indexPath) {
			configureCell(cell, forItemAt: indexPath)
		}
	}

	open func configureVisibleCells() {
		if let indexPaths = collectionView?.indexPathsForVisibleItems {
			for indexPath in indexPaths {
				configureCellForItem(at: indexPath)
			}
		}
	}

	open func numberOfSections(in collectionView: UICollectionView) -> Int {
		return dataSource.numberOfSections
	}

	open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return dataSource.numberOfItemsInSection(section)
	}

	open func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
		let section = indexPath.section
		guard let item = dataSource.supplementaryItemOfKind(kind, inSection: section) else {
			fatalError("Expected item for collection view supplementary item of kind \(kind) in section \(section), but found nil")
		}
		let reuseIdentifier = reuseIdentifierForSupplementaryItem(kind, section, item)
		let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: reuseIdentifier, for: indexPath)
		configureReceiver(view, withItem: item)
		return view
	}

	open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		let item: Any = dataSource.item(at: indexPath)
		let reuseIdentifier = reuseIdentifierForItem(indexPath, item)
		let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
		configureCell(cell, forItemAt: indexPath)
		return cell
	}

}
