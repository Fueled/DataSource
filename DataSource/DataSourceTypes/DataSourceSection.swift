//
//  DataSourceSection.swift
//  DataSource
//
//  Created by Vadim Yelagin on 04/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct DataSourceSection<T> {

	public var items: [T]
	public var supplementaryItems: [String: Any]

	public init(items: [T], supplementaryItems: [String: Any] = [:]) {
		self.items = items
		self.supplementaryItems = supplementaryItems
	}

}
