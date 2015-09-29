//
//  TableViewDataSourceWithHeaderFooterViews.swift
//  YouHue
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import UIKit

/// A `TableViewDataSource` subclass that additionally provides
/// views for headers and footers of tableView sections.
///
/// `TableViewDataSourceWithHeaderFooterViews` needs to be the tableView's delegate.
///
/// Header and footer views are dequeued from a tableView
/// by reuseIdentifiers returned by `reuseIdentifierForHeaderItem`
/// and `reuseIdentifierForFooterItem` function.
///
/// DataSource supplementary items of `UICollectionElementKindSectionHeader` kind
/// are used as section header titles.
///
/// DataSource supplementary items of `UICollectionElementKindSectionFooter` kind
/// are used as section footer titles.
public class TableViewDataSourceWithHeaderFooterViews: TableViewDataSource, UITableViewDelegate {

	public final var reuseIdentifierForHeaderItem: (Int, Any?) -> String = {
		_ in "DefaultHeaderView"
	}
	public final var reuseIdentifierForFooterItem: (Int, Any?) -> String = {
		_ in "DefaultFooterView"
	}

	public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		let item = self.dataSource.supplementaryItemOfKind(UICollectionElementKindSectionHeader, inSection: section)
		let reuseIdentifier = self.reuseIdentifierForHeaderItem(section, item)
		let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseIdentifier)!
		configureReceiver(view, withItem: item)
		return view
	}

	public func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		let item = self.dataSource.supplementaryItemOfKind(UICollectionElementKindSectionFooter, inSection: section)
		let reuseIdentifier = self.reuseIdentifierForFooterItem(section, item)
		let view = tableView.dequeueReusableHeaderFooterViewWithIdentifier(reuseIdentifier)!
		configureReceiver(view, withItem: item)
		return view
	}

}
