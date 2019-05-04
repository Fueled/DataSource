//
//  AutoDiff.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/08/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

// swiftlint:disable convenience_type
public struct AutoDiff {

	public struct Result {

		public var matches: [(Int, Int)] = []
		public var deleted: [Int] = []
		public var inserted: [Int] = []
		public var moved: [(Int, Int)] = []

		public func toSectionChanges() -> [DataChange] {
			var changes: [DataChange] = []
			if !deleted.isEmpty {
				changes.append(DataChangeDeleteSections(deleted))
			}
			if !inserted.isEmpty {
				changes.append(DataChangeInsertSections(inserted))
			}
			for (fromSection, toSection) in moved {
				changes.append(DataChangeMoveSection(from: fromSection, to: toSection))
			}
			return changes
		}

		public func toItemChanges(oldSection: Int, newSection: Int) -> [DataChange] {
			var changes: [DataChange] = []
			if !deleted.isEmpty {
				let indexPaths = deleted.map {
					IndexPath(item: $0, section: oldSection)
				}
				changes.append(DataChangeDeleteItems(indexPaths))
			}
			if !inserted.isEmpty {
				let indexPaths = inserted.map {
					IndexPath(item: $0, section: newSection)
				}
				changes.append(DataChangeInsertItems(indexPaths))
			}
			for (fromItem, toItem) in moved {
				let fromPath = IndexPath(item: fromItem, section: oldSection)
				let toPath = IndexPath(item: toItem, section: newSection)
				changes.append(DataChangeMoveItem(from: fromPath, to: toPath))
			}
			return changes
		}

		public func toItemChanges(_ section: Int = 0) -> [DataChange] {
			return toItemChanges(oldSection: section, newSection: section)
		}

	}

	// http://en.wikipedia.org/wiki/Longest_common_subsequence_problem
	public static func compare<T>(old: [T], new: [T], findMoves: Bool, compare: (T, T) -> Bool) -> Result {
		var moves = Array(repeating: Array(repeating: LCSMove.unknown, count: new.count), count: old.count)
		var lengths = Array(repeating: Array(repeating: 0, count: new.count), count: old.count)
		func getLength(_ iOld: Int, _ iNew: Int) -> Int {
			return (iOld >= 0 && iNew >= 0) ? lengths[iOld][iNew] : 0
		}
		// fill the table
		for iOld in 0 ..< old.count {
			for iNew in 0 ..< new.count {
				var curMove: LCSMove
				var curLength: Int
				if compare(old[iOld], new[iNew]) {
					curMove = .match
					curLength = getLength(iOld - 1, iNew - 1) + 1
				} else {
					let prevOldLength = getLength(iOld - 1, iNew)
					let prevNewLength = getLength(iOld, iNew - 1)
					if prevOldLength > prevNewLength {
						curMove = .fromPrevOld
						curLength = prevOldLength
					} else {
						curMove = .fromPrevNew
						curLength = prevNewLength
					}
				}
				moves[iOld][iNew] = curMove
				lengths[iOld][iNew] = curLength
			}
		}
		// collect longest sequence of matches from filled table
		var result = Result()
		var iOld = old.count - 1
		var iNew = new.count - 1
		while iOld >= 0 && iNew >= 0 {
			switch moves[iOld][iNew] {
			case .fromPrevOld:
				result.deleted.append(iOld)
				iOld -= 1
			case .fromPrevNew:
				result.inserted.append(iNew)
				iNew -= 1
			default:
				let pair = (iOld, iNew)
				result.matches.append(pair)
				iOld -= 1
				iNew -= 1
			}
		}
		while iOld >= 0 {
			result.deleted.append(iOld)
			iOld -= 1
		}
		while iNew >= 0 {
			result.inserted.append(iNew)
			iNew -= 1
		}
		if !findMoves {
			return result
		}
		// replace delete & insert of equal elements with a move
		var inserted2: [Int] = []
		for iNew in result.inserted {
			let newItem = new[iNew]
			if let (j, iOld) = findFirst(result.deleted, { compare(old[$0], newItem) }) {
				result.deleted.remove(at: j)
				result.moved.append((iOld, iNew))
			} else {
				inserted2.append(iNew)
			}
		}
		result.inserted = inserted2
		return result
	}

	private enum LCSMove {
		case unknown
		case fromPrevOld
		case fromPrevNew
		case match
	}

}

private func findFirst<S: Sequence>
	(_ source: S, _ predicate: (S.Iterator.Element) -> Bool)
	-> (Int, S.Iterator.Element)?
{
	for (idx, s) in source.enumerated() {
		if predicate(s) {
			return (idx, s)
		}
	}
	return nil
}
