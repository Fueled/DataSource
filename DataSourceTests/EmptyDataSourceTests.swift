//
//  EmptyDataSourceTestsNew.swift
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

class EmptyDataSourceTests: QuickSpecWithDataSets {
	override func spec() {
		var dataSource: EmptyDataSource!
		beforeEach {
			dataSource = EmptyDataSource()
		}
		it("has 0 sections") {
			expect(dataSource.numberOfSections) == 0
		}
	}
}
