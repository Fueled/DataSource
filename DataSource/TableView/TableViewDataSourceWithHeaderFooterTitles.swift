//
//  TableViewDataSourceWithHeaderFooterTitles.swift
//  YouHue
//
//  Created by Vadim Yelagin on 14/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import UIKit

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
