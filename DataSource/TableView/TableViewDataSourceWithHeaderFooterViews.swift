//
//  TableViewDataSourceWithHeaderFooterViews.swift
//  YouHue
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import UIKit

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
