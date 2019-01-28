//
//  TableViewDataSourceWithHeaderFooterTitles.swift
//  DataSource
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
open class TableViewDataSourceWithHeaderFooterTitles: TableViewDataSource {

	open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
		let item = self.dataSource.supplementaryItemOfKind(UICollectionView.elementKindSectionHeader, inSection: section)
		return item as? String
	}

	open func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
		let item = self.dataSource.supplementaryItemOfKind(UICollectionView.elementKindSectionFooter, inSection: section)
		return item as? String
	}

}
