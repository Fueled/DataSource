//
//  FetchedResultsDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import CoreData
import Foundation
import ReactiveSwift
import UIKit

/// `DataSource` implementation whose items are Core Data managed objects fetched by an `NSFetchedResultsController`.
///
/// Returns names of fetched sections as supplementary items of `UICollectionElementKindSectionHeader` kind.
///
/// Uses `NSFetchedResultsControllerDelegate` protocol internally to observe changes
/// in fetched objects and emit them as its own dataChanges.
public final class FetchedResultsDataSource: DataSource {

	public let changes: Signal<DataChange, Never>
	private let observer: Signal<DataChange, Never>.Observer

	private let frc: NSFetchedResultsController<NSFetchRequestResult>
	// swiftlint:disable weak_delegate
	private let frcDelegate: Delegate

	public init(fetchRequest: NSFetchRequest<NSFetchRequestResult>, managedObjectContext: NSManagedObjectContext, sectionNameKeyPath: String? = nil, cacheName: String? = nil) throws {
		(self.changes, self.observer) = Signal<DataChange, Never>.pipe()
		self.frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: sectionNameKeyPath, cacheName: cacheName)
		self.frcDelegate = Delegate(observer: self.observer)
		self.frc.delegate = self.frcDelegate

		try self.frc.performFetch()
	}

	deinit {
		self.frc.delegate = nil
		self.observer.sendCompleted()
	}

	private func infoForSection(_ section: Int) -> NSFetchedResultsSectionInfo {
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

	@objc private final class Delegate: NSObject, NSFetchedResultsControllerDelegate {

		let observer: Signal<DataChange, Never>.Observer
		var currentBatch: [DataChange] = []

		init(observer: Signal<DataChange, Never>.Observer) {
			self.observer = observer
		}

		@objc func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			self.currentBatch = []
		}

		@objc func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			self.observer.send(value: DataChangeBatch(self.currentBatch))
			self.currentBatch = []
		}

		@objc func controller(
			_ controller: NSFetchedResultsController<NSFetchRequestResult>,
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

		@objc func controller(
			_ controller: NSFetchedResultsController<NSFetchRequestResult>,
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
			@unknown default:
				NSLog("Unhandled case for NSFetchedResultsChangeType: \(type). DataSource should be updated to account for it or it could lead to unexpected results.")
				assertionFailure()
			}
		}

	}

}
