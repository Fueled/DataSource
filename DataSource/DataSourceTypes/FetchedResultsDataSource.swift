//
//  FetchedResultsDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift
import Result
import CoreData
import UIKit

/// `DataSource` implementation whose items are Core Data managed objects fetched by an `NSFetchedResultsController`.
///
/// Returns names of fetched sections as supplementary items of `UICollectionElementKindSectionHeader` kind.
///
/// Uses `NSFetchedResultsControllerDelegate` protocol internally to observe changes
/// in fetched objects and emit them as its own dataChanges.
public final class FetchedResultsDataSource: DataSource {

	public let changes: Signal<DataChange, NoError>
	fileprivate let observer: Signal<DataChange, NoError>.Observer

	fileprivate let frc: NSFetchedResultsController<NSFetchRequestResult>
	fileprivate let frcDelegate: Delegate

	public init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: NSManagedObjectContext, sectionNameKeyPath: String? = nil, cacheName: String? = nil) throws {
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
		self.frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
		self.frcDelegate = Delegate(observer: self.observer)
		self.frc.delegate = self.frcDelegate

		try self.frc.performFetch()
	}

	deinit {
		self.frc.delegate = nil
		self.observer.sendCompleted()
	}

	fileprivate func infoForSection(_ section: Int) -> NSFetchedResultsSectionInfo {
		return self.frc.sections![section]
	}

	public var numberOfSections: Int {
		return self.frc.sections?.count ?? 0
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		let sectionInfo = self.infoForSection(section)
		return sectionInfo.numberOfObjects
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		if kind != UICollectionView.elementKindSectionHeader {
			return nil
		}
		let sectionInfo = self.infoForSection(section)
		return sectionInfo.name
	}

	public func item(at indexPath: IndexPath) -> Any {
		let sectionInfo = self.infoForSection((indexPath as NSIndexPath).section)
		return sectionInfo.objects![(indexPath as NSIndexPath).item]
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		return (self, indexPath)
	}

	@objc fileprivate final class Delegate: NSObject, NSFetchedResultsControllerDelegate {

		let observer: Signal<DataChange, NoError>.Observer
		var currentBatch: [DataChange] = []

		init(observer: Signal<DataChange, NoError>.Observer) {
			self.observer = observer
		}

		@objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			self.currentBatch = []
		}

		@objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			self.observer.send(value: DataChangeBatch(self.currentBatch))
			self.currentBatch = []
		}

		@objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
			didChange sectionInfo: NSFetchedResultsSectionInfo,
			atSectionIndex sectionIndex: Int,
			for type: NSFetchedResultsChangeType)
		{
			switch type {
			case .insert:
				self.currentBatch.append(DataChangeInsertSections([sectionIndex]))
			case .delete:
				self.currentBatch.append(DataChangeDeleteSections([sectionIndex]))
			default:
				break
			}
		}

		@objc func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
			didChange anObject: Any,
			at indexPath: IndexPath?,
			for type: NSFetchedResultsChangeType,
			newIndexPath: IndexPath?)
		{
			switch type {
			case .insert:
				self.currentBatch.append(DataChangeInsertItems(newIndexPath!))
			case .delete:
				self.currentBatch.append(DataChangeDeleteItems(indexPath!))
			case .move:
				self.currentBatch.append(DataChangeMoveItem(from: indexPath!, to: newIndexPath!))
			case .update:
				self.currentBatch.append(DataChangeReloadItems(indexPath!))
			}
		}

	}

}
