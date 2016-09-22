//
//  DataChangeReloadData.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataChangeReloadData: DataChange {

	public init() {}

	public func apply(to target: DataChangeTarget) {
		target.ds_reloadData()
	}

	public func mapSections(_ transform: (Int) -> Int) -> DataChangeReloadData {
		return self
	}

}
