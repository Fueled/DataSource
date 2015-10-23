//
//  AutoDiffSectionsDataSouce.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/08/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

/// `DataSource` implementation that has an arbitrary
/// number of sections of items of type T.
///
/// Whenever the array of sections is changed, the dataSource compares
/// each pair of old and new sections via `compareSections` function,
/// and produces minimal set of dataChanges that delete and insert
/// non-matching sections. Then it compares items (via `compareItems` function)
/// within each pair of matching sections and produces minimal sets of dataChanges
/// for non-matching items within those sections.
///
/// `AutoDiffSectionsDataSouce` never generates movement of sections.
/// Items are only compared withing sections, hence movement of items
/// between sections are never found either.
///
/// When comparing sections, `AutoDiffSectionsDataSouce` does not rely
/// on the items they comprise. Instead it calls `compareSections` that
/// you provide it with. Sections are usually compared based on some
/// userData that is used to identify them. Such data can be stored in
/// sections' `supplementaryItems` dictionary under some user-defined key.
public final class AutoDiffSectionsDataSouce<T>: DataSource {

	public let changes: Signal<DataChange, NoError>
	private let observer: Signal<DataChange, NoError>.Observer
	private let disposable: Disposable

	/// Mutable array of dataSourceSections.
	///
	/// Every modification of the array causes calculation
	/// and emission of appropriate dataChanges.
	public let sections: MutableProperty<[DataSourceSection<T>]>

	/// Function that is used to compare a pair of sections for identity.
	/// Returns `true` if the sections are identical, in which case the items
	/// withing them are compared via `compareItems` function.
	/// Otherwise, the old section is deleted and the new section is inserted,
	/// together with all of their corresponding items.
	public let compareSections: (DataSourceSection<T>, DataSourceSection<T>) -> Bool

	/// Function that is used to compare a pair of items for equality.
	/// Returns `true` if the items are equal, and no dataChange is required
	/// to replace the first item with the second.
	public let compareItems: (T, T) -> Bool

	/// Creates an autoDiffSectionsDataSource.
	/// - parameters:
	///   - sections: Initial array of sections of the autoDiffDataSource.
	///   - findItemMoves: Set `findItemMoves` to `false` to make the dataSource emit
	///		a pair of deletion and insertion instead of item movement dataChanges.
	///     Section moves are never generated.
	///   - compareSections: Function that is used to compare a pair of sections for identity.
	///   - compareItems: Function that is used to compare a pair of items for equality.
	public init(sections: [DataSourceSection<T>] = [],
		findItemMoves: Bool = true,
		compareSections: (DataSourceSection<T>, DataSourceSection<T>) -> Bool,
		compareItems: (T, T) -> Bool)
	{
		(self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
		self.sections = MutableProperty(sections)
		self.compareSections = compareSections
		self.compareItems = compareItems
		func autoDiff(oldSections: [DataSourceSection<T>],
			newSections: [DataSourceSection<T>]) -> DataChange
		{
			let sectionsResult = AutoDiff.compare(
				old: oldSections,
				new: newSections,
				findMoves: false,
				compare: compareSections)
			var changes = sectionsResult.toSectionChanges()
			for (oldIndex, newIndex) in sectionsResult.matches {
				let oldItems = oldSections[oldIndex].items
				let newItems = newSections[newIndex].items
				let itemsResult = AutoDiff.compare(
					old: oldItems,
					new: newItems,
					findMoves: findItemMoves,
					compare: compareItems)
				changes += itemsResult.toItemChanges(oldSection: oldIndex, newSection: newIndex)
			}
			return DataChangeBatch(changes)
		}
		self.disposable = self.sections.producer
			.combinePrevious(sections)
			.skip(1)
			.map(autoDiff)
			.start(self.observer)
	}

	deinit {
		self.observer.sendCompleted()
		self.disposable.dispose()
	}

	public var numberOfSections: Int {
		return self.sections.value.count
	}

	public func numberOfItemsInSection(section: Int) -> Int {
		return self.sections.value[section].items.count
	}

	public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
		return self.sections.value[section].supplementaryItems[kind]
	}

	public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
		return self.sections.value[indexPath.section].items[indexPath.item]
	}

	public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
		return (self, indexPath)
	}

}
