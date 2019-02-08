//
//  TableViewDataSourceWithHeaderFooterViews.swift
//  DataSource
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
open class TableViewDataSourceWithHeaderFooterViews: TableViewDataSource, UITableViewDelegate {

	public final var reuseIdentifierForHeaderItem: (Int, Any) -> String = {
		_, _ in "DefaultHeaderView"
	}
	public final var reuseIdentifierForFooterItem: (Int, Any) -> String = {
		_, _ in "DefaultFooterView"
	}

	open func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
		guard let item = self.dataSource.supplementaryItemOfKind(UICollectionView.elementKindSectionHeader, inSection: section) else {
			return nil
		}
		let reuseIdentifier = self.reuseIdentifierForHeaderItem(section, item)
		let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)!
		configureReceiver(view, withItem: item)
		return view
	}

	open func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
		guard let item = self.dataSource.supplementaryItemOfKind(UICollectionView.elementKindSectionFooter, inSection: section) else {
			return nil
		}
		let reuseIdentifier = self.reuseIdentifierForFooterItem(section, item)
		let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: reuseIdentifier)!
		configureReceiver(view, withItem: item)
		return view
	}

}
