//
//  CollectionViewChangeTarget.swift
//  DataSource
//
//  Created by Vadim Yelagin on 10/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import UIKit

public class CollectionViewChangeTarget: DataChangeTarget {
	
	private let collectionView: UICollectionView
	
	init(collectionView: UICollectionView) {
		self.collectionView = collectionView
	}

	public func ds_performBatchChanges(_ batchChanges: @escaping () -> ()) {
		self.collectionView.performBatchUpdates(batchChanges, completion: nil)
	}

	public func ds_deleteItems(at indexPaths: [IndexPath]) {
		self.collectionView.deleteItems(at: indexPaths)
	}

	public func ds_deleteSections(_ sections: [Int]) {
		self.collectionView.deleteSections(IndexSet(ds_integers: sections))
	}

	public func ds_insertItems(at indexPaths: [IndexPath]) {
		self.collectionView.insertItems(at: indexPaths)
	}

	public func ds_insertSections(_ sections: [Int]) {
		self.collectionView.insertSections(IndexSet(ds_integers: sections))
	}

	public func ds_moveItem(at oldIndexPath: IndexPath, to newIndexPath: IndexPath) {
		self.collectionView.moveItem(at: oldIndexPath, to: newIndexPath)
	}

	public func ds_moveSection(_ oldSection: Int, toSection newSection: Int) {
		self.collectionView.moveSection(oldSection, toSection: newSection)
	}

	public func ds_reloadData() {
		self.collectionView.reloadData()
	}

	public func ds_reloadItems(at indexPaths: [IndexPath]) {
		self.collectionView.reloadItems(at: indexPaths)
	}

	public func ds_reloadSections(_ sections: [Int]) {
		self.collectionView.reloadSections(IndexSet(ds_integers: sections))
	}

}
