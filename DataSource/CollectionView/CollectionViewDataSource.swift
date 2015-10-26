//
//  CollectionViewDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 10/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

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
public class CollectionViewDataSource: NSObject, UICollectionViewDataSource {

	@IBOutlet public final var collectionView: UICollectionView?

	public final let dataSource = ProxyDataSource()

	public final var reuseIdentifierForItem: (NSIndexPath, Any) -> String = {
		_ in "DefaultCell"
	}

	public final var reuseIdentifierForSupplementaryItem: (String, Int, Any) -> String = {
		_ in "DefaultSupplementaryView"
	}

	private let disposable = CompositeDisposable()

	public override init() {
		super.init()
		self.disposable += self.dataSource.changes.observeNext {
			[weak self] change in
			if let collectionView = self?.collectionView {
				change.apply(collectionView)
			}
		}
	}

	deinit {
		self.disposable.dispose()
	}

	public func configureCell(cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
		let item = self.dataSource.itemAtIndexPath(indexPath)
		configureReceiver(cell, withItem: item)
	}

	public func configureCellForItemAtIndexPath(indexPath: NSIndexPath) {
		if let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) {
			self.configureCell(cell, forItemAtIndexPath: indexPath)
		}
	}

	public func configureVisibleCells() {
		if let indexPaths = self.collectionView?.indexPathsForVisibleItems() {
			for indexPath in indexPaths {
				self.configureCellForItemAtIndexPath(indexPath)
			}
		}
	}

	public func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
		return self.dataSource.numberOfSections
	}

	public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
		return self.dataSource.numberOfItemsInSection(section)
	}

	public func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
		let section = indexPath.section
		guard let item = self.dataSource.supplementaryItemOfKind(kind, inSection: section) else {
			fatalError("Expected item for collection view supplementary item of kind \(kind) in section \(section), but found nil")
		}
		let reuseIdentifier = self.reuseIdentifierForSupplementaryItem(kind, section, item)
		let view = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: reuseIdentifier, forIndexPath: indexPath)
		configureReceiver(view, withItem: item)
		return view
	}

	public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		let item: Any = self.dataSource.itemAtIndexPath(indexPath)
		let reuseIdentifier = self.reuseIdentifierForItem(indexPath, item)
		let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath)
		self.configureCell(cell, forItemAtIndexPath: indexPath)
		return cell
	}

}
