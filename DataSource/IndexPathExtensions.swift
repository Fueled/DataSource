//
//  IndexPathExtensions.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public extension IndexPath {

	func ds_setSection(_ section: Int) -> IndexPath {
		return IndexPath(item: self.item, section: section)
	}

	func ds_mapSection(_ transform: (Int) -> Int) -> IndexPath {
		return IndexPath(item: self.item, section: transform(self.section))
	}

}

public extension IndexSet {

	init<S: Sequence>(ds_integers: S) where S.Iterator.Element == Int {
		var res = IndexSet()
		for i in ds_integers {
			res.insert(i)
		}
		self.init(res)
	}

}
