//
//  AutoDiff.swift
//  DataSource
//
//  Created by Vadim Yelagin on 14/08/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation

public struct AutoDiff {
    
    public struct Result {
        
        public var matches: [(Int, Int)] = []
        public var deleted: [Int] = []
        public var inserted: [Int] = []
        public var moved: [(Int, Int)] = []
        
        public func toItemChanges(#oldSection: Int, newSection: Int) -> DataChangeBatch {
            var changes: [DataChange] = []
            if !deleted.isEmpty {
                let indexPaths = deleted.map {
                    NSIndexPath(forItem: $0, inSection: oldSection)!
                }
                changes.append(DataChangeDeleteItems(indexPaths))
            }
            if !inserted.isEmpty {
                let indexPaths = inserted.map {
                    NSIndexPath(forItem: $0, inSection: newSection)!
                }
                changes.append(DataChangeInsertItems(indexPaths))
            }
            for (from, to) in moved {
                let fromPath = NSIndexPath(forItem: from, inSection: oldSection)
                let toPath = NSIndexPath(forItem: to, inSection: newSection)
                changes.append(DataChangeMoveItem(from: fromPath, to: toPath))
            }
            return DataChangeBatch(changes)
        }
        
        public func toItemChanges(section: Int = 0) -> DataChangeBatch {
            return toItemChanges(oldSection: section, newSection: section)
        }
        
    }
    
    // http://en.wikipedia.org/wiki/Longest_common_subsequence_problem
    public static func compare<T>(#old: [T], new: [T], findMoves: Bool, compare: (T, T) -> Bool) -> Result {
        var moves = Array(count: old.count, repeatedValue:
            Array(count: new.count, repeatedValue: LCSMove.Unknown))
        var lengths = Array(count: old.count, repeatedValue:
            Array(count: new.count, repeatedValue: 0))
        func getLength(iOld: Int, iNew: Int) -> Int {
            return (iOld >= 0 && iNew >= 0) ? lengths[iOld][iNew] : 0
        }
        // fill the table
        for iOld in 0 ..< old.count {
            for iNew in 0 ..< new.count {
                var curMove: LCSMove
                var curLength: Int
                if compare(old[iOld], new[iNew]) {
                    curMove = .Match
                    curLength = getLength(iOld - 1, iNew - 1) + 1
                } else {
                    let prevOldLength = getLength(iOld - 1, iNew)
                    var prevNewLength = getLength(iOld, iNew - 1)
                    if prevOldLength > prevNewLength {
                        curMove = .FromPrevOld
                        curLength = prevOldLength
                    } else {
                        curMove = .FromPrevNew
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
            case .FromPrevOld:
                result.deleted.append(iOld)
                --iOld
            case .FromPrevNew:
                result.inserted.append(iNew)
                --iNew
            default:
                let pair = (iOld, iNew)
                result.matches.append(pair)
                --iOld
                --iNew
            }
        }
        while iOld >= 0 {
            result.deleted.append(iOld--)
        }
        while iNew >= 0 {
            result.inserted.append(iNew--)
        }
        if !findMoves {
            return result
        }
        // replace delete & insert of equal elements with a move
        var inserted2: [Int] = []
        for iNew in result.inserted {
            let newItem = new[iNew]
            if let (j, iOld) = findFirst(result.deleted, { compare(old[$0], newItem) }) {
                result.deleted.removeAtIndex(j)
                result.moved.append((iOld, iNew))
            } else {
                inserted2.append(iNew)
            }
        }
        result.inserted = inserted2
        return result
    }
    
    private enum LCSMove {
        case Unknown
        case FromPrevOld
        case FromPrevNew
        case Match
    }
    
    private static func findFirst<S: SequenceType>
        (source: S, _ predicate: S.Generator.Element -> Bool)
        -> (Int, S.Generator.Element)?
    {
        for (idx, s) in enumerate(source) {
            if predicate(s) {
                return (idx, s)
            }
        }
        return nil
    }
    
}
