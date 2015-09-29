//
//  TableViewDataSourceWithHeaderFooterTitles.swift
//  YouHue
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import UIKit

/// A `TableViewDataSource` subclass that additionally provides
/// titles for headers and footers of tableView sections.
///
/// DataSource supplementary items of `UICollectionElementKindSectionHeader` kind
/// are used as section header titles, provided they are of `String` type.
///
/// DataSource supplementary items of `UICollectionElementKindSectionFooter` kind
/// are used as section footer titles, provided they are of `String` type.
public class TableViewDataSourceWithHeaderFooterTitles: TableViewDataSource {

	public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let item = self.dataSource.supplementaryItemOfKind(UICollectionElementKindSectionHeader, inSection: section)
		return item as? String
	}

	public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		let item = self.dataSource.supplementaryItemOfKind(UICollectionElementKindSectionFooter, inSection: section)
		return item as? String
	}

}
