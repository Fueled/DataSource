//
//  TableViewDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveSwift
import UIKit

/// An object that implements `UITableViewDataSource` protocol
/// by returning the data from an associated dataSource.
///
/// The number of section and numbers of rows in sections
/// are taken directly from the dataSource.
///
/// The cells are dequeued from a tableView
/// by reuseIdentifiers returned by `reuseIdentifierForItem` function.
///
/// If a cell implements the `DataSourceItemReceiver` protocol
/// (e.g. by subclassing the `TableViewCell` class),
/// the item at the indexPath is passed to it via `ds_setItem` method.
///
/// A tableViewDataSource observes changes of the associated dataSource
/// and applies those changes to the associated tableView.
open class TableViewDataSource: NSObject, UITableViewDataSource {
	// swiftlint:disable private_outlet
	@IBOutlet public final var tableView: UITableView?

	public final let dataSource = ProxyDataSource()

	public final var reuseIdentifierForItem: (IndexPath, Any) -> String = {
		_, _ in "DefaultCell"
	}

	public final var dataChangeTarget: DataChangeTarget?

	private let disposable = CompositeDisposable()

	override public init() {
		super.init()
		self.disposable += self.dataSource.changes.observeValues { [weak self] change in
			if let self = self, let dataChangeTarget = self.dataChangeTarget ?? self.tableView {
				change.apply(to: dataChangeTarget)
			}
		}
	}

	deinit {
		self.disposable.dispose()
	}

	open func configureCell(_ cell: UITableViewCell, forRowAt indexPath: IndexPath) {
		let item = self.dataSource.item(at: indexPath)
		configureReceiver(cell, withItem: item)
	}

	open func configureCellForRow(at indexPath: IndexPath) {
		if let cell = self.tableView?.cellForRow(at: indexPath) {
			self.configureCell(cell, forRowAt: indexPath)
		}
	}

	open func configureVisibleCells() {
		if let indexPaths = self.tableView?.indexPathsForVisibleRows {
			for indexPath in indexPaths {
				self.configureCellForRow(at: indexPath)
			}
		}
	}

	open func numberOfSections(in tableView: UITableView) -> Int {
		return self.dataSource.numberOfSections
	}

	open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource.numberOfItemsInSection(section)
	}

	open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let item: Any = self.dataSource.item(at: indexPath)
		let reuseIdentifier = self.reuseIdentifierForItem(indexPath, item)
		let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath)
		self.configureCell(cell, forRowAt: indexPath)
		return cell
	}

}
