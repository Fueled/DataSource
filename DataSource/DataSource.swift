//
//  DataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift

/// A provider of items grouped into sections.
/// Each section can optionally have a collection
/// of supplementary items identified by arbitrary strings called kinds.
///
/// A dataSource can be mutable, i.e. change the number and/or contents of its sections.
/// Immediately after any such change, a dataSource emits a dataChange value representing
/// that change via its `changes` property.
public protocol DataSource {

	/// A push-driven stream of values that represent every modification
	/// of the dataSource contents immediately after they happen.
	var changes: Signal<DataChange, Never> { get }

	var numberOfSections: Int { get }

	func numberOfItemsInSection(_ section: Int) -> Int

	func supplementaryItemOfKind(_ kind: String, inSection section: Int) -> Any?

	func item(at indexPath: IndexPath) -> Any

	/// Asks the dataSource for the original dataSource that contains the item at the given indexPath,
	/// and the indexPath of that item in that dataSource.
	///
	/// If the receiving dataSource is composed of other dataSources that provide its items,
	/// this method finds the dataSource responsible for providing an item for the given indexPath,
	/// and this method is called on it recursively.
	///
	/// Otherwise, this method simply returns the receiving dataSource itself and the given indexPath unchanged.
	func leafDataSource(at indexPath: IndexPath) -> (DataSource, IndexPath)

}
