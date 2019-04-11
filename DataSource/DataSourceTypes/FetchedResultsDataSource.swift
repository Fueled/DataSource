//
//  FetchedResultsDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import Ry
import CoreData
import UIKit

/// `DataSource` implementation whose items are Core Data managed objects fetched by an `NSFetchedResultsController`.
///
/// Returns names of fetched sections as supplementary items of `UICollectionElementKindSectionHeader` kind.
///
/// Uses `NSFetchedResultsControllerDelegate` protocol internally to observe changes
/// in fetched objects and emit them as its own dataChanges.
public final class FetchedResultsDataSource: DataSource {

	public let changes: Signal<DataChange>

	private let frc: NSFetchedResultsController<NSFetchRequestResult>
	private let frcDelegate = Delegate()

	public init(
		fetchRequest: NSFetchRequest<NSFetchRequestResult>,
		managedObjectContext: NSManagedObjectContext,
		sectionNameKeyPath: String? = nil,
		cacheName: String? = nil) throws
	{
		frc = NSFetchedResultsController(
			fetchRequest: fetchRequest,
			managedObjectContext: managedObjectContext,
			sectionNameKeyPath: sectionNameKeyPath,
			cacheName: cacheName
		)
		frc.delegate = frcDelegate
		changes = frcDelegate.changes

		try frc.performFetch()
	}

	deinit {
		frc.delegate = nil
	}

	private func infoForSection(_ section: Int) -> NSFetchedResultsSectionInfo {
		return frc.sections![section]
	}

	public var numberOfSections: Int {
		return frc.sections?.count ?? 0
	}

	public func numberOfItemsInSection(_ section: Int) -> Int {
		let sectionInfo = infoForSection(section)
		return sectionInfo.numberOfObjects
	}

	public func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any? {
		if kind != UICollectionView.elementKindSectionHeader {
			return nil
		}
		let sectionInfo = infoForSection(section)
		return sectionInfo.name
	}

	public func item(at indexPath: IndexPath) -> Any {
		let sectionInfo = infoForSection(indexPath.section)
		return sectionInfo.objects![indexPath.item]
	}

	public func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath) {
		return (self, indexPath)
	}

	@objc private final class Delegate: NSObject, NSFetchedResultsControllerDelegate {

		private let changesPipe = SignalPipe<DataChange>()
		var changes: Signal<DataChange> {
			return changesPipe.signal
		}
		var currentBatch: [DataChange] = []

		@objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			currentBatch = []
		}

		@objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			changesPipe.send(DataChangeBatch(currentBatch))
			currentBatch = []
		}

		@objc func controller(
			_ controller: NSFetchedResultsController<NSFetchRequestResult>,
			didChange sectionInfo: NSFetchedResultsSectionInfo,
			atSectionIndex sectionIndex: Int,
			for type: NSFetchedResultsChangeType)
		{
			switch type {
			case .insert:
				currentBatch.append(DataChangeInsertSections([sectionIndex]))
			case .delete:
				currentBatch.append(DataChangeDeleteSections([sectionIndex]))
			default:
				break
			}
		}

		@objc func controller(
			_ controller: NSFetchedResultsController<NSFetchRequestResult>,
			didChange anObject: Any,
			at indexPath: IndexPath?,
			for type: NSFetchedResultsChangeType,
			newIndexPath: IndexPath?)
		{
			switch type {
			case .insert:
				currentBatch.append(DataChangeInsertItems(newIndexPath!))
			case .delete:
				currentBatch.append(DataChangeDeleteItems(indexPath!))
			case .move:
				currentBatch.append(DataChangeMoveItem(from: indexPath!, to: newIndexPath!))
			case .update:
				currentBatch.append(DataChangeReloadItems(indexPath!))
			@unknown default:
				assertionFailure("Unknown change in FetchedResultsDataSource")
			}
		}

	}

}
