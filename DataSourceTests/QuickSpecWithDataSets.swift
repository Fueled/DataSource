//
//  QuickSpecWithDataSets.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 04/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import UIKit
import XCTest
import DataSource
import ReactiveSwift
import Quick
import Nimble

class QuickSpecWithDataSets: QuickSpec {

	let testDataSet = Array(1...7)
	let testDataSet2 = Array(33...43)
	let testDataSet3 = Array(50...55)

	let newElement = Int.random(in: 100..<500)

	var testDataSetWithNewElement: [Int] {
		return [newElement] + testDataSet
	}

	var testDataSetWithoutFirstElement: [Int] {
		return Array(testDataSet.dropFirst())
	}

	var testDataSetWithReplacedFirstElement: [Int] {
		return Array([newElement] + testDataSet.dropFirst())
	}

	var testDataSetWithReplacedFirstWithSecondElement: [Int] {
		var testDataSetCopy = testDataSet
		testDataSetCopy.replaceSubrange(0...1, with: [testDataSet[testDataSet.index(after: testDataSet.startIndex)], testDataSet[testDataSet.startIndex]])
		return testDataSetCopy
	}

	let supplementaryItemOfKind = ["item1": Int.random(in: 500..<1000), "item2": Int.random(in: 1000..<1100)]
	let supplementaryItemOfKind2 = ["item1": Int.random(in: 5000..<10000), "item2": Int.random(in: 10000..<11000), "item3": Int.random(in: 55..<66)]

	let dataSetWithTestCellModels = [TestCellModel(), TestCellModel(), TestCellModel()]
	let dataSetWithTestCellModels2 = [TestCellModel()]
}
