//
//  AutoDiffDataSource.swift
//  DataSource
//
//  Created by Vadim Yelagin on 10/06/15.
//  Copyright (c) 2015 Fueled. All rights reserved.
//

import Foundation
import ReactiveCocoa

public final class AutoDiffDataSource<T>: DataSource {
    
    public let changes: Signal<DataChange, NoError>
    private let observer: Signal<DataChange, NoError>.Observer
    private let disposable: Disposable
    
    public let items: MutableProperty<[T]>
    
    public let supplementaryItems: [String: Any]
    
    public let compare: (T, T) -> Bool
    
    public init(_ items: [T] = [], supplementaryItems: [String: Any] = [:], _ compare: (T, T) -> Bool) {
        (self.changes, self.observer) = Signal<DataChange, NoError>.pipe()
        self.items = MutableProperty(items)
        self.supplementaryItems = supplementaryItems
        self.compare = compare
        self.disposable = self.items.producer
            |> combinePrevious(items)
            |> skip(1)
            |> map(autoDiff(compare))
            |> start(self.observer)
    }
    
    deinit {
        sendCompleted(self.observer)
        self.disposable.dispose()
    }
    
    public let numberOfSections = 1
    
    public func numberOfItemsInSection(section: Int) -> Int {
        return self.items.value.count
    }
    
    public func supplementaryItemOfKind(kind: String, inSection section: Int) -> Any? {
        return self.supplementaryItems[kind]
    }
    
    public func itemAtIndexPath(indexPath: NSIndexPath) -> Any {
        return self.items.value[indexPath.item]
    }
    
    public func leafDataSourceAtIndexPath(indexPath: NSIndexPath) -> (DataSource, NSIndexPath) {
        return (self, indexPath)
    }
    
}

private enum LCSMove {
    case Unknown
    case FromPrevOld
    case FromPrevNew
    case Match
}

// http://en.wikipedia.org/wiki/Longest_common_subsequence_problem
private func autoDiff<T>(compare: (T, T) -> Bool)(old: [T], new: [T]) -> DataChange {
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
    // collect subsequence from filled table
    var extraOld: [Int] = []
    var extraNew: [Int] = []
    var iOld = old.count - 1
    var iNew = new.count - 1
    while iOld >= 0 && iNew >= 0 {
        switch moves[iOld][iNew] {
        case .FromPrevOld:
            extraOld.append(iOld)
            --iOld
        case .FromPrevNew:
            extraNew.append(iNew)
            --iNew
        default:
            --iOld
            --iNew
        }
    }
    while iOld >= 0 {
        extraOld.append(iOld--)
    }
    while iNew >= 0 {
        extraNew.append(iNew--)
    }
    // replace delete & insert of equal elements with a move
    var batch: [DataChange] = []
    var extraNew2: [Int] = []
    for iNew in extraNew {
        let newItem = new[iNew]
        if let (j, iOld) = findFirst(extraOld, { compare(old[$0], newItem) }) {
            extraOld.removeAtIndex(j)
            let pathOld = NSIndexPath(forItem: iOld, inSection: 0)
            let pathNew = NSIndexPath(forItem: iNew, inSection: 0)
            batch.append(DataChangeMoveItem(from: pathOld, to: pathNew))
        } else {
            extraNew2.append(iNew)
        }
    }
    extraNew = extraNew2
    // add deletes and inserts
    if !extraOld.isEmpty {
        batch.append(DataChangeDeleteItems(extraOld.map{ NSIndexPath(forItem: $0, inSection: 0) }))
    }
    if !extraNew.isEmpty {
        batch.append(DataChangeInsertItems(extraNew.map{ NSIndexPath(forItem: $0, inSection: 0) }))
    }
    return DataChangeBatch(batch)
}

private func findFirst<S: SequenceType>(source: S, predicate: S.Generator.Element -> Bool) -> (Int, S.Generator.Element)? {
    for (idx, s) in enumerate(source) {
        if predicate(s) {
            return (idx, s)
        }
    }
    return nil
}
