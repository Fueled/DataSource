//
//  IndexPathExtensions.swift
//  DataSource
//
//  Created by Vadim Yelagin on 09/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public extension NSIndexPath {

	public func ds_setSection(section: Int) -> NSIndexPath {
		return NSIndexPath(forItem: self.item, inSection: section)
	}

}

func mapSection(transform: Int -> Int) -> NSIndexPath -> NSIndexPath {
	return { $0.ds_setSection(transform($0.section)) }
}

public extension NSIndexSet {

	public convenience init(ds_range: Range<Int>) {
		self.init(indexesInRange: NSRange(location: ds_range.startIndex, length: ds_range.endIndex - ds_range.startIndex))
	}

	public convenience init<S: SequenceType where S.Generator.Element == Int>(ds_sequence: S) {
		let res = NSMutableIndexSet()
		for i in ds_sequence {
			res.addIndex(i)
		}
		self.init(indexSet: res)
	}

	public func ds_map(transform: Int -> Int) -> NSIndexSet {
		let res = NSMutableIndexSet()
		self.enumerateIndexesUsingBlock {
			index, _ in
			res.addIndex(transform(index))
		}
		return res
	}

}
