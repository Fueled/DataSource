//
//  AutoDiffDataSourceTests.swift
//  DataSourceTests
//
//  Created by Aleksei Bobrov on 06/02/2019.
//  Copyright © 2019 Fueled. All rights reserved.
//

import UIKit
import XCTest
import DataSource
import ReactiveSwift
import Quick
import Nimble

class AutoDiffDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: AutoDiffDataSource<Int>!
		beforeEach {
			dataSource = AutoDiffDataSource(self.testDataSet, supplementaryItems: self.supplementaryItemOfKind, findMoves: true, compare: { $0 == $1 })
		}
		itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": [self.testDataSet]] }
		context("when changing dataSource items") {
			beforeEach {
				dataSource.items.value = self.testDataSet3
			}
			itBehavesLike("DataSource protocol") { ["DataSource": dataSource, "InitialData": [self.testDataSet3]] }
		}
	}
}

