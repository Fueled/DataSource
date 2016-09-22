//
//  IndexPathExtensions.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public extension IndexPath {

	public func ds_setSection(_ section: Int) -> IndexPath {
		return IndexPath(item: self.item, section: section)
	}

}

func mapSection(_ transform: @escaping (Int) -> Int) -> (IndexPath) -> IndexPath {
	return { $0.ds_setSection(transform($0.section)) }
}

public extension IndexSet {

	public init<S: Sequence>(integers: S) where S.Iterator.Element == Int {
		var res = IndexSet()
		for i in integers {
			res.insert(i)
		}
		self.init(res)
	}
	
}
