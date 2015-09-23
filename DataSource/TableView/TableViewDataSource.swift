//
//  TableViewDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import UIKit
import ReactiveCocoa

public class TableViewDataSource: NSObject, UITableViewDataSource {

	@IBOutlet public final var tableView: UITableView?

	public final let dataSource = ProxyDataSource()

	public final var reuseIdentifierForItem: (NSIndexPath, Any) -> String = {
		_ in "DefaultCell"
	}

	private let disposable = CompositeDisposable()

	public override init() {
		super.init()
		self.disposable += self.dataSource.changes.observeNext {
			[weak self] change in
			if let tableView = self?.tableView {
				change.apply(tableView)
			}
		}
	}

	deinit {
		self.disposable.dispose()
	}

	public func configureCell(cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if let itemReceiver = cell as? DataSourceItemReceiver {
			itemReceiver.setItem(self.dataSource.itemAtIndexPath(indexPath))
		}
	}

	public func configureCellForRowAtIndexPath(indexPath: NSIndexPath) {
		if let cell = self.tableView?.cellForRowAtIndexPath(indexPath) {
			self.configureCell(cell, forRowAtIndexPath: indexPath)
		}
	}

	public func configureVisibleCells() {
		if let indexPaths = self.tableView?.indexPathsForVisibleRows {
			for indexPath in indexPaths {
				self.configureCellForRowAtIndexPath(indexPath)
			}
		}
	}

	public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return self.dataSource.numberOfSections
	}

	public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return self.dataSource.numberOfItemsInSection(section)
	}

	public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let item: Any = self.dataSource.itemAtIndexPath(indexPath)
		let reuseIdentifier = self.reuseIdentifierForItem(indexPath, item)
		let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath)
		self.configureCell(cell, forRowAtIndexPath: indexPath)
		return cell
	}

}
